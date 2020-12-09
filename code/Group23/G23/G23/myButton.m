//
//  myButton.m
//  G23
//
//  Created by xumy on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import "myButton.h"

@interface myButton ()

@end

@implementation myButton

- (id)initWithNid:(NSString *)nid
         rowIndex: (NSInteger*) row{
    self = [super init];
    if (self) {
        self.nid = nid;
        self.rowIndex = row;
    }
    return self;
}

@end
