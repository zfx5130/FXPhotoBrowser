//
//  FXPhotoBrowserController.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "FXPhotoBrowserController.h"
#import <DGActivityIndicatorView.h>

static NSString *const kDefaultImageName = @"default_image";
static const CGFloat kDefaultImageSize = 100.0f;

@interface FXPhotoBrowserController ()
<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) DGActivityIndicatorView *indicatorView;

@end

@implementation FXPhotoBrowserController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片浏览器";
    self.view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismiss)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //设置
    [self setupViews];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    UIImage *image = [UIImage imageNamed:kDefaultImageName];
    [self.view addSubview:self.imageView];
    self.imageView.image = !self.image ? image : self.image;
    CGFloat width = self.imageSize.width > 0 ? self.imageSize.width : kDefaultImageSize;
    CGFloat height = self.imageSize.height > 0 ? self.imageSize.height : kDefaultImageSize;
    self.imageView.bounds = CGRectMake(0.0f, 0.0f, width, height);
    
    //设置indicator

    [self setupIndicatorView];
}

#pragma mark - Private

- (void)setupIndicatorView {
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.center = self.view.center;
        _imageView.bounds = CGRectMake(0.0f, 0.0f, kDefaultImageSize, kDefaultImageSize);
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (DGActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView =
        [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader
                                            tintColor:[UIColor whiteColor]];
        _indicatorView.center = self.view.center;
    }
    return _indicatorView;
}

#pragma mark - Handlers 

- (void)dismiss {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
