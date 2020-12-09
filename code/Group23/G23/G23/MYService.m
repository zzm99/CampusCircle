//
//  MYService.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "MYService.h"
#import "AFNetworking.h"

static AFHTTPSessionManager *manager;
static AFHTTPSessionManager *imageManager;

@interface MYService ()

+ (void)postWithURL:(NSString *)aURL Params:(NSDictionary *)aParams Success:(JSONCallback)aSuccess;
+ (void)getWithURL:(NSString *)aURL Success:(JSONCallback)aSuccess;

@end


@implementation MYService

+ (void)initialize {
    static BOOL init = NO;
    if (init) {
        return;
    }
    init = YES;
    NSURL *baseUrl = [NSURL URLWithString:@"http://172.18.178.56/api/"];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    imageManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    imageManager.responseSerializer = [AFImageResponseSerializer serializer];
}

+ (void)postWithURL:(NSString *)aURL Params:(NSDictionary *)aParams Success:(JSONCallback)aSuccess {
    [manager
     POST:aURL
     parameters:aParams
     headers:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        aSuccess(responseObject);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (void)getWithURL:(NSString *)aURL Success:(JSONCallback)aSuccess {
    [manager
     GET:aURL
     parameters:nil
     headers:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        aSuccess(responseObject);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (void)patchWithURL:(NSString *)aURL Params:(NSDictionary *)aParams Success:(JSONCallback)aSuccess {
    [manager
     PATCH:aURL
     parameters:aParams
     headers:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        aSuccess(responseObject);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (void)deleteWithURL:(NSString *)aURL Success:(JSONCallback)aSuccess {
    [manager
     DELETE:aURL
     parameters:nil
     headers:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        aSuccess(responseObject);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

// MARK: User

+ (void)loginWithEmail:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(JSONCallback)aCallback {
    NSDictionary *params = @{
        @"name":aEmail,
        @"password":aPwd
    };
    [MYService postWithURL:@"user/login/pass" Params:params Success:aCallback];
}

+ (void)registerWithName:(NSString *)aName Email:(NSString *)aEmail Pwd:(NSString *)aPwd Callback:(JSONCallback)aCallback {
    NSDictionary *params = @{
        @"name":aName,
        @"email":aEmail,
        @"password":aPwd
    };
    [MYService postWithURL:@"user/register" Params:params Success:aCallback];
}

+ (void)getUserInfoWithID:(NSString *)aID Callback:(nonnull JSONCallback)aCallback {
    NSString * ID;
    if ([aID isEqualToString:@""]) {
        ID = @"self";
    }
    else {
        ID = aID;
    }
    NSString *url = [NSString stringWithFormat:@"user/info/%@", ID];
    [MYService getWithURL:url Success:aCallback];
}

+ (void)logoutWithCallback:(JSONCallback)aCallback {
    [MYService postWithURL:@"user/logout" Params:nil Success:aCallback];
}

+ (void)modifyMyselfWithName:(NSString *)aName Callback:(JSONCallback)aCallback {
    NSDictionary * params = @{
        @"name":aName
    };
    [MYService postWithURL:@"user/name" Params:params Success:aCallback];
}


// MARK: Notification

+ (void)getAllNotificationsWithCallback:(JSONCallback)aCallback {
    [MYService getWithURL:@"notification/all" Success:aCallback];
}

+ (void)markNotificationWithID:(NSString *)aNID Read:(BOOL)aRead Callback:(JSONCallback)aCallback {
    NSString * url = [NSString stringWithFormat:@"notification/read/%@", aNID];
    NSDictionary * params = @{
        @"isRead":[NSNumber numberWithBool:aRead]
    };
    [MYService patchWithURL:url Params:params Success:aCallback];
}

+ (void)deleteNotificationWithID:(NSString *)aNID Callback:(nonnull JSONCallback)aCallback {
    NSString * url = [NSString stringWithFormat:@"notification/%@", aNID];
    [MYService deleteWithURL:url Success:aCallback];
}


// MARK: Content

+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(JSONCallback)aCallback {
    [MYService addContentWithTitle:aTitle Detail:aDetail Tags:@[] Callback:aCallback];
}

+ (void)getContentsWithUserID:(NSString *)aID Callback:(JSONCallback)aCallback {
    NSString * ID;
    if ([aID isEqualToString:@""]) {
        ID = @"self";
    }
    else {
        ID = aID;
    }
    NSString *url = [NSString stringWithFormat:@"content/texts/%@", ID];
    [MYService getWithURL:url Success:aCallback];
}

+ (void)getDetailedContentWithContentID:(NSString *)aID Callback:(JSONCallback)aCallback {
    NSString *url = [NSString stringWithFormat:@"content/detail/%@", aID];
    [MYService getWithURL:url Success:aCallback];
}

+ (void)getAllContentsWithPage:(NSUInteger)aPage EachPage:(NSUInteger)aEachPage Callback:(JSONCallback)aCallback {
    NSString *url = [NSString stringWithFormat:@"content/public?page=%lu&eachPage=%lu", (long)aPage, (long)aEachPage];
    [MYService getWithURL:url Success:aCallback];
}

+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Callback:(JSONCallback)aCallback {
    [MYService updateContentWithID:aCNID Title:aTitle Detail:aDetail Tags:@[] Callback:aCallback];
}

+ (void)deleteContentWithID:(NSString *)aCNID Callback:(JSONCallback)aCallback {
    NSString * url = [NSString stringWithFormat:@"content/%@", aCNID];
    [MYService deleteWithURL:url Success:aCallback];
}

+ (void)addContentWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(JSONCallback)aCallback {
    NSDictionary *params = @{
        @"title":aTitle,
        @"detail":aDetail,
        @"tags":aTags,
        @"isPublic":@YES
    };
    [MYService postWithURL:@"content/text" Params:params Success:aCallback];
}

+ (void)updateContentWithID:(NSString *)aCNID Title:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Callback:(JSONCallback)aCallback {
    NSString * url = [NSString stringWithFormat:@"content/all/%@", aCNID];
    NSDictionary * params = @{
        @"title":aTitle,
        @"detail":aDetail,
        @"tags":aTags,
        @"isPublic":@YES
    };
    [MYService patchWithURL:url Params:params Success:aCallback];
}
+ (void)addAlbumWithTitle:(NSString *)aTitle Detail:(NSString *)aDetail Tags:(NSArray *)aTags Images:(NSArray *)aImages Callback:(JSONCallback)aCallback {
    NSDictionary * params = @{
        @"title":aTitle,
        @"detail":aDetail,
        @"isPublic":@YES
    };
    [manager
     POST:@"content/album"
     parameters:params
     headers:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        for (NSString * tag in aTags) {
            [formData appendPartWithFormData:[tag dataUsingEncoding:NSUTF8StringEncoding] name:@"tags"];
        }
        int i = 0;
        for (UIImage * image in aImages) {
            NSString * filename = [NSString stringWithFormat:@"file%d", i];
            NSString * thumbname = [NSString stringWithFormat:@"thumb%d", i];
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:filename fileName:filename mimeType:@"image/png"];
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:thumbname fileName:thumbname mimeType:@"image/png"];
            ++i;
        }
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        aCallback(responseObject);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (void)getAlbumsWithUserID:(NSString *)aUID Callback:(JSONCallback)aCallback {
    NSString * ID;
    if ([aUID isEqualToString:@""]) {
        ID = @"self";
    }
    else {
        ID = aUID;
    }
    NSString *url = [NSString stringWithFormat:@"content/album/%@", ID];
    [MYService getWithURL:url Success:aCallback];
}



// MARK: Comment

+ (void)addCommentWithContentID:(NSString *)aCNID FatherID:(NSString *)aFID Detail:(NSString *)aDetail IsReply:(BOOL)aIsReply Callback:(JSONCallback)aCallback {
    NSDictionary *params = @{
        @"contentId":aCNID,
        @"fatherId":aFID,
        @"content":aDetail,
        @"isReply":[NSNumber numberWithBool:aIsReply]
    };
    [MYService postWithURL:@"comment" Params:params Success:aCallback];
}

+ (void)getCommentsWithContentID:(NSString *)aCNID Callback:(JSONCallback)aCallback {
    NSString *url = [NSString stringWithFormat:@"comment/%@", aCNID];
    [MYService getWithURL:url Success:aCallback];
}

+ (void)deleteCommentWithID:(NSString *)aCMID Callback:(JSONCallback)aCallback {
    NSString * url = [NSString stringWithFormat:@"comment/%@", aCMID];
    [MYService deleteWithURL:url Success:aCallback];
}



// MARK: Like

+ (void)likeSomethingWithID:(NSString *)aID Params:(NSDictionary *)aParams Callback:(JSONCallback)aCallback {
    NSString * url = [NSString stringWithFormat:@"like/%@", aID];
    [MYService postWithURL:url Params:aParams Success:aCallback];
}

+ (void)getAllLikesWithCallback:(JSONCallback)aCallback {
    [MYService getWithURL:@"like" Success:aCallback];
}

+ (void)dislikeSomethingWithID:(NSString *)aID Params:(NSDictionary *)aParams Callback:(JSONCallback)aCallback {
    NSString * url = [NSString stringWithFormat:@"like/%@", aID];
    [MYService patchWithURL:url Params:aParams Success:aCallback];
}



// MARK: Others
+ (void)getImageWithURL:(NSString *)aURL Callback:(void (^)(UIImage * _Nullable))aCallback {
    [imageManager
     GET:aURL
     parameters:nil
     headers:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        aCallback(responseObject);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
