//
//  SBSwipeBack.m
//  SwipeBack
//
//  Created by c0ming on 14-6-13.
//  Copyright (c) 2014年 c0ming. All rights reserved.
//

#import "SBSwipeBack.h"

#import "SBSwipeBackAnimator.h"

@interface SBSwipeBack ()

@property (nonatomic, weak) IBOutlet UINavigationController *navigationController;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) SBSwipeBackAnimator *swipeBackAnimator;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation SBSwipeBack

- (void)awakeFromNib {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panRecognizer.maximumNumberOfTouches = 1;
    [self.navigationController.view addGestureRecognizer:panRecognizer];

    self.swipeBackAnimator = [SBSwipeBackAnimator new];
}

- (void)panHandler:(UIPanGestureRecognizer *)recognizer {
    UIView *view = self.navigationController.view;

    UIGestureRecognizerState state = recognizer.state;
    if (state == UIGestureRecognizerStateBegan) {
        CGFloat velocityX = [recognizer velocityInView:view].x;
        if ([self.navigationController.viewControllers count] > 1 && !self.isAnimating && velocityX > 0) {
            self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];

            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (state == UIGestureRecognizerStateChanged) {
        CGFloat translationX = [recognizer translationInView:view].x;
        if (translationX > 0) {
            CGFloat percentComplete = fabs([recognizer translationInView:view].x / CGRectGetWidth(view.bounds));
            [self.interactiveTransition updateInteractiveTransition:percentComplete];
        }
    } else if (state == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = [recognizer velocityInView:view].x;
        if (velocityX > 0) {
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
            self.isAnimating = NO;
        }

        self.interactiveTransition = nil;
    }
}

- (id <UIViewControllerInteractiveTransitioning> )navigationController:(UINavigationController *)navigationController
                           interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning> )animationController NS_AVAILABLE_IOS(7_0) {
    return self.interactiveTransition;
}

- (id <UIViewControllerAnimatedTransitioning> )navigationController:(UINavigationController *)navigationController
                                    animationControllerForOperation:(UINavigationControllerOperation)operation
                                                 fromViewController:(UIViewController *)fromVC
                                                   toViewController:(UIViewController *)toVC NS_AVAILABLE_IOS(7_0) {
    if (operation == UINavigationControllerOperationPop) {
        return self.swipeBackAnimator;
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        self.isAnimating = YES;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.isAnimating  = NO;
}

@end
