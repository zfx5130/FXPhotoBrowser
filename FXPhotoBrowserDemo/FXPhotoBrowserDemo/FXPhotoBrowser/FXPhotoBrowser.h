//
//  FXPhotoBrowser.h
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXPhotoBrowser;

@protocol FXPhotoBrowserDataSource <NSObject>

/**
 *  imageUrls
 *
 *  @param browser browser
 *
 *  @return urls
 */
- (NSArray<NSString *> *)imageUrlsForPhotoBrowser:(FXPhotoBrowser *)browser;

/**
 *  images
 *
 *  @param placeHolderImage
 *
 *  @return the palceHolderImages
 */
- (NSArray<UIImage *> *)placeHolderForPhotoBrowser:(FXPhotoBrowser *)browser;

@optional

/**
 *  image count, default the image count is 1
 *
 *  @param browser browser
 *
 *  @return imageCount
 */
- (NSInteger)imageCountForPhotoBrowser:(FXPhotoBrowser *)browser;

@end

@interface FXPhotoBrowser : UIView <UIScrollViewDelegate>

/**
 *  the current ImageIndex, if the image count is one, you can not set it.
 */
@property (assign, nonatomic) NSInteger currentImageIndex;

/**
 *  delegate
 */
@property (weak, nonatomic) id<FXPhotoBrowserDataSource> dataSource;

/**
 *  initialize
 *
 *  @param selectedImageView selected imageView
 *
 *  @return
 */
- (instancetype)initWithUIView:(UIView *)selectedImageView;

/**
 *  the photo browser show
 */
- (void)show;

@end
