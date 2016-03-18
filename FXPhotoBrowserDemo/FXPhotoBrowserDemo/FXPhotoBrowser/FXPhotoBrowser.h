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

@required

/**
 *  imageUrls
 *
 *  @param browser browser
 *
 *  @return urls
 */
- (NSArray<NSString *> *)imageUrlsForPhotoBrowser:(FXPhotoBrowser *)browser;

/**
 *  image count
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
@property (weak, nonatomic) id<FXPhotoBrowserDelegate> delegate;

/**
 *  initialize
 *
 *  @param selectedImageView selected imageView
 *  @param placeHolderImage placeHolder image
 *
 *  @return
 */
- (instancetype)initWithUIView:(UIView *)selectedImageView
              placeHolderImage:(UIImage *)placeHolderImage;

/**
 *  the photo browser show
 */
- (void)show;



@end
