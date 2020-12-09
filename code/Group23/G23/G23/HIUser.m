//
//  HIUser.m
//  G23
//
//  Created by yan on 2020/11/26.
//

#import "HIUser.h"

@implementation HIUser

- (NSString *)description {
    return [NSString stringWithFormat:@"UID:%@\nemail:%@\nname:%@\n", self.uid, self.email, self.name];
}

@end
