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
<FXPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (copy, nonatomic) NSArray *imageUrls;

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
    [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:@"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"]
                            placeholderImage:[UIImage imageNamed:@"c1_settings"]];
    self.clickImageView.tag = 0;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
    UITapGestureRecognizer *secondGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
    self.secondImageView.tag = 1;
    [self.secondImageView addGestureRecognizer:tapGesture];
    [self.clickImageView addGestureRecognizer:secondGesture];
    
}

#pragma mark - Getters

- (NSArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = @[@"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif",
                       @"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
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
    FXPhotoBrowser *browser = [[FXPhotoBrowser alloc] initWithUIView:imageView
                                                    placeHolderImage:imageView.image];
    browser.currentImageIndex = imageView.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark - FXPhotoBrowserDelegate

- (NSInteger)imageCountForPhotoBrowser:(FXPhotoBrowser *)browser {
    return [self.imageUrls count];
}

- (NSArray<NSString *> *)imageUrlsForPhotoBrowser:(FXPhotoBrowser *)browser {
    return self.imageUrls;
}


@end
