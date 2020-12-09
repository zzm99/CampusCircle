//
//  VCCommentDetail.h
//  G23
//
//  Created by student12 on 2020/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCCommentDetail : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (id)initWithContentID:(NSString *)aID andCommentIdx:(NSInteger)idx;


@end

NS_ASSUME_NONNULL_END
