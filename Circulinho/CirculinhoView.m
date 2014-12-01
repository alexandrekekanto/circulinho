//
//  CirculinhoView.m
//  Circulinho
//
//  Created by Kekanto on 11/25/14.
//  Copyright (c) 2014 Kekanto. All rights reserved.
//

#import "CirculinhoView.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat const kAnimationPeriod = 1.0f;
static CGFloat const kAnimationDelay = 0.92f;
static CGFloat const kCircleLineWidth = 2.50f;
static CGFloat const kCircleStartAngle = -0.5f * M_PI;
static CGFloat const kCircleEndAngle = 1.5 * M_PI;
static CGFloat const kCircleDiameter = 40.0f;
static CGFloat const kTopPadding = 10.0f;
static CGFloat const kScrollFactor = 0.45f;


@interface CirculinhoView ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *circleBrotherLayer;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, strong) CABasicAnimation *growingAnimation;
@property (nonatomic, strong) CABasicAnimation *shrinkingAnimation;
@property (nonatomic, strong) CABasicAnimation *rotatingAnimation;
@property (nonatomic, strong) CAAnimationGroup *animationGroup;


@end

@implementation CirculinhoView

- (instancetype)init {
    self = [self initWithFrame:CGRectMake(0.0f, 0.0f, kCircleDiameter, kCircleDiameter)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor blueColor];
        self.clockwise = YES;
        self.lineWidth = @(kCircleLineWidth);
        self.revolutionPeriod = @(kAnimationPeriod);
        self.isAnimating = NO;
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
    
    if (!self.isAnimating) {
        
        CGPoint offset = scrollView.contentOffset;
        CGFloat delta = - offset.y - self.frame.origin.y; // 64?
        self.scale = delta / (self.frame.size.height) * kScrollFactor;
        
        self.circleLayer.strokeEnd = self.scale;//MIN(self.scale, 1.0f);
        
        NSLog(@"alex stroke end %f", self.scale);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
    
    if (self.scale > 1.0f && !self.isAnimating) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(circulinhoDidTriggerReload:)]) {
            
            [self.delegate circulinhoDidTriggerReload:self];
            
            self.isAnimating = YES;
            NSLog(@"animando");
            
            UIEdgeInsets insets = scrollView.contentInset;
            insets.top += self.frame.size.width + kTopPadding;
            scrollView.contentInset = insets;
            
            
            self.circleLayer.strokeStart = 0.0f;
            self.circleLayer.strokeEnd = 1.0f;
            self.shrinkingAnimation.repeatCount = 1.0f;
            
            [self.circleLayer addAnimation:self.shrinkingAnimation forKey:@"shrink"];
            
            self.shrinkingAnimation.repeatCount = HUGE_VALF;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAAnimation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
    
    if ([anim respondsToSelector:@selector(keyPath)]) {
        
        CABasicAnimation *animation = (CABasicAnimation *)anim;
        
        if ([animation.keyPath isEqualToString:@"strokeStart"]) {
            
            self.circleLayer.strokeEnd = 0.0f;
            self.circleLayer.strokeStart = 0.0f;
            
            [self startProgress];
            return;
        }
    }
    
    self.circleLayer.strokeStart = 0.0f;
    self.circleLayer.strokeEnd = 0.0f;
    self.circleBrotherLayer.strokeStart = 0.0f;
    self.circleBrotherLayer.strokeEnd = 0.0f;
    self.isAnimating = NO;
    NSLog(@"fim da animacao");
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties override

- (CAShapeLayer *)circleLayer {
    
    if (!_circleLayer) {
        
        CGFloat radius = CGRectGetWidth(self.bounds) * 0.95f / 2.0f;
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:radius
                                                       startAngle:kCircleStartAngle
                                                         endAngle:kCircleEndAngle
                                                        clockwise:self.clockwise].CGPath;
        
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = self.circleColor.CGColor;
        _circleLayer.strokeStart = 0.0f;
        _circleLayer.strokeEnd = 0.0f;
        _circleLayer.lineWidth = self.lineWidth.floatValue;
        _circleLayer.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        [self.layer addSublayer:_circleLayer];
    }
    
    return _circleLayer;
}

- (CAShapeLayer *)circleBrotherLayer {
    
    if (!_circleBrotherLayer) {
        
        CGFloat radius = CGRectGetWidth(self.bounds) * 0.95f / 2.0f;
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        
        _circleBrotherLayer = [[CAShapeLayer alloc] init];
        _circleBrotherLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                                      radius:radius
                                                                  startAngle:kCircleStartAngle
                                                                    endAngle:kCircleEndAngle
                                                                   clockwise:self.clockwise].CGPath;
        
        _circleBrotherLayer.fillColor = [UIColor clearColor].CGColor;
        _circleBrotherLayer.strokeColor = [UIColor blueColor].CGColor;
        _circleBrotherLayer.strokeStart = 0.0f;
        _circleBrotherLayer.strokeEnd = 0.0f;
        _circleBrotherLayer.lineWidth = kCircleLineWidth;
        _circleBrotherLayer.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        [self.layer addSublayer:_circleBrotherLayer];
    }
    
    return _circleBrotherLayer;
}

- (CABasicAnimation *)growingAnimation {
    
    if (!_growingAnimation) {
        _growingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _growingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        _growingAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        _growingAnimation.duration = self.revolutionPeriod.floatValue;
        _growingAnimation.repeatCount = HUGE_VALF;
        _growingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _growingAnimation.delegate = self;
    }
    return _growingAnimation;
}

- (CABasicAnimation *)shrinkingAnimation {
    if (!_shrinkingAnimation) {
        _shrinkingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        _shrinkingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        _shrinkingAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        _shrinkingAnimation.duration = self.revolutionPeriod.floatValue;
        _shrinkingAnimation.repeatCount = HUGE_VALF;
        _shrinkingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        _shrinkingAnimation.delegate = self;
    }
    return _shrinkingAnimation;
    
}

- (CABasicAnimation *)rotatingAnimation {
    
    if (!_rotatingAnimation) {
        _rotatingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        _rotatingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        _rotatingAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        _rotatingAnimation.duration = 3.0f;
        _rotatingAnimation.repeatCount = HUGE_VALF;
        _rotatingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    return _rotatingAnimation;
}

- (CAAnimationGroup *)animationGroup {
    
    if (!_animationGroup) {
        
        _animationGroup = [[CAAnimationGroup alloc] init];
        _animationGroup.delegate = self;
        _animationGroup.duration = kAnimationPeriod;
        _animationGroup.repeatCount = HUGE_VALF;
        _animationGroup.animations = @[self.growingAnimation, self.shrinkingAnimation/*, self.rotatingAnimation*/];
    }
    return _animationGroup;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView {
    
    if (self.isAnimating) return;
    
    UIEdgeInsets insets = scrollView.contentInset;
    
    [UIView animateWithDuration:0.4f animations:^{
        scrollView.contentOffset = CGPointMake(0.0f, -(insets.top + self.frame.size.width + kTopPadding));
    } completion:^(BOOL finished) {
        UIEdgeInsets insets = scrollView.contentInset;
        insets.top += self.frame.size.width + kTopPadding;
        scrollView.contentInset = insets;
    }];
    
    self.isAnimating = YES;
    [self startProgress];

}

- (void)stopAnimatingWithScrollView:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:0.4f animations:^{
        scrollView.contentOffset = CGPointMake(0.0f, -64.0f); // 64 hardcoded
    } completion:^(BOOL finished) {
        UIEdgeInsets insets = scrollView.contentInset;
        insets.top -= self.frame.size.width + kTopPadding;
        scrollView.contentInset = insets;
    }];
    
    NSLog(@"====> Terminou de animar!");
    [self.circleLayer removeAllAnimations];
    [self.circleBrotherLayer removeAllAnimations];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

- (void)startProgress {
    
    NSLog(@"====> Começou a animar!");
    
    [self.circleLayer addAnimation:self.animationGroup forKey:@"spinning"];
    
    CGFloat delay = kAnimationDelay * self.revolutionPeriod.floatValue;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.circleBrotherLayer addAnimation:self.animationGroup forKey:@"spinningToo"];
    });
}


@end
