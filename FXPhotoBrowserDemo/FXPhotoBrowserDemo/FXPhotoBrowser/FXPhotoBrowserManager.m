//
//  FXPhotoBrowserManager.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/26.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "FXPhotoBrowserManager.h"
#import "FXTransitionAnimation.h"
#import "FXPhotoBrowserController.h"

@interface FXPhotoBrowserManager ()

@end

@implementation FXPhotoBrowserManager

+ (instancetype)manager {
    static FXPhotoBrowserManager *_photoBrowserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       _photoBrowserManager = [[self alloc] init];
    });
    return _photoBrowserManager;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [FXTransitionAnimation transitionWithTransitionType:FXTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [FXTransitionAnimation transitionWithTransitionType:FXTransitionTypeDismiss];
}

#pragma mark -Public

- (void)showWithViewController:(UIViewController *)viewController
                     imageSize:(CGSize)imageSize
                 selectedimage:(UIImage *)selectedImage {
    FXPhotoBrowserController *photoBrowerController = [[FXPhotoBrowserController alloc] init];
    photoBrowerController.image = selectedImage;
    photoBrowerController.imageSize = imageSize;
    photoBrowerController.transitioningDelegate = [FXPhotoBrowserManager manager];
    photoBrowerController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:photoBrowerController
                                 animated:YES
                               completion:nil];
}

@end
