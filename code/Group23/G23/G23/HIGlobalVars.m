//
//  HIGlobalVars.m
//  G23
//
//  Created by yan on 2020/11/27.
//

#import "HIGlobalVars.h"

static NSMutableDictionary * dict;

@implementation HIGlobalVars

+ (void)initialize {
    static BOOL init = NO;
    if (init) {
        return;
    }
    init = YES;
    dict = [NSMutableDictionary new];
}

+ (void)setKey:(NSString *)aKey withObject:(id)aObject {
    [dict setObject:aObject forKey:aKey];
}

+ (id)getObjectWithKey:(NSString *)aKey {
    return [dict objectForKey:aKey];
}

@end
