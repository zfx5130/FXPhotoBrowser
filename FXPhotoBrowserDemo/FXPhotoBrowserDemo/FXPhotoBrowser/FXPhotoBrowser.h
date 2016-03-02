//
//  FXPhotoBrowser.h
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXPhotoBrowser;

@protocol FXPhotoBrowserDelegate <NSObject>

/**
 *  the placeholder image
 *
 *  @param browser self
 *  @param index   current index
 *
 *  @return current image
 */

- (UIImage *)photoBrowser:(FXPhotoBrowser *)browser
 placeholderImageForIndex:(NSInteger)index;

/**
 *  the highQualityImage Url
 *
 *  @param browser self
 *  @param index   current index
 *
 *  @return current imageurl
 */

- (NSURL *)photoBrowser:(FXPhotoBrowser *)browser
highQualityImageURLForIndex:(NSInteger)index;

@end

@interface FXPhotoBrowser : UIView <UIScrollViewDelegate>

/**
 *  the image container view.
 */
@property (weak, nonatomic) UIView *sourceImageView;

/**
 *  the image Count, if the image count is one, you can not set it, default imagecount is one.
 */
@property (assign, nonatomic) NSInteger imageCount;

/**
 *  the current ImageIndex, if the image count is one, you can not set it.
 */
@property (assign, nonatomic) NSInteger currentImageIndex;

/**
 *  delegate
 */
@property (weak, nonatomic) id<FXPhotoBrowserDelegate> delegate;

/**
 *  the photo bro
 */
- (void)show;

@end
