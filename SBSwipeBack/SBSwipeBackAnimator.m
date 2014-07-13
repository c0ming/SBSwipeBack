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
static CGFloat const SBShadowOpacityEnd = 0.05;

static CGFloat const SBOpacityBegin = 0.2;
static CGFloat const SBOpacityEnd = 0.0;

static CGFloat const SBTransitionDuration = 4;

#pragma mark - UIView (EdgeShadow)

@implementation UIView (EdgeShadow)

- (void)setEdgeShadowWithOpacity:(CGFloat)opacity {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];

    self.layer.shadowOffset = CGSizeMake(-4.0, 0.0);
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowRadius = 4.0;
    self.layer.shadowOpacity = opacity;
    self.layer.masksToBounds = NO;
}

@end

#pragma mark -

@implementation SBSwipeBackAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext {
    return SBTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [fromViewController.view setEdgeShadowWithOpacity:SBShadowOpacityBegin];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];

    // add mask layer to toViewController's view
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = toViewController.view.bounds;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.opacity = SBOpacityBegin;
    [toViewController.view.layer addSublayer:maskLayer];

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
        [maskLayer removeFromSuperlayer];

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

    [CATransaction begin];
    [CATransaction setAnimationDuration:[self transitionDuration:transitionContext]];

    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacityAnimation.fromValue = [NSNumber numberWithFloat:SBShadowOpacityBegin];
    [fromViewController.view.layer addAnimation:shadowOpacityAnimation forKey:@"shadowOpacity"];
    fromViewController.view.layer.shadowOpacity = SBShadowOpacityEnd;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:SBOpacityBegin];
    opacityAnimation.duration = [self transitionDuration:transitionContext];
    [maskLayer addAnimation:opacityAnimation forKey:@"opacity"];
    maskLayer.opacity = SBOpacityEnd;

    [CATransaction commit];
}

@end
