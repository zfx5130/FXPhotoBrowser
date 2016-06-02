//
//  UIScrollView+custom.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 6/2/16.
//  Copyright © 2016 zfx5130. All rights reserved.
//

#import "UIScrollView+custom.h"

@implementation UIScrollView (custom)

- (CGRect)zoomedRectOfUIView:(UIView *)view {
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    CGRect zoomedRect;
    if (view.frame.origin.x == 0) {
        zoomedRect.origin.x = - self.contentOffset.x;
    } else {
        zoomedRect.origin.x = self.contentOffset.x ? - self.contentOffset.x * (0.5 + 0.5 * view.bounds.size.width / self.bounds.size.width) : view.frame.origin.x;
    }
    if (view.frame.origin.y == 0) {
        zoomedRect.origin.y = - self.contentOffset.y;
    } else {
        zoomedRect.origin.y = self.contentOffset.y ? - self.contentOffset.y * (0.5 + 0.5 * view.bounds.size.height / self.bounds.size.height) : view.frame.origin.y;
    }
    zoomedRect.size = view.bounds.size;
    zoomedRect.size.width *= self.zoomScale;
    zoomedRect.size.height *= self.zoomScale;
    return zoomedRect;
}

@end
