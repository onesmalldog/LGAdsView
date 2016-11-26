//
//  LGAdsView.m
//  LGAppTool
//
//  Created by 东途 on 2016/11/26.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "LGAdsView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface LGAdsView() <UIScrollViewDelegate>
@property (copy, nonatomic) NSArray <UIImage *>*imageArray;
@property (weak, nonatomic) UIPageControl *pageControl;
@end
@implementation LGAdsView {
    NSUInteger  _imgct;
    CGFloat     _hei;
    NSUInteger  _pg;
}
- (NSUInteger)page {
    return _pg;
}
- (void)layoutSubviews {
    [self create_UI];
}
-(void)drawRect:(CGRect)rect {
}
+ (instancetype)lg_createAdsWithImages:(NSArray<UIImage *> *)imgArr height:(CGFloat)h {
    return [[self alloc] initWithImageArray:imgArr height:h];
}
- (instancetype)initWithImageArray:(NSArray <UIImage *>*)imgArray height:(CGFloat)hei {
    if (self = [super init]) {
        if (!self.imageArray) {
            self.imageArray = [NSArray arrayWithArray:imgArray];
        }
        if (!imgArray) return nil;
        if (imgArray.count == 0) return nil;
        _imgct  = imgArray.count;
        _hei    = hei;
        _pg     = 0;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = YES;
        self.enablePage = YES;
        self.imageGestureEnable = NO;
        self.pageControlGestureEnable = NO;
    }
    return self;
}

- (void)setEnablePage:(BOOL)enablePage {
    _enablePage = enablePage;
    if (_enablePage) {
        [self addPageView];
    }
    else {
        if (self.pageControl) {
            [self.pageControl removeFromSuperview];
        }
    }
}
- (void)create_UI {
    UIScrollView *sc = [[UIScrollView alloc] init];
    sc.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:sc];
    sc.delegate = self;
    sc.pagingEnabled = YES;
    sc.userInteractionEnabled = YES;
    sc.showsVerticalScrollIndicator = NO;
    sc.showsHorizontalScrollIndicator = NO;
    sc.contentSize = CGSizeMake(ScreenWidth*(_imgct+2), 0);
    [sc setContentOffset:CGPointMake(ScreenWidth, 0)];
    for (int i=0; i<_imgct+2; i++) {
        UIImage *img;
        NSInteger tag;
        if (i == 0) {
            img=self.imageArray.lastObject;
            tag = _imgct-1;
        }
        else if (i == _imgct+1) {
            img=self.imageArray.firstObject;
            tag = 0;
        }
        else {
            img = self.imageArray[i-1];
            tag = i-1;
        }
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
        [sc addSubview:imgV];
        imgV.userInteractionEnabled = YES;
        imgV.frame = CGRectMake(ScreenWidth*i, 0, ScreenWidth, _hei);
        imgV.tag = tag;
        if (self.imageGestureEnable) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouch:)];
            [imgV addGestureRecognizer:pan];
        }
    }
    if (self.enablePage) {
        [self addPageView];
    }
}
- (void)imageTouch:(id)ges {
    if (self.imageGesture) {
        self.imageGesture(_pg);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if ((x > ScreenWidth*0.5) && (x < ScreenWidth*_imgct+0.5*ScreenWidth)) {
        _pg = (x-ScreenWidth*0.5)/ScreenWidth;
    }
    else if ((x < ScreenWidth*0.5) && (x > 0)) {
        _pg = _imgct-1;
    }
    else if ((x >ScreenWidth*_imgct+0.5*ScreenWidth) && (x < ScreenWidth*(_imgct+1))) {
        _pg = 0;
    }
    [self.pageControl setCurrentPage:_pg];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    if (x == 0) {
        [scrollView setContentOffset:CGPointMake(ScreenWidth*(_imgct), 0)];
    }
    else if (x == (_imgct+1)*ScreenWidth) {
        [scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
    }
}

#pragma mark page control
- (void)addPageView {
    UIPageControl *pgctl = [self create_pageView];
    [self addSubview:pgctl];
    self.pageControl = pgctl;
    if (self.pageControlGestureEnable) {
        [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    }
}
- (void)setPageControlGestureEnable:(BOOL)pageControlGestureEnable {
    _pageControlGestureEnable = pageControlGestureEnable;
    if (self.pageControl) {
        if (self.pageControlGestureEnable) {
            [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        }
        else [self.pageControl removeTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    }
}
- (UIPageControl *)create_pageView {
    if (self.pageView) return self.pageView;
    else {
        UIPageControl *pgctl = [[UIPageControl alloc] init];
        pgctl.frame = CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30);
        pgctl.numberOfPages = _imgct;
        pgctl.currentPage = 0;
        return pgctl;
    }
}
- (void)pageTurn:(UIPageControl*)sender {
    if (self.pageControlGesture) {
        self.pageControlGesture(_pg);
    }
}
#pragma mark auto layout
- (void)addLayout:(UIView *)v {
    //创建左边约束
    NSLayoutConstraint *leftLc = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftLc];
    
    //创建右边约束
    NSLayoutConstraint *rightLc = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:rightLc];
    
    //创建底部约束
    NSLayoutConstraint *bottomLc = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:bottomLc];
    
    //创建高度约束
    NSLayoutConstraint *heightLc = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:_hei];
    [v addConstraint: heightLc];
}
@end
