//
//  FXWaitingView.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "FXWaitingView.h"

static const CGFloat kDefaultWaitingViewItemMargin = 5.0f;

@implementation FXWaitingView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - Setters

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.width = 40.0f;
    frame.size.height = 40.0f;
    self.layer.cornerRadius = 20.0f;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat xCenter = rect.size.width * 0.5f;
    CGFloat yCenter = rect.size.height * 0.5f;
    CGFloat to = - M_PI * 0.5f + self.progress * M_PI * 2 + 0.05f;
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5f - kDefaultWaitingViewItemMargin;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 0.7f);
    CGContextSetLineWidth(ctx, 4);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5f, 1.5f * M_PI + 0.05f, 0.0f);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetLineWidth(ctx, 4);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5f, to, 0);
    CGContextStrokePath(ctx);
    
    
    
}

@end
