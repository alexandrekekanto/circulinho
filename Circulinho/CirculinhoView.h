//
//  CirculinhoView.h
//  Circulinho
//
//  Created by Kekanto on 11/25/14.
//  Copyright (c) 2014 Kekanto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CirculinhoView;

@protocol CirculinhoDelegate <NSObject>

- (void)circulinhoDidTriggerReload:(CirculinhoView *)circulinho;

@end

@interface CirculinhoView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<CirculinhoDelegate> delegate;
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) NSNumber *lineWidth;
@property (nonatomic, strong) NSNumber *revolutionPeriod;
@property (nonatomic, assign) BOOL clockwise;


- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView;
- (void)stopAnimatingWithScrollView:(UIScrollView *)scrollView;

@end
