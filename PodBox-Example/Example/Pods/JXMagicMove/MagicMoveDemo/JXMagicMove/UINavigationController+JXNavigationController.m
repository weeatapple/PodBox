//
//  UINavigationController+JXNavigationController.m
//  MagicMoveDemo
//
//  Created by pconline on 2017/1/30.
//  Copyright © 2017年 pconline. All rights reserved.
//

#import "UINavigationController+JXNavigationController.h"
#import "MagicMoveTransition.h"
#import <objc/runtime.h>

@implementation UINavigationController (JXNavigationController)
+ (void)load{
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(jxPopViewControllerAnimated:)));
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated transition:(id<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>)transition{
    if (transition) {
        self.delegate = transition;
        objc_setAssociatedObject(self, &kJXMagicMoveFromVCKey, viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &kJXMagicMoveAnimatorTransitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self pushViewController:viewController animated:animated];
    self.delegate = self;
}



- (nullable UIViewController *)jxPopViewControllerAnimated:(BOOL)animated{
    id<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning> transition = objc_getAssociatedObject(self, &kJXMagicMoveAnimatorTransitionKey);
    UIViewController *magicToVC = objc_getAssociatedObject(self, &kJXMagicMoveFromVCKey);

    if(self.topViewController == magicToVC){
        self.delegate = transition;
//        objc_setAssociatedObject(self, &kJXMagicMoveAnimatorTransitionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UIViewController *popVC = [self jxPopViewControllerAnimated:animated];
    return popVC;
}

NSString *const kJXMagicMoveAnimatorTransitionKey = @"kJXMagicMoveAnimatorTransitionKey";
NSString *const kJXMagicMoveFromVCKey = @"kJXMagicMoveFromVCKey";


@end
