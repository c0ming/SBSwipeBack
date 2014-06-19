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

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations: ^{
        fromViewController.view.center = fromViewCenter;
        toViewController.view.center = toViewCenter;
    } completion: ^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:SBShadowOpacityBegin];
    animation.toValue = [NSNumber numberWithFloat:SBShadowOpacityEnd];
    animation.duration = [self transitionDuration:transitionContext];
    [fromViewController.view.layer addAnimation:animation forKey:@"shadowOpacity"];
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
