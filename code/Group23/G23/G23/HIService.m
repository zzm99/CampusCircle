//
//  HIService.m
//  G23
//
//  Created by yan on 2020/11/26.
//

#import "HIService.h"
#import "MYService.h"

@implementation HIService

// MARK: User

+ (void)loginWithEmail:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService loginWithEmail:aEmail Pwd:aPwd Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)registerWithName:(NSString *)aName Email:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService registerWithName:aName Email:aEmail Pwd:aPwd Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)getUserWithID:(NSString *)aUID Callback:(void (^)(NSString * _Nonnull, HIUser * _Nullable))aCallback {
    [MYService getUserInfoWithID:aUID Callback:^(NSDictionary * r) {
        NSString *state = r[@"State"];
        HIUser *user = nil;
        if ([state isEqualToString:@"success"]) {
            user = [HIUser new];
            user.uid = r[@"ID"];
            user.email = r[@"Email"];
            user.name = r[@"Name"];
        }
        aCallback(state, user);
    }];
}

+ (void)getMyselfWithCallback:(void (^)(NSString * _Nonnull, HIUser * _Nullable))aCallback {
    [HIService getUserWithID:@"self" Callback:aCallback];
}

+ (void)logoutWithCallback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService logoutWithCallback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)modifyMyselfWithName:(NSString *)aName Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService modifyMyselfWithName:aName Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}





// MARK: Notification

+ (void)getAllNotificationsWithCallback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [MYService getAllNotificationsWithCallback:^(NSDictionary * r) {
        NSString *state = r[@"State"];
        NSMutableArray *notis = nil;
        if ([state isEqualToString:@"success"]) {
            notis = [NSMutableArray new];
            NSArray * rawNotis = r[@"Notification"];
            if (rawNotis && (id)rawNotis != [NSNull null]) {
                for (NSDictionary * rawNotification in rawNotis) {
                    HINotification *notification = [HINotification new];
                    NSDictionary * data = rawNotification[@"Data"];
                    notification.nid = data[@"ID"];
                    notification.detail = data[@"Content"];
                    notification.createTime = [data[@"CreateTime"] unsignedIntegerValue];
                    notification.read = [data[@"Read"] boolValue];
                    notification.sourceUID = data[@"SourceID"];
                    notification.targetCNID = data[@"TargetID"];
                    notification.type = data[@"Type"];
                    
                    NSDictionary * user = rawNotification[@"User"];
                    notification.userName = user[@"Name"];
                    
                    [notis addObject:notification];
                }
            }
        }
        aCallback(state, notis);
    }];
}

+ (void)markNotificationWithID:(NSString *)aNID Read:(BOOL)aRead Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService markNotificationWithID:aNID Read:aRead Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)deleteNotificationWithID:(NSString *)aNID Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService deleteNotificationWithID:aNID Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService updateContentWithID:aCNID Title:aTitle Detail:aDetail Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)deleteContentWithID:(NSString *)aCNID Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService deleteContentWithID:aCNID Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}





// MARK: Content

+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService addContentWithTitle:aTitle Detail:aDetail Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

// 这是一个辅助方法，方便从JSON格式的Content提取出有用信息存进HIContent，降低耦合度
+ (HIContent *)rawContentToHIContentWithData:(NSDictionary * _Nonnull)aData User:(NSDictionary * _Nullable)aUser {
    HIContent * content = [HIContent new];
    content.cnid = aData[@"ID"];
    content.title = aData[@"Name"];
    content.detail = aData[@"Detail"];
    content.ownUID = aData[@"OwnID"];
    content.publishTime = [aData[@"PublishDate"] unsignedIntegerValue];
    content.editTime = [aData[@"EditDate"] unsignedIntegerValue];
    content.likeNum = [aData[@"LikeNum"] unsignedIntegerValue];
    content.commentNum = [aData[@"CommentNum"] unsignedIntegerValue];
    content.isPublic = [aData[@"Public"] boolValue];
    content.type = aData[@"Type"];
    content.subtype = aData[@"SubType"];
    content.tags = aData[@"Tag"];
    
    /* 提取图片URL */
    NSArray * rawImages = aData[@"Album"][@"Images"];
    NSMutableArray * images = [NSMutableArray new];
    if (rawImages && (id)rawImages != [NSNull null]) {
        for (NSDictionary * rawImage in rawImages) {
            NSString * url = [NSString stringWithFormat:@"thumb/%@", rawImage[@"Thumb"]];
            [images addObject:url];
        }
    }
    content.images = images;
    
    if (aUser && (id)aUser != [NSNull null]) {
        content.userName = aUser[@"Name"];
    }
    else {
        content.userName = @"";
    }
    return content;
}

+ (void)getContentsWithUserID:(NSString *)aUID Callback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [MYService getContentsWithUserID:aUID Callback:^(NSDictionary * r) {
        NSString * state = r[@"State"];
        NSMutableArray * contents;
        if ([state isEqualToString:@"success"]) {
            contents = [NSMutableArray new];
            NSArray * data = r[@"Data"];
            if (data && (id)data != [NSNull null]) {
                for (NSDictionary * rawContent in data) {
                    HIContent * content = [HIService rawContentToHIContentWithData:rawContent User:nil];
                    [contents addObject:content];
                }
            }
        }
        aCallback(state, contents);
    }];
}

+ (void)getMyContentsWithCallback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [HIService getContentsWithUserID:@"self" Callback:aCallback];
}

+ (void)getDetailedContentWithContentID:(NSString *)aCNID Callback:(void (^)(NSString * _Nonnull, HIContent * _Nullable))aCallback {
    [MYService getDetailedContentWithContentID:aCNID Callback:^(NSDictionary * r) {
        NSString * state = r[@"State"];
        HIContent * content = nil;
        if ([state isEqualToString:@"success"]) {
            content = [HIService rawContentToHIContentWithData:r[@"Data"] User:r[@"User"]];
        }
        aCallback(state, content);
    }];
}

+ (void)getAllContentsWithPage:(NSUInteger)aPage EachPage:(NSUInteger)aEachPage Callback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [MYService getAllContentsWithPage:aPage EachPage:aEachPage Callback:^(NSDictionary * r) {
        NSString * state = r[@"State"];
        NSMutableArray * contents;
        if ([state isEqualToString:@"success"]) {
            contents = [NSMutableArray new];
            NSArray * data = r[@"Data"];
            if (data && (id)data != [NSNull null]) {
                for (NSDictionary * rawContent in data) {
                    HIContent * content = [HIService rawContentToHIContentWithData:rawContent[@"Data"] User:rawContent[@"User"]];
                    [contents addObject:content];
                }
            }
        }
        aCallback(state, contents);
    }];
}


+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService addContentWithTitle:aTitle Detail:aDetail Tags:aTags Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService updateContentWithID:aCNID Title:aTitle Detail:aDetail Tags:aTags Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}
+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Images:(NSArray *)aImages Callback:(void (^)(NSString * _Nonnull))aCallback {
    if (!aImages || (id)aImages == [NSNull null] || [aImages count] == 0) {
        [HIService addContentWithTitle:aTitle Detail:aDetail Tags:aTags Callback:aCallback];
    }
    else {
        [MYService addAlbumWithTitle:aTitle Detail:aDetail Tags:aTags Images:aImages Callback:^(NSDictionary * r) {
            aCallback(r[@"State"]);
        }];
    }
}

+ (void)getAlbumsWithUserID:(NSString *)aUID Callback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [MYService getAlbumsWithUserID:aUID Callback:^(NSDictionary * r) {
        NSString * state = r[@"State"];
        NSMutableArray * contents;
        if ([state isEqualToString:@"success"]) {
            contents = [NSMutableArray new];
            NSArray * data = r[@"Data"];
            if (data && (id)data != [NSNull null]) {
                for (NSDictionary * rawContent in data) {
                    HIContent * content = [HIService rawContentToHIContentWithData:rawContent User:nil];
                    [contents addObject:content];
                }
            }
        }
        aCallback(state, contents);
    }];
}

+ (void)getMyAlbumsWithCallback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [HIService getAlbumsWithUserID:@"self" Callback:aCallback];
}



// MARK: Comment

+ (void)addCommentWithContent:(HIContent *)aContent Detail:(NSString *)aDetail Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService addCommentWithContentID:aContent.cnid FatherID:aContent.ownUID Detail:aDetail IsReply:NO Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)addReplyWithComment:(HIComment *)aComment Detail:(NSString *)aDetail Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService addCommentWithContentID:aComment.cmid FatherID:aComment.ownUID Detail:aDetail IsReply:YES Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)addReplyWithReply:(HIReply *)aReply Detail:(NSString *)aDetail Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService addCommentWithContentID:aReply.repliedCMID FatherID:aReply.repliedUID Detail:aDetail IsReply:YES Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)getCommentsWithContentID:(NSString *)aCNID Callback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [MYService getCommentsWithContentID:aCNID Callback:^(NSDictionary * r) {
        NSString * state = r[@"State"];
        NSMutableArray * comments = nil;
        if ([state isEqualToString:@"success"]) {
            comments = [NSMutableArray new];
            NSArray * rawCommentDatas = r[@"Data"];
            if (rawCommentDatas && (id)rawCommentDatas != [NSNull null]) {
                for (NSDictionary * rawCommentData in rawCommentDatas) {
                    HIComment * comment = [HIComment new];
                    NSDictionary * rawCommentComment = rawCommentData[@"Comment"];
                    comment.cmid = rawCommentComment[@"ID"];
                    comment.commentedCNID = rawCommentComment[@"ContentID"];
                    comment.commentedUID = rawCommentComment[@"FatherID"];
                    comment.ownUID = rawCommentComment[@"UserID"];
                    comment.createTime = [rawCommentComment[@"Date"] unsignedIntegerValue];
                    comment.detail = rawCommentComment[@"Content"];
                    comment.likeNum = [rawCommentComment[@"LikeNum"] unsignedIntegerValue];
                    
                    NSDictionary * rawCommentUser = rawCommentData[@"User"];
                    comment.userName = rawCommentUser[@"Name"];
                    
                    NSArray * rawCommentReplies = rawCommentData[@"Replies"];
                    NSMutableArray * replies = [NSMutableArray new];
                    if (rawCommentReplies && (id)rawCommentReplies != [NSNull null]) {
                        for (NSDictionary * rawReplyData in rawCommentReplies) {
                            HIReply * reply = [HIReply new];
                            NSDictionary * rawReplyReply = rawReplyData[@"Reply"];
                            reply.rid = rawReplyReply[@"ID"];
                            reply.repliedCMID = rawReplyReply[@"ContentID"];
                            reply.repliedUID = rawReplyReply[@"FatherID"];
                            reply.ownUID = rawReplyReply[@"UserID"];
                            reply.createTime = [rawReplyReply[@"Date"] unsignedIntegerValue];
                            reply.detail = rawReplyReply[@"Content"];
                            reply.likeNum = [rawReplyReply[@"LikeNum"] unsignedIntegerValue];
                            
                            NSDictionary * rawReplyUser = rawReplyData[@"User"];
                            reply.userName = rawReplyUser[@"Name"];
                            
                            NSDictionary * rawReplyFather = rawReplyData[@"Father"];
                            reply.repliedName = rawReplyFather[@"Name"];

                            [replies addObject:reply];
                        }
                    }
                    comment.replies = replies;
                    
                    [comments addObject:comment];
                }
            }
        }
        aCallback(state, comments);
    }];
}

+ (void)deleteCommentWithID:(NSString *)aCMID Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService deleteCommentWithID:aCMID Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)deleteReplyWithID:(NSString *)aRID Callback:(void (^)(NSString * _Nonnull))aCallback {
    [MYService deleteCommentWithID:aRID Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}



// MARK: Like

+ (void)likeContentWithID:(NSString *)aCNID Callback:(void (^)(NSString * _Nonnull))aCallback {
    NSDictionary * params = @{
        @"isContent":@YES
    };
    [MYService likeSomethingWithID:aCNID Params:params Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)likeCommentWithID:(NSString *)aCMID Callback:(void (^)(NSString * _Nonnull))aCallback {
    NSDictionary * params = @{
        @"isComment":@YES
    };
    [MYService likeSomethingWithID:aCMID Params:params Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)likeReplyWithID:(NSString *)aRID Callback:(void (^)(NSString * _Nonnull))aCallback {
    NSDictionary * params = @{
        @"isReply":@YES
    };
    [MYService likeSomethingWithID:aRID Params:params Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)getAllLikesWithCallback:(void (^)(NSString * _Nonnull, NSArray * _Nullable))aCallback {
    [MYService getAllLikesWithCallback:^(NSDictionary * r) {
        NSString * state = r[@"State"];
        NSArray * likes = nil;
        if ([state isEqualToString:@"success"]) {
            likes = r[@"Data"];
        }
        aCallback(state, likes);
    }];
}

+ (void)dislikeContentWithID:(NSString *)aCNID Callback:(void (^)(NSString * _Nonnull))aCallback {
    NSDictionary * params = @{
        @"isContent":@YES
    };
    [MYService dislikeSomethingWithID:aCNID Params:params Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)dislikeCommentWithID:(NSString *)aCMID Callback:(void (^)(NSString * _Nonnull))aCallback {
    NSDictionary * params = @{
        @"isComment":@YES
    };
    [MYService dislikeSomethingWithID:aCMID Params:params Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}

+ (void)dislikeReplyWithID:(NSString *)aRID Callback:(void (^)(NSString * _Nonnull))aCallback {
    NSDictionary * params = @{
        @"isReply":@YES
    };
    [MYService dislikeSomethingWithID:aRID Params:params Callback:^(NSDictionary * r) {
        aCallback(r[@"State"]);
    }];
}



// MARK: Others
+ (void)getImageWithURL:(NSString *)aURL Callback:(void (^)(UIImage * _Nullable))aCallback {
    [MYService getImageWithURL:aURL Callback:aCallback];
}

@end
