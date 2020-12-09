//
//  textFieldBackground.m
//  G23
//
//  Created by student12 on 2020/11/29.
//

#import "textFieldBackground.h"

@interface textFieldBackground ()

@end

@implementation textFieldBackground


- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0.2);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 5, 50);
    CGContextAddLineToPoint(context,self.frame.size.width-5, 50);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextStrokePath(context);
}

@end
