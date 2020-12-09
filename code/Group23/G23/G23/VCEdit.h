//
//  VCEdit.h
//  G23
//
//  Created by student12 on 2020/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCEdit : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)setCID:(NSString*)s;

@end

NS_ASSUME_NONNULL_END
