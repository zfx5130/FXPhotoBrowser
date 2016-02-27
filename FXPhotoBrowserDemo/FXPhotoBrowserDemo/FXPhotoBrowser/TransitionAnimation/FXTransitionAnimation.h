//
//  FXTransitionAnimation.h
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/26.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FXTransitionType) {
    FXTransitionTypePresent = 1,
    FXTransitionTypeDismiss
};

@interface FXTransitionAnimation : NSObject
<UIViewControllerAnimatedTransitioning>

/**
 *  the transition animation interval time, default is 0.5f
 */
@property (assign, nonatomic) NSTimeInterval timeInterval;

/**
 *  initialize
 *
 *  @param transitionType transition type
 *
 *  @return 
 */
- (instancetype)initWithTransitionType:(FXTransitionType)transitionType;
+ (instancetype)transitionWithTransitionType:(FXTransitionType)transitionType;

@end
