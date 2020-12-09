//
//  HIContent.h
//  G23
//
//  Created by yan on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HIContent : NSObject

@property NSString * cnid;
@property NSString * title;
@property NSString * detail;
@property NSString * ownUID;
@property NSUInteger publishTime;
@property NSUInteger editTime;
@property NSUInteger likeNum;
@property NSUInteger commentNum;
@property BOOL isPublic;                // 好像没有不是public的，不过先放在这里吧
@property NSString * type;              // 不知道有什么用
@property NSString * subtype;           // 更不知道了
@property NSArray * tags;
@property NSArray * images;             // 注意：每个元素是图片的URL字符串，不是UIImage

@property NSString * userName;           // 内容发布者的name

@end

NS_ASSUME_NONNULL_END
