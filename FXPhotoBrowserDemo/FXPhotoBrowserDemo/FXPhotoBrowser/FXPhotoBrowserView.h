//
//  FXPhotoBrowserView.h
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXPhotoBrowserView : UIView

/**
 *  the scrollView
 */
@property (strong, nonatomic, readonly) UIScrollView *scrollview;

/**
 *  imageview
 */
@property (strong, nonatomic, readonly) UIImageView *imageview;

/**
 *  the image load progress
 */
@property (assign, nonatomic) CGFloat progress;

/**
 *  begin loading image
 */
@property (assign, nonatomic) BOOL beginLoadingImage;

/**
 *  has loading Image
 */
@property (assign, nonatomic, readonly) BOOL hasLoadedImage;

/**
 *  single tap block
 */
@property (strong, nonatomic) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

/**
 *  long press block
 */
@property (strong, nonatomic) void (^longPressBlock)(UILongPressGestureRecognizer *recognizer);

/**
 *  double press block
 */
@property (strong, nonatomic) void (^doublePressBlock)(UITapGestureRecognizer *recognizer);

/**
 *  set image with url
 *
 *  @param url         url
 *  @param placeholder placeholder
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder;

@end
