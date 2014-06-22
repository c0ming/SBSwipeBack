//
//  SBAnimator.m
//  SwipeBack
//
//  Created by c0ming on 14-6-13.
//  Copyright (c) 2014年 c0ming. All rights reserved.
//

#import "SBSwipeBackAnimator.h"

@import QuartzCore;

static CGFloat const SBShadowOpacityBegin = 0.75;
static CGFloat const SBShadowOpacityEnd = 0.1;

static CGFloat const SBOpacityBegin = 0.1;
static CGFloat const SBOpacityEnd = 0.0;

static CGFloat const SBTransitionDuration = 0.25;

@implementation SBSwipeBackAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext {
    return SBTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    [self addShadow:fromViewController.view];

    CGFloat width = CGRectGetWidth(fromViewController.view.frame);
    CGPoint fromViewCenter = fromViewController.view.center;
    CGPoint toViewCenter = toViewController.view.center;

    toViewCenter.x = width * 0.2;
    toViewController.view.center = toViewCenter;

    fromViewCenter.x = width + width / 2.0;
    toViewCenter.x = width / 2.0;

    // mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = toViewController.view.bounds;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.opacity = SBOpacityBegin;
    [toViewController.view.layer addSublayer:maskLayer];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations: ^{
        fromViewController.view.center = fromViewCenter;
        toViewController.view.center = toViewCenter;
    } completion: ^(BOOL finished) {
        [maskLayer removeFromSuperlayer];

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacityAnimation.fromValue = [NSNumber numberWithFloat:SBShadowOpacityBegin];
    shadowOpacityAnimation.toValue = [NSNumber numberWithFloat:SBShadowOpacityEnd];
    shadowOpacityAnimation.duration = [self transitionDuration:transitionContext];
    [fromViewController.view.layer addAnimation:shadowOpacityAnimation forKey:@"shadowOpacity"];

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:SBOpacityBegin];
    opacityAnimation.toValue = [NSNumber numberWithFloat:SBOpacityEnd];
    opacityAnimation.duration = [self transitionDuration:transitionContext];
    [maskLayer addAnimation:opacityAnimation forKey:@"opacity"];
}

- (void)addShadow:(UIView *)view {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];

    view.layer.shadowOffset = CGSizeMake(-4.0, 0.0);
    view.layer.shadowPath = path.CGPath;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowRadius = 4.0;
    view.layer.shadowOpacity = SBShadowOpacityBegin;
    view.layer.masksToBounds = NO;
}

@end
