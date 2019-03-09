//
//  UIViewController+JXViewController.h
//  MagicMoveDemo
//
//  Created by pconline on 2017/2/3.
//  Copyright © 2017年 pconline. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kJXMagicMoveAnimatorStartViewVCKey;
UIKIT_EXTERN NSString *const kJXMagicMoveAnimatorEndViewVCKey;
UIKIT_EXTERN NSString *const aaa;

@interface UIViewController (JXViewController)

-(void)jx_setMagicMoveStartViews:(NSArray<UIView*> *)views;
-(void)jx_setMagicMoveEndViews:(NSArray<UIView*> *)views;

@end
