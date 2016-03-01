//
//  FXPhotoBrowser.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "FXPhotoBrowser.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "FXPhotoBrowserView.h"

#import "FXPhotoBrowserConfig.h"

static const CGFloat kDefaultAnimationDuration = 0.35f;
static const CGFloat kPageControlHeight = 50.0f;
static const CGFloat kDefaultImageViewPadding = 10.0f;
static const CGFloat kDefaultShowImageAnimationDuration = 0.35f;

@interface FXPhotoBrowser ()
<UIScrollViewDelegate,
UIAlertViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL hasShowedFistView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIView *contentView;

@end

@implementation FXPhotoBrowser

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self setupScrollView];
    [self setupToolbars];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    rect.size.width += kDefaultImageViewPadding * 2;
    self.scrollView.bounds = rect;
    self.scrollView.center = CGPointMake(kScreenWidth * 0.5f,
                                         KScreenHeight * 0.5f);
    CGFloat y = 0.0f;
    __block CGFloat width = self.scrollView.frame.size.width - kDefaultImageViewPadding * 2;
    CGFloat height = self.scrollView.frame.size.height;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(FXPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = kDefaultImageViewPadding + idx * (kDefaultImageViewPadding * 2 + width);
        obj.frame = CGRectMake(x, y, width, height);
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.subviews.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.currentImageIndex * self.scrollView.frame.size.width, 0);
    if (!self.hasShowedFistView) {
        [self showFirstImage];
    }
}

#pragma mark - Private

- (void)setupToolbars {
    CGRect frame = CGRectMake(0.0f,
                              KScreenHeight - kPageControlHeight,
                              kScreenWidth,
                              kPageControlHeight);
    self.pageControl = [[UIPageControl alloc] initWithFrame:frame];
    self.pageControl.numberOfPages = self.imageCount;
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:self.pageControl];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        FXPhotoBrowserView *view = [[FXPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        __weak typeof(self) weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            [weakSelf handleSingleTap:recognizer];
        };
        view.longPressBlock = ^(UILongPressGestureRecognizer *recognizer) {
            [weakSelf handleLongPress:recognizer];
        };
        view.doublePressBlock = ^(UITapGestureRecognizer *recognizer) {
            [weakSelf handleDoubleTap:recognizer];
        };
        [self.scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

- (void)setupImageOfImageViewForIndex:(NSInteger)index {
    FXPhotoBrowserView *view = self.scrollView.subviews[index];
    if (view.beginLoadingImage) {
        return;
    }
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index]
             placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}

- (void)show {
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor blackColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.center = window.center;
    self.contentView.bounds = window.bounds;
    self.center = CGPointMake(CGRectGetWidth(window.frame) * 0.5f,
                              CGRectGetHeight(window.frame) * 0.5f);
    self.bounds = CGRectMake(0,
                             0,
                             CGRectGetWidth(window.frame),
                             CGRectGetHeight(window.frame));
    [self.contentView addSubview:self];
    window.windowLevel = UIWindowLevelStatusBar + 10.0f;
    [window addSubview:self.contentView];
}

- (void)showFirstImage {
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame
                                                       toView:self];
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.frame = rect;
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self addSubview:tempView];
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat placeImageSizeWidth = tempView.image.size.width;
    CGFloat placeImageSizeHeight = tempView.image.size.height;
    
    NSLog(@":::::w::%@:::h::%@",@(placeImageSizeWidth), @(placeImageSizeHeight));
    
    CGFloat placeHolderH = (placeImageSizeHeight * kScreenWidth) / placeImageSizeWidth;
    CGRect targetTemp;
    if (placeHolderH <= KScreenHeight) {
        targetTemp = CGRectMake(0,
                                (KScreenHeight - placeHolderH) * 0.5,
                                kScreenWidth,
                                placeHolderH);
    } else {
        targetTemp = CGRectMake(0,
                                0,
                                kScreenWidth,
                                placeHolderH);
    }
    self.scrollView.hidden = YES;
    [UIView animateWithDuration:kDefaultShowImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        self.hasShowedFistView = YES;
        [tempView removeFromSuperview];
        self.scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

- (void)showAlertMessageWithTitle:(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex && alertView.tag == 100) {
        FXPhotoBrowserView *currentView = self.scrollView.subviews[self.currentImageIndex];
        UIImageWriteToSavedPhotosAlbum(currentView.imageview.image,
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       NULL);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x + self.scrollView.bounds.size.width * 0.5) / self.scrollView.bounds.size.width;
    self.pageControl.currentPage = index;
    NSInteger left = index - 1;
    NSInteger right = index + 1;
    left = left > 0 ? left : 0;
    right = right > self.imageCount ? self.imageCount : right;
    for (NSInteger i = left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.currentImageIndex = index;
    for (FXPhotoBrowserView *view in self.scrollView.subviews) {
        if (view.imageview.tag != index) {
            view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark - Handlers

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    if (error) {
        [self showAlertMessageWithTitle:NSLocalizedString(@"保存失败", @"保存失败的提示")];
    } else {
        [self showAlertMessageWithTitle:NSLocalizedString(@"保存成功", @"保存成功的提示")];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:@"是否保存图片到相册"
                               message:nil
                              delegate:self
                     cancelButtonTitle:@"否"
                     otherButtonTitles:@"是", nil];
    alertView.tag = 100;
    [alertView show];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    FXPhotoBrowserView *view = (FXPhotoBrowserView *)recognizer.view;
    if (!view.hasLoadedImage) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
        [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    FXPhotoBrowserView *currentView = self.scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0
                                animated:YES];
    [self hidePhotoBrowser:recognizer];
}

- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer {
    NSLog(@"::sinple::hidden:::view:");
    FXPhotoBrowserView *view = (FXPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    NSUInteger currentIndex = currentImageView.tag;
    UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame
                                                             toView:self];
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    CGFloat tempImageSizeHeight = tempImageView.image.size.height;
    CGFloat tempImageSizeWidth = tempImageView.image.size.width;
    CGFloat tempImageViewHeight = (tempImageSizeHeight * kScreenWidth) / tempImageSizeWidth;
    
    CGRect frame;
    if (tempImageViewHeight < KScreenHeight) {
        frame = CGRectMake(0,
                           (KScreenHeight - tempImageViewHeight) * 0.5f,
                           kScreenWidth,
                           tempImageViewHeight);
    } else {
        frame = CGRectMake(0,
                           0,
                           kScreenWidth,
                           tempImageViewHeight);
    }
    tempImageView.frame = frame;
    [self addSubview:tempImageView];
    self.scrollView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelNormal;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [tempImageView removeFromSuperview];
    }];
}

@end