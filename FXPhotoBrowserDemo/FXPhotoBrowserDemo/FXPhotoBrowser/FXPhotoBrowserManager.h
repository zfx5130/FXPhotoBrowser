//
//  FXPhotoBrowserManager.h
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/26.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FXPhotoBrowserManager : NSObject<UIViewControllerTransitioningDelegate>

+ (instancetype)manager;

- (void)showWithViewController:(UIViewController *)viewController
                     imageSize:(CGSize)imageSize
                 selectedimage:(UIImage *)selectedImage;

@end
