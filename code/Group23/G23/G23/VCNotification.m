//
//  VCNotification.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "VCNotification.h"
#import "Masonry.h"
#import "HIService.h"
#import "myButton.h"

@interface VCNotification ()
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) UIButton* btnManage;
@property (nonatomic) BOOL managing;
@property (nonatomic, strong) NSMutableArray* readed;
@end

@implementation VCNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通知中心";
    self.view.backgroundColor = [UIColor whiteColor];
    //_dataSource = [NSMutableArray arrayWithArray:@[]];
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    _managing = false;
    _readed = [NSMutableArray arrayWithCapacity:0];

    [self getAllNoti];
    [self btnManage];
    [self tableView];
    
}


- (void) getAllNoti {
    [HIService getAllNotificationsWithCallback:^(NSString * state, NSArray * notifications) {
        //NSLog(@"获取所有通知：%@", state);
        for (HINotification * notification in notifications) {
            //NSLog(@"%@", notification);
            [_dataSource addObject:notification];
            [_readed addObject:(notification.read ? @(TRUE) : @(FALSE))];
        }
        _dataSource = _dataSource.reverseObjectEnumerator.allObjects;
        _readed = _readed.reverseObjectEnumerator.allObjects;
        [self.tableView reloadData];
        
    }];
}

- (UIButton*) btnManage {
    if (_btnManage == nil) {
        _btnManage = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnManage setTitle:@"管理通知" forState:UIControlStateNormal];
        [_btnManage addTarget:self action:@selector(manage) forControlEvents:UIControlEventTouchUpInside];
        //[_btnManage setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:_btnManage];
        
        [_btnManage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(100);
            make.top.equalTo(self.view).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-20);
        }];
    }
    return _btnManage;
}

- (void) manage {
    if ([[_btnManage currentTitle] isEqualToString:@"管理通知"]) {
        [_btnManage setTitle:@"完成" forState:UIControlStateNormal];
        [_tableView setEditing:YES];
    }
    else {
        [_btnManage setTitle:@"管理通知" forState:UIControlStateNormal];
        [_tableView setEditing:NO];
    }
    _managing = !_managing;
    [[self tableView] reloadData];
}

- (UITableView*)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor clearColor];
        //[_tableView setEditing:YES animated:YES];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.frame.size.width);
            make.top.equalTo(self.btnManage).offset(40);
            make.left.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    return _tableView;
}



#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"%d\n", [self dataSource].count);
    //return [self dataSource].count;
    return 1;
}
 
//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    return [self dataSource].count;
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setFrame:CGRectMake(0, 0, 410, 100)];
        [cell.contentView setFrame:CGRectMake(0, 0, 410, 100)];
    }
//    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    //NSLog(@"contentView: %f\n cell: %f\n", cell.contentView.frame.size.height, cell.frame.size.height);
    int content_height = cell.contentView.frame.size.height;
    int content_width = cell.contentView.frame.size.width;
    for(UIView* sv in [cell.contentView subviews]) {
        [sv removeFromSuperview];
    }
    UIView *testView = [[UIView alloc]init];
    testView.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.3];
    testView.layer.cornerRadius = 20;
    testView.layer.masksToBounds = YES;
    testView.layer.borderColor = [UIColor grayColor].CGColor;
    testView.layer.borderWidth = 1;
    [cell.contentView addSubview:testView];

    
    
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(cell.frame.size.height-20);
        make.width.mas_equalTo(cell.frame.size.width-20);
        make.top.mas_equalTo(cell.mas_top).offset(10);
        make.left.mas_equalTo(cell.mas_left).offset(10);
    }];

    HINotification *noti = (HINotification*)[self.dataSource objectAtIndex: indexPath.row];
    
    
    //描述
    UILabel *description = [[UILabel alloc] init];
    NSString* des = [NSString stringWithFormat:@"%@%@了你", noti.userName, ([noti.type isEqualToString:@"like"] ? @"喜欢" : @"回复")];
    [description setText:des];
    description.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [testView addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(content_height * 0.3);
        make.width.mas_equalTo(content_width * 0.55);
        make.top.mas_equalTo(cell.contentView.mas_top).offset(content_height * 0.1);
        make.left.mas_equalTo(cell.contentView.mas_left).offset(content_width * 0.05);
    }];
//
//
    //时间
    UILabel *time = [[UILabel alloc] init];
    [time setText: [self getTimeFromTimestamp:noti.createTime]];
    time.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    [testView addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(content_height * 0.2);
        make.width.mas_equalTo(content_width * 0.3);
        make.top.mas_equalTo(cell.contentView.mas_top).offset(content_height * 0.1);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-content_width * 0.05);
    }];
    
    //内容
    UILabel *content = [[UILabel alloc] init];
    [content setText: noti.detail];
    content.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [testView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(content_height * 0.3);
        make.width.mas_equalTo(content_width * 0.8);
        make.top.mas_equalTo(description.mas_bottom).offset(content_height * 0.05);
        make.left.mas_equalTo(cell.contentView.mas_left).offset(content_width * 0.05);
    }];

    //未读图标
    if ([_readed objectAtIndex:indexPath.row] == @(FALSE)) {
        UIButton *unread = [[myButton alloc] initWithNid:noti.nid rowIndex: indexPath.row];
        unread.layer.cornerRadius = content_height * 0.15;
        unread.layer.masksToBounds = YES;
        //unread.layer.borderWidth = 1.0f;
        //unread.layer.borderColor = UIColor.grayColor.CGColor;
        [unread setImage:[UIImage imageNamed:@"weidu.png"] forState:UIControlStateNormal];
        
        
        [unread addTarget:self action:@selector(markNoti:)  forControlEvents:UIControlEventTouchUpInside];
        
        
        [testView addSubview:unread];
        [unread mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(content_height * 0.3);
            make.width.mas_equalTo(content_height * 0.3);
            make.top.mas_equalTo(time.mas_bottom).offset(content_height * 0.1);
            make.right.mas_equalTo(cell.contentView.mas_right).offset(-content_width * 0.1);
        }];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    
    return cell;
}
- (void) markNoti: (myButton*) btn {
    [HIService markNotificationWithID:btn.nid Read:YES Callback:^(NSString * state) {
        //NSLog(@"把通知标为已读：%@", state);
        [_readed setObject:@(TRUE) atIndexedSubscript:btn.rowIndex];
        [_tableView reloadData];
    }];
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (_managing ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone);
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"cell被点击\n");
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除服务器上的记录
        HINotification * notification = [self.dataSource objectAtIndex:indexPath.row];
        [HIService deleteNotificationWithID:notification.nid Callback:^(NSString * state) {
            //NSLog(@"删除第一条通知：%@", state);
        }];
        
        [self.dataSource removeObjectAtIndex: indexPath.row];
        [self.readed removeObjectAtIndex:indexPath.row];
        //删除单元格的某一行时，用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
    
}

# pragma mark - 时间戳转时间
- (NSString*) getTimeFromTimestamp: (NSUInteger) timestamp {
    //NSString *str=@"1368082020";//时间戳
//    NSString* str = [NSString stringWithFormat:@"%lu",(unsigned long)timestamp];
    NSTimeInterval time = timestamp / 1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


#pragma mark - forTest
///* 测试登录功能 */
//UIButton *btnGetAllNoti = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//[btnGetAllNoti setTitle:@"测试获取全部通知" forState:UIControlStateNormal];
//[btnGetAllNoti setBackgroundColor:[UIColor whiteColor]];
//[btnGetAllNoti addTarget:self action:@selector(testGetAllNoti) forControlEvents:UIControlEventTouchUpInside];
//[self.view addSubview:btnGetAllNoti];
//[btnGetAllNoti mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.height.mas_equalTo(50);
//    make.width.mas_equalTo(self.view.frame.size.width * 0.50);
//    make.top.equalTo(self.view).offset(15);
//    make.centerX.mas_equalTo(self.view.mas_centerX);
//}];
//
///* 测试标记通知 */
//UIButton *btnMarkNoti = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//[btnMarkNoti setTitle:@"测试标记通知已读" forState:UIControlStateNormal];
//[btnMarkNoti setBackgroundColor:[UIColor whiteColor]];
//[btnMarkNoti addTarget:self action:@selector(testMarkNoti) forControlEvents:UIControlEventTouchUpInside];
//[self.view addSubview:btnMarkNoti];
//[btnMarkNoti mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.height.mas_equalTo(50);
//    make.width.mas_equalTo(self.view.frame.size.width * 0.50);
//    make.top.equalTo(self.view).offset(75);
//    make.centerX.mas_equalTo(self.view.mas_centerX);
//}];
//
//
///* 测试删除通知 */
//UIButton *btnDeleteNoti = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//[btnDeleteNoti setTitle:@"测试删除通知" forState:UIControlStateNormal];
//[btnDeleteNoti setBackgroundColor:[UIColor whiteColor]];
//[btnDeleteNoti addTarget:self action:@selector(testDeleteNoti) forControlEvents:UIControlEventTouchUpInside];
//[self.view addSubview:btnDeleteNoti];
//[btnDeleteNoti mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.height.mas_equalTo(50);
//    make.width.mas_equalTo(self.view.frame.size.width * 0.50);
//    make.top.equalTo(self.view).offset(135);
//    make.centerX.mas_equalTo(self.view.mas_centerX);
//}];

//- (void)testGetAllNoti {
//    [HIService getAllNotificationsWithCallback:^(NSString * state, NSArray * notifications) {
//        NSLog(@"获取所有通知：%@", state);
//        for (HINotification * notification in notifications) {
//            NSLog(@"%@", notification);
//        }
//    }];
//}
//
//- (void)testMarkNoti {
//    [HIService getAllNotificationsWithCallback:^(NSString * state, NSArray * notifications) {
//        if ([notifications count] == 0) {
//            NSLog(@"测试失败：一条通知都没有");
//            return;
//        }
//        HINotification * notification = notifications[0];
//        [HIService markNotificationWithID:notification.nid Read:YES Callback:^(NSString * state) {
//            NSLog(@"把第一条通知标为已读：%@", state);
//        }];
//    }];
//}
//
//- (void)testDeleteNoti {
//    [HIService getAllNotificationsWithCallback:^(NSString * state, NSArray * notifications) {
//        if ([notifications count] == 0) {
//            NSLog(@"测试失败：一条通知都没有");
//            return;
//        }
//        HINotification * notification = notifications[0];
//        [HIService deleteNotificationWithID:notification.nid Callback:^(NSString * state) {
//            NSLog(@"删除第一条通知：%@", state);
//        }];
//    }];
//}

@end
