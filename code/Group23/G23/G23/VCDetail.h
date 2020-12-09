//
//  VCDetail.h
//  G23
//
//  Created by yan on 2020/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCDetail : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

- (id)initWithContentID:(NSString *)aID;

@end

NS_ASSUME_NONNULL_END
