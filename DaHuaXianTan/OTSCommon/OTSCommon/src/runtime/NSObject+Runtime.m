//
//  NSObject+Runtime.m
//  OTSKit
//
//  Created by Jerry on 16/8/25.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "NSObject+Runtime.h"
#import "OTSCoreMacros.h"

@implementation OTSObjectTypeWrapper

- (instancetype)initWithObjectCProperty:(objc_property_t)property {
    if (self = [super init]) {

        const char *char_f = property_getName(property);

        _propertyName = [NSString stringWithUTF8String:char_f];

        const char *type = property_getAttributes(property);

        NSString *typeString = [NSString stringWithUTF8String:type];
        NSArray *attributes = [typeString componentsSeparatedByString:@","];
        NSString *typeAttribute = [attributes objectAtIndex:0];
        NSString *propertyType = [typeAttribute substringFromIndex:1];
        const char *rawPropertyType = [propertyType UTF8String];

        NSSet *attrSet = [NSSet setWithArray:attributes];
        if ([attrSet containsObject:@"C"]) {
            _storedType = OTSObjectStoredTypeCopy;
        } else if ([attrSet containsObject:@"&"]) {
            _storedType = OTSObjectStoredTypeAssign;
        } else if ([attrSet containsObject:@"W"]) {
            _storedType = OTSObjectStoredTypeWeak;
        } else {
            _storedType = OTSObjectStoredTypeRetain;
        }

        _isReadOnly = [attrSet containsObject:@"R"];

        if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
            _rootType = OTSObjectTypeRawNumber;
            _objTypeName = @"bool";
        } else if (strcmp(rawPropertyType, @encode(long)) == 0 || strcmp(rawPropertyType, @encode(unsigned long)) == 0 || strcmp(rawPropertyType, @encode(int)) == 0 || strcmp(rawPropertyType, @encode(unsigned int)) == 0) {
            _rootType = OTSObjectTypeRawNumber;
            _objTypeName = @"int";
        } else if (strcmp(rawPropertyType, @encode(float)) == 0 || strcmp(rawPropertyType, @encode(double)) == 0) {
            _rootType = OTSObjectTypeRawNumber;
            _objTypeName = @"float";
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            _rootType = OTSObjectTypeId;
        } else if ([typeAttribute hasPrefix:@"T@"]) {
            _rootType = OTSObjectTypeClass;

            NSString *objClassName = nil;
            NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"\"(.*)\"" options:0 error:NULL];
            NSArray *matches = [pattern matchesInString:typeAttribute
                                                options:0
                                                  range:NSMakeRange(0, [typeAttribute length])];

            for (NSTextCheckingResult *match in matches) {
                objClassName = [typeAttribute substringWithRange:[match range]];
                objClassName = [objClassName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                break;
            }

            _objTypeName = objClassName;

        } else if ([typeAttribute hasPrefix:@"T{"]) {
            NSString *subTypeAttribute = [typeAttribute substringWithRange:NSMakeRange(2, typeAttribute.length - 3)];
            NSArray *components = [subTypeAttribute componentsSeparatedByString:@"="];
            if (components.count == 2) {
                _rootType = OTSObjectTypeStruct;
                _objTypeName = components[0];
                _structElementsCount = ((NSString *) components[1]).length;
            } else {
                _rootType = OTSObjectTypeUnknown;
            }

        } else {
            _rootType = OTSObjectTypeUnknown;
        }
    }
    return self;
}

@end

@interface NSObject ()

@property(nonatomic, strong) NSMutableSet *associatedObjectNames;

@end

@implementation NSObject (Runtime)

static char associatedObjectNamesKey;

- (void)setAssociatedObjectNames:(NSMutableSet *)associatedObjectNames {
    objc_setAssociatedObject(self, &associatedObjectNamesKey, associatedObjectNames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet *)associatedObjectNames {
    NSMutableSet *array = objc_getAssociatedObject(self, &associatedObjectNamesKey);
    if (!array) {
        array = [NSMutableSet set];
        [self setAssociatedObjectNames:array];
    }
    return array;
}

- (void)setAssociatedObject:(id)object forKey:(NSString *)key policy:(OTSAssociationPolicy)policy {
    [self.associatedObjectNames addObject:key.copy];
    if (policy == OTSAssociationPolicyWeak) {
        if (object) {
            NSPointerArray *weakArray = [NSPointerArray weakObjectsPointerArray];
            [weakArray addPointer:(__bridge void *) (object)];
            objc_setAssociatedObject(self, (__bridge void *) key, weakArray, (objc_AssociationPolicy) OTSAssociationPolicyRetainNonatomic);
        } else {
            objc_setAssociatedObject(self, (__bridge void *) key, NULL, (objc_AssociationPolicy) OTSAssociationPolicyRetainNonatomic);
        }
    } else {
        objc_setAssociatedObject(self, (__bridge void *) key, object, (objc_AssociationPolicy) policy);
    }
}

- (id)getAssociatedObjectForKey:(NSString *)aKey {
    for (NSString *key in self.associatedObjectNames) {
        if ([key isEqualToString:aKey]) {
            id value = objc_getAssociatedObject(self, (__bridge void *) key);
            if ([value isKindOfClass:[NSPointerArray class]]) {
                return [value pointerAtIndex:0];
            } else {
                return value;
            }
        }
    }
    return nil;
}

- (void)removeAssociatedObjectForKey:(NSString *)key {
    [self setAssociatedObject:nil forKey:key policy:OTSAssociationPolicyAssign];
    [self.associatedObjectNames removeObject:key];
}

- (void)removeAllAssociatedObjects {
    [self.associatedObjectNames removeAllObjects];
    objc_removeAssociatedObjects(self);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    OTSLog(@"setValue %@ forUndefinedKey %@", value, key);
}

- (void)setNilValueForKey:(NSString *)key {
    OTSLog(@"setNilValue forKey %@", key);
}

static NSMutableDictionary *__propertiesMap;
static NSMutableDictionary *__propertiesRWMap;
static NSMutableDictionary *__propertiesInfoMap;

- (NSArray *)properties {
    if (!__propertiesMap) {
        __propertiesMap = [NSMutableDictionary dictionary];
    }
    NSString *mapKey = NSStringFromClass([self class]);
    NSArray *result = [__propertiesMap objectForKey:mapKey];
    if (result) {
        return result;
    }

    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    Class targetClass = [self class];
    while (targetClass != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(targetClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            [props addObject:propertyName];
        }
        free(properties);
        targetClass = [targetClass superclass];
    }

    NSArray *resultArray = props.copy;
    [__propertiesMap setObject:resultArray forKey:mapKey];
    return resultArray;
}

- (NSArray *)readWriteNonWeakProperties {
    if (!__propertiesRWMap) {
        __propertiesRWMap = [NSMutableDictionary dictionary];
    }
    NSString *mapKey = NSStringFromClass([self class]);
    NSArray *result = [__propertiesRWMap objectForKey:mapKey];
    if (result) {
        return result;
    }

    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    Class targetClass = [self class];
    while (targetClass != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(targetClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_f = property_getName(property);
            const char *char_type = property_getAttributes(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            NSString *typeName = [NSString stringWithUTF8String:char_type];

            NSArray *typeComponents = [typeName componentsSeparatedByString:@","];
            NSSet *typeSet = [NSSet setWithArray:typeComponents];
            if ([typeSet containsObject:@"W"] || [typeSet containsObject:@"R"]) {
                continue;
            }
            [props addObject:propertyName];
        }
        free(properties);
        targetClass = [targetClass superclass];
    }

    NSArray *resultArray = props.copy;
    [__propertiesRWMap setObject:resultArray forKey:mapKey];
    return resultArray;
}

- (NSDictionary *)propertyInfos {
    if (!__propertiesInfoMap) {
        __propertiesInfoMap = [NSMutableDictionary dictionary];
    }
    NSString *mapKey = NSStringFromClass([self class]);
    NSDictionary *result = [__propertiesInfoMap objectForKey:mapKey];
    if (result) {
        return result;
    }

    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    Class targetClass = [self class];
    while (targetClass != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(targetClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            OTSObjectTypeWrapper *wrapper = [[OTSObjectTypeWrapper alloc] initWithObjectCProperty:property];
            if (wrapper) {
                [props setObject:wrapper forKey:wrapper.propertyName ?: @""];
            }
        }
        free(properties);
        targetClass = [targetClass superclass];
    }
    NSDictionary *resultDict = props.copy;
    [__propertiesInfoMap setObject:resultDict forKey:mapKey];
    return resultDict;
}

+ (BOOL)overrideMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    if (!origMethod) {
        OTSLog(@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }

    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        OTSLog(@"original method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }

    method_setImplementation(origMethod, class_getMethodImplementation(self, altSel));
    return YES;
}

+ (BOOL)overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel {
    Class c = object_getClass(self);
    return [c overrideMethod:origSel withMethod:altSel];
}

+ (BOOL)exchangeMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method originMethod = class_getInstanceMethod(self, origSel);
    if (!originMethod) {
        OTSLog(@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }

    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        OTSLog(@"original method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }

    BOOL didAddMethod = class_addMethod(self,
            origSel,
            method_getImplementation(altMethod),
            method_getTypeEncoding(altMethod));
    if (didAddMethod) {
        class_replaceMethod(self,
                altSel,
                method_getImplementation(originMethod),
                method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, altMethod);
    }
    return YES;
}

+ (BOOL)exchangeClassMethod:(SEL)origSel withClassMethod:(SEL)altSel {
    Class c = object_getClass(self);
    return [c exchangeMethod:origSel withMethod:altSel];
}

@end
