//
//  CirculinhoView.m
//  Circulinho
//
//  Created by Kekanto on 11/25/14.
//  Copyright (c) 2014 Kekanto. All rights reserved.
//

#import "CirculinhoView.h"

#import <QuartzCore/QuartzCore.h>

@interface CirculinhoView () <UIScrollViewDelegate>

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *circleBrotherLayer;
@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, strong) CABasicAnimation *growingAnimation;
@property (nonatomic, strong) CABasicAnimation *shrinkingAnimation;
@property (nonatomic, strong) CABasicAnimation *rotatingAnimation;
@property (nonatomic, strong) CAAnimationGroup *animationGroup;
@property (nonatomic, strong) CABasicAnimation *otherRotatingAnimation;


@end

@implementation CirculinhoView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat radius = CGRectGetWidth(self.bounds) * 0.9f / 2.0f;
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGFloat startAngle = -0.5f *M_PI;
        CGFloat endAngle = 1.5f *M_PI;
        BOOL clockwise = YES;
        
        self.circleLayer = [[CAShapeLayer alloc] init];
        self.circleLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                     radius:radius
                                                 startAngle:startAngle
                                                   endAngle:endAngle
                                                  clockwise:clockwise].CGPath;
        
        self.circleLayer.fillColor = [UIColor clearColor].CGColor;
        self.circleLayer.strokeColor = [UIColor blueColor].CGColor;
        self.circleLayer.strokeStart = 0.0f;
        self.circleLayer.strokeEnd = 0.0f;
        self.circleLayer.lineWidth = 2.5f;
        self.circleLayer.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        [self.layer addSublayer:self.circleLayer];
        
        self.circleBrotherLayer = [[CAShapeLayer alloc] init];
        self.circleBrotherLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                               radius:radius
                                                           startAngle:startAngle
                                                             endAngle:endAngle
                                                            clockwise:clockwise].CGPath;
        
        self.circleBrotherLayer.fillColor = [UIColor clearColor].CGColor;
        self.circleBrotherLayer.strokeColor = [UIColor blueColor].CGColor;
        self.circleBrotherLayer.strokeStart = 0.0f;
        self.circleBrotherLayer.strokeEnd = 0.0f;
        self.circleBrotherLayer.lineWidth = 2.5f;
        self.circleBrotherLayer.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        [self.layer addSublayer:self.circleBrotherLayer];
        
        self.growingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        self.growingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        self.growingAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        self.growingAnimation.duration = 10.0f;
        self.growingAnimation.repeatCount = HUGE_VALF;
        self.growingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        self.growingAnimation.delegate = self;
//        self.shrinkingAnimation.fillMode = kCAFillModeForwards;

        
        self.shrinkingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        self.shrinkingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        self.shrinkingAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        self.shrinkingAnimation.duration = 10.0f;
        self.shrinkingAnimation.beginTime = 0.0f;
        self.shrinkingAnimation.repeatCount = HUGE_VALF;
        self.shrinkingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        self.shrinkingAnimation.delegate = self;
//        self.shrinkingAnimation.fillMode = kCAFillModeForwards;
        
        self.rotatingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        self.rotatingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        self.rotatingAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        self.rotatingAnimation.duration = 3.0f;
        self.rotatingAnimation.repeatCount = HUGE_VALF;
        self.rotatingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        self.rotatingAnimation.delegate = self;
        
        self.otherRotatingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        self.otherRotatingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        self.otherRotatingAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        self.otherRotatingAnimation.duration = 0.8f;
        self.otherRotatingAnimation.repeatCount = HUGE_VALF;
        self.otherRotatingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        self.animationGroup = [[CAAnimationGroup alloc] init];
        self.animationGroup.delegate = self;
        self.animationGroup.duration = 10.0f;
        self.animationGroup.repeatCount = HUGE_VALF;
        self.animationGroup.animations = @[self.growingAnimation, self.shrinkingAnimation/*, self.rotatingAnimation*/];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint offset = scrollView.contentOffset;
    CGFloat delta = - offset.y - 64.0f;
    self.scale = delta / (self.frame.size.height);
    
    NSLog(@"### Delta %f", delta);
    NSLog(@"*** Scale %f", self.scale);
    
//    self.circleLayer.strokeEnd = MIN(self.scale, 0.8f);
    
    if (self.scale > 1.0f) {
        
//        self.transform = CGAffineTransformMakeTranslation(0.0f, delta / 2.0f);
        
        // if user looses
        // trigger animation and reload in delegate
        
        // or begin animating already
        // and waits for user to loose
        // to trigger reload in delegate
    }
    else {
//        self.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    if (self.scale > 1.0f) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(circulinhoDidTriggerReload:)]) {
            [self.delegate circulinhoDidTriggerReload:self];
            [self startAnimatingWithScrollView:scrollView];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - teste

- (void)animationDidStart:(CAAnimation *)anim {

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
    
    CAAnimationGroup *animation = (CAAnimationGroup *)anim;
    
//    self.circleLayer.strokeStart = 0.0f;
//    self.circleLayer.strokeEnd = 0.25f;
//    self.circleLayer.transform = CATransform3DRotate(self.circleLayer.transform, -M_PI/2.0f, 0, 0, 0);
    
    if (!finished) {
        return;
    }
    
//    if ([animation.keyPath isEqualToString:@"strokeStart"]) {
//        self.circleLayer.strokeStart = 0.0f;
//        self.circleLayer.strokeEnd = 1.0f;
//    }
//    else if ([animation.keyPath isEqualToString:@"strokeEnd"]) {
//        self.circleLayer.strokeStart = 0.0f;
//        self.circleLayer.strokeEnd = 0.0f;
//    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

- (void)teste {
    [self.circleLayer addAnimation:self.animationGroup forKey:@"teste"];
}

- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView {
    
    UIEdgeInsets insets = scrollView.contentInset;
    insets.top += self.frame.size.width + 10.0f;
    scrollView.contentInset = insets;
    
    NSLog(@"====> Começou a animar!");
//    [self.circleLayer addAnimation:self.shrinkingAnimation forKey:@"shrinkAnimation"];
//    [self.circleLayer addAnimation:self.rotatingAnimation forKey:@"transform.rotation"];
    
    self.circleLayer.strokeEnd = 0.25f;
    self.circleLayer.strokeStart = 0.25f;
    
    [self.circleLayer addAnimation:self.animationGroup forKey:@"spinning"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.circleBrotherLayer addAnimation:self.animationGroup forKey:@"spinningToo"];
    });

//    [self.circleBrotherLayer addAnimation:self.otherRotatingAnimation forKey:@"rotating"];

}

- (void)stopAnimatingWithScrollView:(UIScrollView *)scrollView {
    
    UIEdgeInsets insets = scrollView.contentInset;
    insets.top -= self.frame.size.width + 10.0f;
    scrollView.contentInset = insets;
    
    NSLog(@"====> Terminou de animar!");
    [self.circleLayer removeAllAnimations];
    [self.circleBrotherLayer removeAllAnimations];
    
}


@end
