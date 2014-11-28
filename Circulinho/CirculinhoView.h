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

@interface CirculinhoView : UIView

@property (nonatomic, weak) id<CirculinhoDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView;
- (void)stopAnimatingWithScrollView:(UIScrollView *)scrollView;

- (void)teste;

@end
