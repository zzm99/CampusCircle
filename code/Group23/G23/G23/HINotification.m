//
//  HINotification.m
//  G23
//
//  Created by yan on 2020/11/26.
//

#import "HINotification.h"

@implementation HINotification

- (NSString *)description {
    return [NSString stringWithFormat:@"nid:%@\ndetail:%@\ncreateTime:%lu\nread:%@\nsourceUID:%@\ntargetCNID:%@\ntype:%@\nuserName:%@\n", self.nid, self.detail, (unsigned long)(self.createTime), (self.read? @"YES":@"NO"), self.sourceUID, self.targetCNID, self.type, self.userName];
}

@end
