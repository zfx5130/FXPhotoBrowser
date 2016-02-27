//
//  AppDelegate.m
//  FXPhotoBrowserDemo
//
//  Created by dev on 16/2/24.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     * 展示方式:
     * 1.图片连接
     * 2.图片
     *
     * 使用方式:
     * 1.从父视图转场动画进入跳转到图片视图
     * 2.
     *
     * 设置的参数:
     * 1.图片个数,对应视图控制器
     * 2.图片链接或者或图片数组
     * 3.父视图,为设置视图控制器之间的跳转方式
     * 4.视图展示方法.
     * 5.转场动画类型
     *
     *
     *  设计原理:
     *  1.获取图片的URL.
     *  2.根据URL,请求到最大的图片.(这一过程需要下载及展示网络加载动画)
     *  2)1.点击进入下一页面,背景黑色,图片加载动画(先显示加载指示剂,后显示图片完整动画)
     *  2)2.如果加载完成,直接展示
     *  3.获取到最大的图片后,转场动画展示.
     *
     *  设计步骤:
     *  1.控制器之间的跳转(转场动画).
     *  2.图片请求处理
     *  3.图片点击放缩动画
     *  4.长按保存图片
     *  5.
     */

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
