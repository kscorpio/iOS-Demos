//
//  ScrollPageView.m
//  MovieStartPage
//
//  Created by liu on 16/4/20.
//  Copyright © 2016年 com.sylg. All rights reserved.
//

#import "ScrollPageView.h"
@interface ScrollPageView () <UIScrollViewDelegate>
@property (nonatomic) CGRect mFrame;
@property (nonatomic) CGFloat sWid;
@property (nonatomic) CGFloat sHei;
@property (nonatomic) int totalPages;

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic)BOOL ifScrolling;

@end
@implementation ScrollPageView

- (instancetype)initWithFrame:(CGRect)frame withNumOfPages:(int)pages
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.mFrame=frame;
        self.sWid= frame.size.width;
        self.sHei= frame.size.height;
        self.totalPages=pages;
        self.ifScrolling=NO;
        [self makeScrollLayout];
         [self makeContentLayout];
        
    }
    return self;
}
- (void)makeScrollLayout{
    self.frame=self.mFrame;
   self.backgroundColor = [UIColor clearColor];
    
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    // 是否滚动
    //    self.scrollView.scrollEnabled = NO;
    //    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 设置内容的边缘和Indicators边缘
    //    self.scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.scrollView=[[UIScrollView alloc]init];
    self.scrollView.frame=self.mFrame;
    // 设置内容大小
     self.scrollView.contentSize = CGSizeMake(_sWid*_totalPages, _sHei);
    // 是否反弹
     self.scrollView.bounces = NO;
    // 是否分页
     self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    // 设置indicator风格
    // self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    
    // 提示用户,Indicators flash
    // [self.scrollView flashScrollIndicators];
    // 是否同时运动,lock
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.delegate=self;
//
    [self addSubview:self.scrollView];
    
    self.pageControl=[[UIPageControl alloc]init];
    self.pageControl.center=CGPointMake(_sWid/2, _sHei-30);
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0/255.0
                                                                     green:137.0/255.0
                                                                      blue:167.0/255.0
                                                                     alpha: 0.7];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255.0/255.0
                                                              green:255.0/255.0
                                                               blue:251.0/255.0
                                                              alpha: 0.5];;
    [self.pageControl setNumberOfPages:_totalPages];
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
}
- (void)makeContentLayout{
    for (int i=0; i<_totalPages; i++) {
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0+i*_sWid, _sHei-100, _sWid, 50);
        label.text=[NSString stringWithFormat:@"此页是第 %d 页",i];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:20];
        label.textColor=[UIColor whiteColor];
        [self.scrollView addSubview:label];
    }

}


-(void)pageChanged:(UIPageControl *)pageControl{
    
    CGFloat x = (pageControl.currentPage) * _sWid;
    
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
    
}

-(void)setupTimer{
    
//    self.timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
      self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    self.ifScrolling=YES;
    
}
- (void)stopTimer{
    [self.timer invalidate];
    self.ifScrolling=NO;
}

-(void)timerFire{
    if (_ifScrolling) {
        
    int page  = (self.pageControl.currentPage +1) %_totalPages;
    
    self.pageControl.currentPage = page;
    
    [self pageChanged:self.pageControl];
       }
    
}
/*!
 *  @author LQX, 16-04-20
 *
 *  @brief
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"111111111111111111");
    double page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
    
    if (page== - 1)
    {
        self.pageControl.currentPage = _totalPages-1;// 序号0 最后1页
    }
    else if (page == _totalPages)
    {
        self.pageControl.currentPage = 0; // 最后+1,循环第1页
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

/*!
 *  @author LQX, 16-04-20
 *
 *  @brief 拖动时 停止timer 自动播放
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     NSLog(@"   拖动时 ----- ");
    if (_ifScrolling) {
         [self stopTimer];
    }
   
}
/*!
 *  @author LQX, 16-04-20
 *
 *  @brief 拖动结束时 重新开始timer
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"   拖动结束时");
    if (_ifScrolling) {
    [self setupTimer];
    }
    
}
@end
