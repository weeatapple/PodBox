//
//  UINavigationController+JXNavigationController.h
//  MagicMoveDemo
//
//  Created by pconline on 2017/1/30.
//  Copyright © 2017年 pconline. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kJXMagicMoveAnimatorTransitionKey;

@interface UINavigationController (JXNavigationController)<UINavigationControllerDelegate>


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated transition:(id<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>)transition;

@end
