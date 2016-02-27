//
//  FXTransitionAnimation.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/26.
//  Copyright © 2016年 zfx5130. All rights reserved.
//


#import "FXTransitionAnimation.h"
#import <UIKit/UIKit.h>

static const CGFloat kDefaultTimeInterval = 0.1f;

@interface FXTransitionAnimation ()

@property (strong, nonatomic) id <UIViewControllerContextTransitioning> transitionContext;
@property (assign, nonatomic) FXTransitionType transitionType;

@end

@implementation FXTransitionAnimation

#pragma mark - Public

- (instancetype)initWithTransitionType:(FXTransitionType)transitionType {
    self = [super init];
    if (self) {
        self.transitionType = transitionType;
        self.timeInterval = kDefaultTimeInterval;
    }
    return self;
}

+ (instancetype)transitionWithTransitionType:(FXTransitionType)transitionType {
    return [[FXTransitionAnimation alloc] initWithTransitionType:transitionType];
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.timeInterval;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case FXTransitionTypePresent: {
            [self presentTransitionAnimation:transitionContext];
            break;
        }
        case FXTransitionTypeDismiss: {
            [self dismissTransitionAnimation:transitionContext];
            break;
        }
    }
}

#pragma mark - Private

- (void)presentTransitionAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    self.transitionContext = transitionContext;
    [containerView addSubview:toViewController.view];
    
    toViewController.view.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.timeInterval
                          delay:0.0f
         usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:0 animations:^{
             
             fromViewController.view.alpha = 0.0f;
             toViewController.view.alpha = 1.f;
             
         } completion:^(BOOL finished) {
             [weakSelf completeTransition];
         }];
}

- (void)dismissTransitionAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController=
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.transitionContext = transitionContext;
    toViewController.view.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.timeInterval
                          delay:0.0f
         usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:0 animations:^{
             
             fromViewController.view.alpha = 0.0f;
             toViewController.view.alpha = 1.0f;
             
         } completion:^(BOOL finished) {
             [weakSelf completeTransition];
         }];
}

- (void)completeTransition {
   [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
}

@end
