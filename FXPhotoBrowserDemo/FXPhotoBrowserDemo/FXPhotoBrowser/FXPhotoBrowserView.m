//
//  FXPhotoBrowserView.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "FXPhotoBrowserView.h"
#import "FXWaitingView.h"
#import "UIImageView+WebCache.h"

static const CGFloat kMinZoomScale = 0.6f;
static const CGFloat kMaxZoomScale = 2.0f;

@interface FXPhotoBrowserView()
<UIScrollViewDelegate>

@property (strong, nonatomic) FXWaitingView *waitingView;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTap;
@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) UIImage *placeHolderImage;
@property (strong, nonatomic) UIButton *reloadButton;
@property (assign, nonatomic) BOOL hasLoadedImage;
@property (strong, nonatomic) UIScrollView *scrollview;
@property (strong, nonatomic) UIImageView *imageview;

@end

@implementation FXPhotoBrowserView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollview];
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.longPressGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.waitingView.center = CGPointMake(self.bounds.size.width * 0.5f,
                                          self.bounds.size.height * 0.5f);
    self.scrollview.frame = self.bounds;
    self.waitingView.center = self.scrollview.center;
    [self adjustFrame];
}


#pragma mark - Setters

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _waitingView.progress = progress;
}

#pragma mark - Getters

- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0,
                                       0,
                                       kScreenWidth,
                                       KScreenHeight);
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
    }
    return _scrollview;
}

- (UIImageView *)imageview {
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.frame = CGRectMake(0,
                                      0,
                                      kScreenWidth,
                                      KScreenHeight);
        _imageview.userInteractionEnabled = YES;
    }
    return _imageview;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLongPressGesture:)];
        _longPressGesture.minimumPressDuration = 1.0f;
    }
    return _longPressGesture;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        
    }
    return _singleTap;
}

#pragma mark - Private

- (void)adjustFrame {
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;
        CGRect imageFrame = CGRectMake(0.0f,
                                       0.0f,
                                       imageSize.width,
                                       imageSize.height);
        CGFloat ratio = frame.size.width / imageFrame.size.width;
        imageFrame.size.height = imageFrame.size.height * ratio;
        imageFrame.size.width = frame.size.width;
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
    
        CGFloat maxScale = frame.size.height / imageFrame.size.height;
        maxScale = frame.size.width / imageFrame.size.width > maxScale ? frame.size.width / imageFrame.size.width : maxScale;
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    } else {
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5f : 0.0f;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5f : 0.0f;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5f + offsetX,
                                       scrollView.contentSize.height * 0.5f + offsetY);
    return actualCenter;
}

#pragma mark - Handlers

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    if (self.doublePressBlock) {
        self.doublePressBlock(recognizer);
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock(longPressGesture);
        }
    }
}

#pragma mark - Public

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder {
    if (self.reloadButton) {
        [self.reloadButton removeFromSuperview];
    }
    self.imageUrl = url;
    self.placeHolderImage = placeholder;
    FXWaitingView *waitingView = [[FXWaitingView alloc] init];
    waitingView.center = CGPointMake(kScreenWidth * 0.5, KScreenHeight * 0.5);
    self.waitingView = waitingView;
    [self addSubview:waitingView];
    __weak typeof(self) weakSelf = self;
    [self.imageview sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.waitingView.progress = (CGFloat)receivedSize / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.waitingView removeFromSuperview];
        if (error) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            weakSelf.reloadButton = button;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            button.bounds = CGRectMake(0, 0, 200.0f, 40.0f);
            button.center = CGPointMake(kScreenWidth * 0.5f,
                                        KScreenHeight * 0.5f);
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            button.backgroundColor = [UIColor colorWithRed:0.1f
                                                     green:0.1f
                                                      blue:0.1f
                                                     alpha:0.3f];
            [button setTitle:NSLocalizedString(@"原图加载失败，点击重新加载", @"加载失败的信息")
                    forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
            [button addTarget:weakSelf
                       action:@selector(reloadImage)
             forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            return;
        }
        weakSelf.hasLoadedImage = YES;
    }];
}

#pragma mark - Handlers

- (void)reloadImage {
    [self setImageWithURL:self.imageUrl
         placeholderImage:self.placeHolderImage];
}

#pragma mark -UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
}

@end
