//
//  HIReply.h
//  G23
//
//  Created by yan on 2020/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HIReply : NSObject

@property NSString * rid;
@property NSString * repliedCMID;
@property NSString * repliedUID;
@property NSString * ownUID;
@property NSInteger createTime;
@property NSString * detail;
@property NSInteger likeNum;

@property NSString * userName;

@property NSString * repliedName;

@end

NS_ASSUME_NONNULL_END
