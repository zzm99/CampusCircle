//
//  VCUserDetail.h
//  G23
//
//  Created by student12 on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCUserDetail : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

- (id)initWithUserID:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
