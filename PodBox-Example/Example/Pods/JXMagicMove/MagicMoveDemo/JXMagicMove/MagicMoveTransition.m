//
//  MagicMoveTransition.m
//  MagicMoveDemo
//
//  Created by pconline on 2017/1/25.
//  Copyright © 2017年 pconline. All rights reserved.
//

#import "MagicMoveTransition.h"
#import <objc/runtime.h>
#import "UIViewController+JXViewController.h"

@interface MagicMoveTransition()
@property(strong,nonatomic) UIViewController *toViewController;
@end

@implementation MagicMoveTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (_toViewController == nil) {
        _toViewController = toVC;
    }
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    NSArray<UIView *> *startViewGroup = objc_getAssociatedObject(fromVC, &kJXMagicMoveAnimatorStartViewVCKey);
    NSArray<UIView *> *endViewGroup = objc_getAssociatedObject(toVC,&kJXMagicMoveAnimatorEndViewVCKey);
    
    //views运动后的frame数组
    NSMutableArray *toRects = [NSMutableArray array];
    for (int i=0; i<endViewGroup.count; i++) {
        UIView *startView = [startViewGroup objectAtIndex:i];
        UIView *endView = [endViewGroup objectAtIndex:i];
        startView.hidden = YES;
        endView.hidden = YES;
        CGRect tempToRect = [containerView convertRect:endView.frame fromView:toVC.view];
        [toRects addObject:[NSValue valueWithCGRect:tempToRect]];
    }
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    [containerView addSubview:toVC.view];
    
    //动画用的截图数组
    NSMutableArray<UIView *> *snapshots = [NSMutableArray array];
    for (UIView *view in startViewGroup) {
        UIView *imageSnapshot = [view snapshotViewAfterScreenUpdates:NO];
        imageSnapshot.frame = [containerView convertRect:view.frame fromView:view.superview];
        [containerView addSubview:imageSnapshot];
        [snapshots addObject:imageSnapshot];
    }
    
    [UIView animateWithDuration:duration animations:^{
        toVC.view.alpha = 1.0;
        for (int i=0; i<snapshots.count; i++) {
            CGRect frame = [containerView convertRect:[endViewGroup objectAtIndex:i].frame fromView:[endViewGroup objectAtIndex:i].superview];
            [snapshots objectAtIndex:i].frame = frame;
        }
    }completion:^(BOOL finished) {

        for (int i=0; i<snapshots.count; i++) {
            [[snapshots objectAtIndex:i] removeFromSuperview];
            [[endViewGroup objectAtIndex:i] setHidden:NO];
            [[startViewGroup objectAtIndex:i] setHidden:NO];
        }
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        objc_setAssociatedObject(toVC, &kJXMagicMoveAnimatorStartViewVCKey, endViewGroup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(fromVC, &kJXMagicMoveAnimatorEndViewVCKey, startViewGroup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
   
    UIPercentDrivenInteractiveTransition *interactivePopTransition =objc_getAssociatedObject(_toViewController, &aaa);

    if (_toViewController != nil) {
    return interactivePopTransition;
    }
    return nil;
}


-(void)dealloc{
    NSLog(@"tra dealloc");
}



@end
