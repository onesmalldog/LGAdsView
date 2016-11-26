//
//  LGAdsView.h
//  LGAppTool
//
//  Created by 东途 on 2016/11/26.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGAdsView : UIView
+ (instancetype)lg_createAdsWithImages:(NSArray <UIImage *>*)imgArr height:(CGFloat)h;
/** first is 0 */
@property (assign, readonly, nonatomic) NSUInteger page;
/** set enable page control, default is YES */
@property (assign, nonatomic) BOOL enablePage;
/** set enable page control gesture, default is NO */
@property (assign, nonatomic) BOOL pageControlGestureEnable;
/** set page control gesture */
@property (copy, nonatomic) void(^pageControlGesture)(NSUInteger page);
/** if need to custom page control */
@property (weak, nonatomic) UIPageControl *pageView;
/** set enable image gesture, default is NO */
@property (assign, nonatomic) BOOL imageGestureEnable;
/** set image gesture */
@property (copy, nonatomic) void(^imageGesture)(NSUInteger page);
@end
