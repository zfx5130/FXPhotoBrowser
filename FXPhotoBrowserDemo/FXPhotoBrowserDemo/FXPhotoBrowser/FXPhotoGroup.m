//
//  FXPhotoGroup.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "FXPhotoGroup.h"
#import "FXPhotoItem.h"
#import "UIButton+WebCache.h"
#import "FXPhotoBrowser.h"

static const CGFloat kDefaultImageMargin = 10.0f;

@interface FXPhotoGroup ()
<FXPhotoBrowserDelegate>

@end

@implementation FXPhotoGroup 

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[SDWebImageManager sharedManager].imageCache clearDisk];
    }
    return self;
}

- (void)setPhotoItemArray:(NSArray *)photoItemArray {
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(FXPhotoItem *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic]
                       forState:UIControlStateNormal
               placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
        btn.tag = idx;
        [btn addTarget:self
                action:@selector(buttonClick:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    long imageCount = self.photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    CGFloat width = 80.0f;
    CGFloat height = 80.0f;
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (width + kDefaultImageMargin);
        CGFloat y = rowIndex * (height + kDefaultImageMargin);
        btn.frame = CGRectMake(x, y, width, height);
    }];
    self.frame = CGRectMake(10.0f,
                            10.0f,
                            280.0f,
                            totalRowCount * (kDefaultImageMargin + height));
}

- (void)buttonClick:(UIButton *)button {
    FXPhotoBrowser *browser = [[FXPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photoItemArray.count;
    browser.currentImageIndex = (int)button.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark - FXPhotoBrowserDelegate

- (UIImage *)photoBrowser:(FXPhotoBrowser *)browser
 placeholderImageForIndex:(NSInteger)index {
    return [self.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(FXPhotoBrowser *)browser
highQualityImageURLForIndex:(NSInteger)index {
    NSString *urlStr =
    [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail"
                                                                          withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
