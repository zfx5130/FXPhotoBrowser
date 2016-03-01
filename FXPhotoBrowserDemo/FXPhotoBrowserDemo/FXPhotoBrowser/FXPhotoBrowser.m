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
<UIScrollViewDelegate>

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
            [weakSelf photoClick:recognizer];
        };
        view.longPressBlock = ^(UILongPressGestureRecognizer *recognizer) {
            [weakSelf saveImage:recognizer];
        };
        [self.scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

- (void)saveImage:(UILongPressGestureRecognizer *)recognizer {
    FXPhotoBrowserView *currentView = self.scrollView.subviews[self.currentImageIndex];
    UIImageWriteToSavedPhotosAlbum(currentView.imageview.image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   NULL);
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
    
    NSLog(@"::::::::frame:::::%@", NSStringFromCGRect(tempView.frame));
    CGFloat placeImageSizeWidth = tempView.image.size.width;
    CGFloat placeImageSizeHeight = tempView.image.size.height;
    CGRect targetTemp;

    CGFloat placeHolderH = (placeImageSizeHeight * kScreenWidth) / placeImageSizeWidth;
    if (placeHolderH <= KScreenHeight) {
        targetTemp = CGRectMake(0, (KScreenHeight - placeHolderH) * 0.5 , kScreenWidth, placeHolderH);
    } else {//图片高度>屏幕高度
        targetTemp = CGRectMake(0, 0, kScreenWidth, placeHolderH);
    }
    
    //先隐藏scrollview
    _scrollView.hidden = YES;

    [UIView animateWithDuration:kDefaultShowImageAnimationDuration animations:^{
        //将点击的临时imageview动画放大到和目标imageview一样大
        tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        //动画完成后，删除临时imageview，让目标imageview显示
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    self.pageControl.currentPage = index;
    
    long left = index - 1;
    long right = index + 1;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    for (long i = left; i < right; i++) {
         [self setupImageOfImageViewForIndex:i];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (FXPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
                view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark - tap

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    FXPhotoBrowserView *view = (FXPhotoBrowserView *)recognizer.view;
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
    
    CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
    CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
    [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
    
}

#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    FXPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)UIDeviceOrientationPortrait];
            self.transform = CGAffineTransformIdentity;
            self.bounds = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self hidePhotoBrowser:recognizer];
        }];
    } else {
        [self hidePhotoBrowser:recognizer];
    }
}

- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    FXPhotoBrowserView *view = (FXPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    NSUInteger currentIndex = currentImageView.tag;
    UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    CGFloat tempImageSizeH = tempImageView.image.size.height;
    CGFloat tempImageSizeW = tempImageView.image.size.width;
    CGFloat tempImageViewH = (tempImageSizeH * kScreenWidth)/tempImageSizeW;
    
    if (tempImageViewH < KScreenHeight) {//图片高度<屏幕高度
        tempImageView.frame = CGRectMake(0, (KScreenHeight - tempImageViewH)*0.5, kScreenWidth, tempImageViewH);
    } else {
        tempImageView.frame = CGRectMake(0, 0, kScreenWidth, tempImageViewH);
    }
    [self addSubview:tempImageView];
    
    _scrollView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        [tempImageView removeFromSuperview];
    }];
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

@end
