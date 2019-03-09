//
//  UIViewController+JXViewController.m
//  MagicMoveDemo
//
//  Created by pconline on 2017/2/3.
//  Copyright © 2017年 pconline. All rights reserved.
//

#import "UIViewController+JXViewController.h"
#import "UINavigationController+JXNavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (JXViewController)

-(void)jx_setMagicMoveStartViews:(NSArray<UIView*> *)views{
    if (views.count > 0) {
        objc_setAssociatedObject(self, &kJXMagicMoveAnimatorStartViewVCKey, views, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(void)jx_setMagicMoveEndViews:(NSArray<UIView*> *)views{
    if (views.count > 0) {
        objc_setAssociatedObject(self, &kJXMagicMoveAnimatorEndViewVCKey, views, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
        popRecognizer.edges = UIRectEdgeLeft;
        [self.view addGestureRecognizer:popRecognizer];
    }
}

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    // Calculate how far the user has dragged across the view
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        UIPercentDrivenInteractiveTransition *interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        objc_setAssociatedObject(self, &aaa, interactivePopTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        UIPercentDrivenInteractiveTransition *interactivePopTransition =objc_getAssociatedObject(self, &aaa);
        [interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        UIPercentDrivenInteractiveTransition *interactivePopTransition =objc_getAssociatedObject(self, &aaa);
        if (progress > 0.5) {
            [interactivePopTransition finishInteractiveTransition];
            objc_setAssociatedObject(self.navigationController, &kJXMagicMoveAnimatorTransitionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        else {
            [interactivePopTransition updateInteractiveTransition:0.f];
            [interactivePopTransition cancelInteractiveTransition];
        }
        objc_setAssociatedObject(self, &aaa, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
}

NSString *const kJXMagicMoveAnimatorStartViewVCKey = @"kJXMagicMoveAnimatorStartViewVCKey";
NSString *const kJXMagicMoveAnimatorEndViewVCKey = @"kJXMagicMoveAnimatorEndViewVCKey";
NSString *const aaa = @"aaa";

@end
