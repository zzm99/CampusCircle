//
//  LoadingTableViewCell.h
//  G23
//
//  Created by student12 on 2020/11/28.
//

#import <UIKit/UIKit.h>

//
// 加载状态
//
typedef enum : NSUInteger {
    LoadingStatusDefault, // 默认状态
    LoadingStatusLoding,  // 正在加载
    LoadingStatusNoMore,  // 已加载全部
} LoadingStatus;

//
// 加载cell
//
@interface LoadingTableViewCell : UITableViewCell

@property(nonatomic, assign) LoadingStatus status;

@end
