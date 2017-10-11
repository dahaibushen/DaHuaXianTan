//
//  OTSCustomLineLabel.h
//  OneStoreFramework
//
//  Created by Aimy on 9/12/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OTSCustomLineLabelLineTypeMiddle,//中间画线,默认
    OTSCustomLineLabelLineTypeNone,//没有画线
    OTSCustomLineLabelLineTypeUp,// 上边画线
    OTSCustomLineLabelLineTypeDown,//下边画线
} OTSCustomLineLabelLineType;

/**
 *  显示划去横线的label
 */
@interface OTSCustomLineLabel : UILabel
/**
 *  划去横线的位置
 */
@property(nonatomic) OTSCustomLineLabelLineType lineType;

@end
