//
//  HIService.h
//  G23
//
//  Created by yan on 2020/11/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HIUser.h"
#import "HINotification.h"
#import "HIContent.h"
#import "HIComment.h"
#import "HIReply.h"

NS_ASSUME_NONNULL_BEGIN

@interface HIService : NSObject

// MARK: User
+ (void)loginWithEmail:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(void (^)(NSString *))aCallback;
+ (void)registerWithName:(NSString *)aName Email:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(void (^)(NSString *))aCallback;
+ (void)getUserWithID:(NSString *)aUID Callback:(void (^)(NSString *, HIUser * _Nullable))aCallback;
+ (void)getMyselfWithCallback:(void (^)(NSString *, HIUser * _Nullable))aCallback;
+ (void)logoutWithCallback:(void (^)(NSString *))aCallback;
+ (void)modifyMyselfWithName:(NSString *)aName Callback:(void (^)(NSString *))aCallback;

// MARK: Notification
+ (void)getAllNotificationsWithCallback:(void (^)(NSString *, NSArray * _Nullable))aCallback;
+ (void)markNotificationWithID:(NSString *)aNID Read:(BOOL)aRead Callback:(void (^)(NSString *))aCallback;
+ (void)deleteNotificationWithID:(NSString *)aNID Callback:(void (^)(NSString *))aCallback;

// MARK: Content
+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(void (^)(NSString *))aCallback;
+ (void)getContentsWithUserID:(NSString *)aUID Callback:(void (^)(NSString *, NSArray * _Nullable))aCallback;   // 注意：获得的每个Content的userName为空
+ (void)getMyContentsWithCallback:(void (^)(NSString *, NSArray * _Nullable))aCallback;                         // 注意：获得的每个Content的userName为空
+ (void)getDetailedContentWithContentID:(NSString *)aCNID Callback:(void (^)(NSString *, HIContent * _Nullable))aCallback;
+ (void)getAllContentsWithPage:(NSUInteger)aPage EachPage:(NSUInteger)aEachPage Callback:(void (^)(NSString *, NSArray * _Nullable))aCallback;
+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(void (^)(NSString *))aCallback;
+ (void)deleteContentWithID:(NSString *)aCNID Callback:(void (^)(NSString *))aCallback;

+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(void (^)(NSString * _Nonnull))aCallback;
+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(void (^)(NSString * _Nonnull))aCallback;
+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Images:(NSArray *)aImages Callback:(void (^)(NSString * _Nonnull))aCallback;
+ (void)getAlbumsWithUserID:(NSString *)aUID Callback:(void (^)(NSString *, NSArray * _Nullable))aCallback; // 注意：获得的每个Content的userName为空
+ (void)getMyAlbumsWithCallback:(void (^)(NSString *, NSArray * _Nullable))aCallback;               // 注意：获得的每个Content的userName为空

// MARK: Comment
+ (void)addCommentWithContent:(HIContent *)aContent Detail:(NSString *)aDetail Callback:(void (^)(NSString *))aCallback;
+ (void)addReplyWithComment:(HIComment *)aComment Detail:(NSString *)aDetail Callback:(void (^)(NSString *))aCallback;
+ (void)addReplyWithReply:(HIReply *)aReply Detail:(NSString *)aDetail Callback:(void (^)(NSString *))aCallback;
+ (void)getCommentsWithContentID:(NSString *)aCNID Callback:(void (^)(NSString *, NSArray * _Nullable))aCallback;
+ (void)deleteCommentWithID:(NSString *)aCMID Callback:(void (^)(NSString *))aCallback;
+ (void)deleteReplyWithID:(NSString *)aRID Callback:(void (^)(NSString *))aCallback;

// MARK: Like
+ (void)likeContentWithID:(NSString *)aCNID Callback:(void (^)(NSString *))aCallback;
+ (void)likeCommentWithID:(NSString *)aCMID Callback:(void (^)(NSString *))aCallback;
+ (void)likeReplyWithID:(NSString *)aRID Callback:(void (^)(NSString *))aCallback;
+ (void)getAllLikesWithCallback:(void (^)(NSString *, NSArray * _Nullable))aCallback;
+ (void)dislikeContentWithID:(NSString *)aCNID Callback:(void (^)(NSString *))aCallback;
+ (void)dislikeCommentWithID:(NSString *)aCMID Callback:(void (^)(NSString *))aCallback;
+ (void)dislikeReplyWithID:(NSString *)aRID Callback:(void (^)(NSString *))aCallback;

// MARK: Others
+ (void)getImageWithURL:(NSString *)aURL Callback:(void (^)(UIImage * _Nullable))aCallback;

@end

NS_ASSUME_NONNULL_END
