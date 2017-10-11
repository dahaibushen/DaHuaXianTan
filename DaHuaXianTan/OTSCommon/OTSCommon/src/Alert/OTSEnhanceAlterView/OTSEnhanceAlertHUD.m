//
//  OTSEnhanceAlertHUD.m
//  OneStoreFramework
//
//  Created by ChaiJun on 15/8/31.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import "OTSEnhanceAlertHUD.h"

//获取系统版本号
#define OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
////判断系统版本 大于等于(great or equal to)版本号
#define OS_VERSION_G_E(version) (OS_VERSION >= version)

//检测float值 是否相等

#define kALAnimationDuration 0.3f

typedef NS_ENUM(NSInteger, OTSEnhanceAlterHUDStatus){
    OTSEnhanceAlterHUDStatusOfNone = 0,
    OTSEnhanceAlterHUDStatusOfShowing,
};

@interface OTSEnhanceAlterContentModel : NSObject

@property (nonatomic, weak) id<OTSEnhanceAlertHUDDelegate> delegate;
@property (nonatomic, strong) OTSEnhanceAlterView *alertView;

@end

@implementation OTSEnhanceAlterContentModel

@end

/***********************************************************************/

/*
 * 注意：
 * 在ios8上， UIScreen.bounds,UIViewController.iew.size, 是随着屏幕方向旋转变化的，所以设置子View的mask即可自动旋转
 * 但是在ios6、7，这些尺寸都是保持竖屏的尺寸不变，所以，子view的旋转，是需要自己在controller的willAnimateRotationToInterfaceOrientation设置旋转后的位置。
 **/
@interface OTSEnhanceAlterViewController : UIViewController

@property (nonatomic, strong) UIView *showingView;

- (void)addShowingView:(UIView *)showingView;
- (void)removeShowingView;

@end

@implementation OTSEnhanceAlterViewController
#pragma mark - rotation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (_showingView && (!OS_VERSION_G_E(8))) {
        [self moveShowingViewToCenterWithOrientation:toInterfaceOrientation];
    }
}

#pragma mark - Function - Public

- (void)addShowingView:(UIView *)showingView{
    if (self.showingView) {
        [_showingView removeFromSuperview];
    }
    self.showingView = showingView;
    [self.view addSubview:_showingView];
    if (OS_VERSION_G_E(8)) {
        _showingView.centerX = self.view.width/2;
        _showingView.centerY = self.view.height/2;
    }else{
        [self moveShowingViewToCenterWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    
}

- (void)removeShowingView{
    if (self.showingView) {
        [_showingView removeFromSuperview];
    }
    self.showingView = nil;
}

#pragma mark - Function - Private

- (void)moveShowingViewToCenterWithOrientation:(UIInterfaceOrientation)orientation{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _showingView.centerX = self.view.width/2;
        _showingView.centerY = self.view.height/2;
    }else if(UIInterfaceOrientationIsLandscape(orientation)){
        _showingView.centerX = self.view.height/2;
        _showingView.centerY = self.view.width/2;
    }
    
}

@end

/***********************************************************************/

@interface OTSEnhanceAlertHUD()<OTSEnhanceAlertHUDDelegate>

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) OTSEnhanceAlterContentModel *modelOfShowing;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation OTSEnhanceAlertHUD

+ (instancetype)sharedInstance{
    static OTSEnhanceAlertHUD *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[[self class] alloc] init];
        
        sInstance.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        sInstance.alertWindow.backgroundColor = [UIColor clearColor];  //很重要，要不然屏幕旋转的动画为黑色
        sInstance.alertWindow.windowLevel = UIWindowLevelAlert;
        [sInstance.alertWindow setHidden:YES];
        
        //controller
        OTSEnhanceAlterViewController *controller = [[OTSEnhanceAlterViewController alloc] init];
        sInstance.alertWindow.rootViewController = controller;
        
        //bgackground
        UIView *bgView = [[UIView alloc] init];
        bgView.origin = CGPointZero;
        bgView.size = controller.view.size;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|
        UIViewAutoresizingFlexibleWidth;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0;
        bgView.transform = CGAffineTransformMakeScale(4, 4); //防止statusBar没有覆盖到
        sInstance.bgView = bgView;
        
        [controller.view addSubview:bgView];
        
        sInstance.models = [NSMutableArray arrayWithCapacity:3];
        
    });
    
    return sInstance;
}

#pragma mark - Function - Public

+ (OTSEnhanceAlterView *)showWithTitle:(NSAttributedString *)title
                       message:(NSAttributedString *)message
                      delegate:(id /*<BMAlertViewDelegate>*/)delegate
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitles, ...{
    NSMutableArray *btnTitles = [NSMutableArray arrayWithCapacity:2];
    if (cancelButtonTitle) {
        [btnTitles addObject:cancelButtonTitle];
    }
    if (otherButtonTitles) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *tmpStr = otherButtonTitles; tmpStr != nil; tmpStr = va_arg(args, NSString *)) {
            [btnTitles addObject:tmpStr];
        }
    }
    
    OTSEnhanceAlertHUD *hud = [OTSEnhanceAlertHUD sharedInstance];
    
    OTSEnhanceAlterView *alertView = [[OTSEnhanceAlterView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:hud
                                                         titles:btnTitles];
    if (OS_VERSION_G_E(8)) {
        alertView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|
        UIViewAutoresizingFlexibleRightMargin|
        UIViewAutoresizingFlexibleTopMargin|
        UIViewAutoresizingFlexibleBottomMargin;
    }
    OTSEnhanceAlterContentModel *model = [[OTSEnhanceAlterContentModel alloc] init];
    model.delegate = delegate;
    model.alertView = alertView;
    
    //将显示中的AlertView拉回，暂存起来，显示新的AlertView
    [self fetchShowingAlertModel];
    
    [self showAlertWithModel:model];
    
    return alertView;
}

#pragma mark - Function - Private

+ (void)fetchShowingAlertModel{
    OTSEnhanceAlertHUD *hud = [OTSEnhanceAlertHUD sharedInstance];
    if (hud.modelOfShowing != nil) {
        [hud.models addObject:hud.modelOfShowing];
        [self hideShowingAlertView];
    }
}

+ (void)hideShowingAlertView{
    OTSEnhanceAlertHUD *hud = [OTSEnhanceAlertHUD sharedInstance];
    OTSEnhanceAlterViewController *rootController = (OTSEnhanceAlterViewController *)hud.alertWindow.rootViewController;
    
    [rootController removeShowingView];
    hud.bgView.hidden = YES;
    hud.modelOfShowing = nil;
    hud.alertWindow.hidden = YES;
    [hud.alertWindow resignKeyWindow];
}

+ (void)showAlertWithModel:(OTSEnhanceAlterContentModel *)model{
    [OTSEnhanceAlertHUD sharedInstance].modelOfShowing = model;
    OTSEnhanceAlterView *alertView = model.alertView;
    
    OTSEnhanceAlterViewController *rootController = (OTSEnhanceAlterViewController *)[OTSEnhanceAlertHUD sharedInstance].alertWindow.rootViewController;
    
    alertView.alpha = 0.1f;
    alertView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    
    OTSEnhanceAlertHUD *hud = [OTSEnhanceAlertHUD sharedInstance];
    hud.bgView.alpha = 0;
    hud.bgView.hidden = NO;
    [rootController addShowingView:alertView];
    
    hud.alertWindow.hidden = NO;
    [hud.alertWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:kALAnimationDuration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         alertView.alpha = 1;
                         alertView.transform = CGAffineTransformIdentity;
                         hud.bgView.alpha = 0.3f;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

+ (void)handleAlertFinish{
    
    [self hideShowingAlertView];
    
    OTSEnhanceAlertHUD *hud = [OTSEnhanceAlertHUD sharedInstance];
    
    if ([hud.models count] > 0) {
        OTSEnhanceAlterContentModel *tmpModel = hud.models.lastObject;
        [hud.models removeLastObject];
        [self showAlertWithModel:tmpModel];
    }
}

#pragma mark - BMAlertViewDelegate

- (void)bmAlertView:(OTSEnhanceAlterView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.modelOfShowing.delegate respondsToSelector:@selector(bmAlertView:clickedButtonAtIndex:)]) {
        [self.modelOfShowing.delegate bmAlertView:alertView
                             clickedButtonAtIndex:buttonIndex];
    }
    
    [OTSEnhanceAlertHUD handleAlertFinish];
}

@end
