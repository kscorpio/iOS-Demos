//
//  ScrollPageView.h
//  MovieStartPage
//
//  Created by liu on 16/4/20.
//  Copyright © 2016年 com.sylg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame withNumOfPages:(int)pages;
- (void)setupTimer;
- (void)stopTimer;
@end
