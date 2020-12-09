//
//  HIComment.m
//  G23
//
//  Created by yan on 2020/11/27.
//

#import "HIComment.h"

@implementation HIComment

- (NSString *)description {
    return [NSString stringWithFormat:@"cmid:%@\ncommentedCNID:%@\ncommentedUID:%@\nownUID:%@\ncreateTime:%lu\ndetail:%@\nlikeNum:%lu\nuserName:%@\nreplies:%lu条\n", self.cmid, self.commentedCNID, self.commentedUID, self.ownUID, (unsigned long)[self createTime], self.detail, (unsigned long)[self likeNum], self.userName, (unsigned long)[self.replies count]];
}

@end
