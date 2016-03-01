//
//  FXPhotoBrowserConfig.h
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

typedef enum {
    FXWaitingViewModeLoopDiagram, // 环形
    FXWaitingViewModePieDiagram // 饼型
} FXWaitingViewMode;

#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES


// 图片下载进度指示进度显示样式（FXWaitingViewModeLoopDiagram 环形，FXWaitingViewModePieDiagram 饼型）
#define FXWaitingViewProgressMode FXWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define FXWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
//#define FXWaitingViewBackgroundColor [UIColor clearColor]

// 图片下载进度指示器内部控件间的间距
#define FXWaitingViewItemMargin 10

