//
//  TipChoose.m
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/22.
//

#import "TipChoose.h"
#import "TTTipView.h"

@implementation TipChoose
//自动操作提示
+ (TTTipViewAnimationOptions) automaticTip{
    return TTTipViewAnimationOptionFadeInOut | TTTipViewAnimationOptionScaleInOut | TTTipViewAnimationOptionGrowth;
}

@end
