//
//  myButton.h
//  G23
//
//  Created by xumy on 2020/12/2.
//

#ifndef myButton_h
#define myButton_h
#import <UIKit/UIKit.h>
@interface myButton : UIButton
@property (nonatomic, strong) NSString* nid;
@property (nonatomic) NSInteger* rowIndex;
- (id)initWithNid: (NSString*) nid rowIndex: (NSInteger*) row;
@end

#endif /* myButton_h */
