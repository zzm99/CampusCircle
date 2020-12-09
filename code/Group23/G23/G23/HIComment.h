//
//  HIComment.h
//  G23
//
//  Created by yan on 2020/11/27.
//

#import <Foundation/Foundation.h>
#import "HIReply.h"

NS_ASSUME_NONNULL_BEGIN

@interface HIComment : NSObject

@property NSString * cmid;
@property NSString * commentedCNID;
@property NSString * commentedUID;
@property NSString * ownUID;
@property NSInteger createTime;
@property NSString * detail;
@property NSInteger likeNum;

@property NSString * userName;

@property NSArray * replies;

@end

NS_ASSUME_NONNULL_END
