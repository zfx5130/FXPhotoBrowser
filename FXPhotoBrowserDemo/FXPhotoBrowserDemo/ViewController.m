//
//  ViewController.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "ViewController.h"
#import "FXDetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *
     * 目前图片加载过程:
     * 1.默认图片大图展示0.35s后消失.
     * 2.加载大图和进度值
     * 3.加载完成
     *  
     * 要做的:
     *  1.开始默认图片和加载圈
     *  2.当图片加载完,加载圈消失,图片动画展示.
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    self.title = @"title";
    //stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"
//    _srcStringArray = @[
//                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
//                        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
//                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
//                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
//                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
//                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
//                        @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
//                        ];
}

#pragma mark - Handlers

- (IBAction)nextButtonWasPressed:(UIButton *)sender {
    FXDetailViewController *detailViewController = [[FXDetailViewController alloc] init];
    [self presentViewController:detailViewController
                       animated:YES
                     completion:nil];
}


@end
