//
//  HIContent.m
//  G23
//
//  Created by yan on 2020/11/26.
//

#import "HIContent.h"

@implementation HIContent

- (NSString *)description {
    return [NSString stringWithFormat:@"cnid:%@\ntitle:%@\ndetail:%@\nownUID:%@\npublishTime:%lu\neditTime:%lu\nlikeNum:%lu\ncommentNum:%lu\nisPublic:%@\ntype:%@\nsubtype:%@\ntags:%@\nimages:%lu张\nuserName:%@\n", self.cnid, self.title, self.detail, self.ownUID, (unsigned long)(self.publishTime), (unsigned long)(self.editTime), (unsigned long)(self.likeNum), (unsigned long)(self.commentNum), (self.isPublic? @"YES":@"NO"), self.type, self.subtype, self.tags, (unsigned long)[self.images count], self.userName];
}

@end
