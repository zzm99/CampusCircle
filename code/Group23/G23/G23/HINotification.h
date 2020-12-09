//
//  HINotification.h
//  G23
//
//  Created by yan on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HINotification : NSObject

@property NSString * nid;
@property NSString * detail;        // 通知生产者Comment的detail
@property NSUInteger createTime;
@property BOOL read;           // 应该是一个表示是否已读的量？？不敢确定
@property NSString * sourceUID;     // 应该是通知生产者的UID
@property NSString * targetCNID;    // 应该是通知所关联的Content的CNID
@property NSString * type;          // 不知道有啥用，先放在这

@property NSString * userName;      // 通知生产者的name

@end

NS_ASSUME_NONNULL_END
