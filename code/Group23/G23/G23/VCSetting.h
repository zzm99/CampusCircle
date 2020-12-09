//
//  VCSetting.h
//  G23
//
//  Created by yan on 2020/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSetting : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (void)switchToNotloginAfterLogoutSuccess;
- (void)gotoNotification;
- (void)gotoMyUser;

@end

NS_ASSUME_NONNULL_END
