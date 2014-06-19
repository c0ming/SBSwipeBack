//
//  UIViewController+Tracking.m
//  SwipeBack
//
//  Created by c0ming on 14-6-17.
//  Copyright (c) 2014年 c0ming. All rights reserved.
//

#import "CALayer+Tracking.h"

#import <objc/runtime.h>

@implementation CALayer (Tracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(addAnimation:forKey:);
        SEL swizzledSelector = @selector(xxx_addAnimation:forKey:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)xxx_addAnimation:(CAAnimation *)anim forKey:(NSString *)key {
    [self xxx_addAnimation:anim forKey:key];

    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;

//        NSLog(@"keyPath >>> %@", basicAnim.keyPath);

        if ([basicAnim.keyPath isEqualToString:@"position"]) {
//            NSLog(@"%s", [basicAnim.fromValue objCType]);

//            CATransform3D transform = [basicAnim.fromValue CATransform3DValue];
//            NSLog(@"%@", NSStringFromCGAffineTransform(CATransform3DGetAffineTransform(transform)));

            NSLog(@"%@", NSStringFromCGPoint([basicAnim.fromValue CGPointValue]));
        }
    }

//    NSLog(@"CAAnimation >>> %@", [anim class]);
}

@end
