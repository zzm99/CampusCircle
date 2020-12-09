//
//  HIReply.m
//  G23
//
//  Created by yan on 2020/11/27.
//

#import "HIReply.h"

@implementation HIReply

- (NSString *)description {
    return [NSString stringWithFormat:@"rid:%@\nrepliedCMID:%@\nrepliedUID:%@\nownUID:%@\ncreateTime:%lu\ndetail:%@\nlikeNum:%lu\nuserName:%@\nrepliedName:%@\n", self.rid, self.repliedCMID, self.repliedUID, self.ownUID, (unsigned long)[self createTime], self.detail, (unsigned long)[self likeNum], self.userName, self.repliedName];
}

@end
