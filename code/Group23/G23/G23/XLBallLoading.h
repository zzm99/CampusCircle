//
//  XLBallLoading.h
//  G23
//
//  Created by student12 on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLBallLoading : UIView

- (void)start;
- (void)stop;
+ (void)showInView:(UIView*)view;
+ (void)hideInView:(UIView*)view;

@end


NS_ASSUME_NONNULL_END
