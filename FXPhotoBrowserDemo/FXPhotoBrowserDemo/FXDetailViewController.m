//
//  FXDetailViewController.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/3/2.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "FXDetailViewController.h"
#import "FXPhotoBrowser.h"
#import <UIImageView+WebCache.h>

@interface FXDetailViewController ()
<FXPhotoBrowserDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (copy, nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) UIImage *image;
@end

@interface FXDetailViewController ()

@end

@implementation FXDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    [self.clickImageView sd_setImageWithURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif"]
                           placeholderImage:[UIImage imageNamed:@"c1_settings"]];
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
    [self.clickImageView addGestureRecognizer:tapGesture];
    
}

#pragma mark - Getters

- (NSArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = @[@"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif"
                       ];
    }
    return _imageUrls;
}

#pragma mark - Handlers

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)tap:(UIGestureRecognizer *)tapGesture {
   UIImageView *imageView = (UIImageView *)tapGesture.view;
    FXPhotoBrowser *browser = [[FXPhotoBrowser alloc] initWithUIView:imageView];
    browser.currentImageIndex = imageView.tag;
    browser.dataSource = self;
    self.image = imageView.image;
    [browser show];
}

#pragma mark - FXPhotoBrowserDataSource

- (NSInteger)imageCountForPhotoBrowser:(FXPhotoBrowser *)browser {
    return [self.imageUrls count];
}

- (NSArray<NSString *> *)imageUrlsForPhotoBrowser:(FXPhotoBrowser *)browser {
    return self.imageUrls;
}

- (NSArray<UIImage *> *)placeHolderForPhotoBrowser:(FXPhotoBrowser *)browser {
    return @[self.image];
}


@end
