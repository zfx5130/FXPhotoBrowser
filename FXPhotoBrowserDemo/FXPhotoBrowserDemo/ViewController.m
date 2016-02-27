//
//  ViewController.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "ViewController.h"

#import "FXPhotoBrowserManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Handlers

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    CGRect frame = sender.view.frame;
    UIImageView *imageView = (UIImageView *)sender.view;
    [[FXPhotoBrowserManager manager] showWithViewController:self
                                                  imageSize:CGSizeMake(frame.size.width, frame.size.height)
                                              selectedimage:imageView.image];
     
}

@end
