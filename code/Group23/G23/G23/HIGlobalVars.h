//
//  HIGlobalVars.h
//  G23
//
//  Created by yan on 2020/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HIGlobalVars : NSObject

+ (void)setKey:(NSString *)aKey withObject:(id)aObject;
+ (id)getObjectWithKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
