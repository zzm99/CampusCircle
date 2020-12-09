//
//  MYService.h
//  G23
//
//  Created by yan on 2020/11/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^JSONCallback)(NSDictionary * _Nullable responseObject);

NS_ASSUME_NONNULL_BEGIN

@interface MYService : NSObject

// MARK: User
+ (void)loginWithEmail:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(JSONCallback)aCallback;
+ (void)registerWithName:(NSString *)aName Email:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(JSONCallback)aCallback;
+ (void)getUserInfoWithID:(NSString *)aID Callback:(JSONCallback)aCallback;
+ (void)logoutWithCallback:(JSONCallback)aCallback;
+ (void)modifyMyselfWithName:(NSString *)aName Callback:(JSONCallback)aCallback;

// MARK: Notification
+ (void)getAllNotificationsWithCallback:(JSONCallback)aCallback;
+ (void)markNotificationWithID:(NSString *)aNID Read:(BOOL)aRead Callback:(JSONCallback)aCallback;
+ (void)deleteNotificationWithID:(NSString *)aNID Callback:(JSONCallback)aCallback;

// MARK: Content
+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(JSONCallback)aCallback;
+ (void)getContentsWithUserID:(NSString *)aID Callback:(JSONCallback)aCallback;
+ (void)getDetailedContentWithContentID:(NSString *)aID Callback:(JSONCallback)aCallback;
+ (void)getAllContentsWithPage:(NSUInteger)aPage EachPage:(NSUInteger)aEachPage Callback:(JSONCallback)aCallback;
+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(JSONCallback)aCallback;
+ (void)deleteContentWithID:(NSString *)aCNID Callback:(JSONCallback)aCallback;

+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(JSONCallback)aCallback;
+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(JSONCallback)aCallback;
+ (void)addAlbumWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Images:(NSArray *)aImages Callback:(JSONCallback)aCallback;
+ (void)getAlbumsWithUserID:(NSString *)aUID Callback:(JSONCallback)aCallback;

// MARK: Comment
+ (void)addCommentWithContentID:(NSString *)aCNID FatherID:(NSString *)aFID Detail:(NSString *)aDetail IsReply:(BOOL)aIsReply Callback:(JSONCallback)aCallback;
+ (void)getCommentsWithContentID:(NSString *)aCNID Callback:(JSONCallback)aCallback;
+ (void)deleteCommentWithID:(NSString *)aCMID Callback:(JSONCallback)aCallback;

// MARK: Like
+ (void)likeSomethingWithID:(NSString *)aID Params:(NSDictionary *)aParams Callback:(JSONCallback)aCallback;
+ (void)getAllLikesWithCallback:(JSONCallback)aCallback;
+ (void)dislikeSomethingWithID:(NSString *)aID Params:(NSDictionary *)aParams Callback:(JSONCallback)aCallback;

// MARK: Others
+ (void)getImageWithURL:(NSString *)aURL Callback:(void (^)(UIImage * _Nullable))aCallback;

@end

NS_ASSUME_NONNULL_END
