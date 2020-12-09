//
//  VCSetting.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "VCSetting.h"
#import "Masonry.h"
#import "VCNotification.h"
#import "VCUser.h"
#import "HIService.h"
#import "VCNotlogin.h"

@interface VCSetting ()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end




@implementation VCSetting

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataSource = [NSMutableArray arrayWithArray:@[]];
    [_dataSource addObject:@"用户"];
    [_dataSource addObject:@"通知"];
    [_dataSource addObject:@"退出当前帐号"];
    [self backView];
    [self tableView];
    

}


- (UIView*)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];

        gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1].CGColor];

        //位置x,y 自己根据需求进行设置 使其从不同位置进行渐变
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+200);

        [self.backView.layer addSublayer:gradientLayer];
        [self.view addSubview:_backView];
    }
    return _backView;
}


- (UITableView*)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.frame.size.width);
            make.top.equalTo(self.view).offset(0);
            make.left.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    return _tableView;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self dataSource].count;
}
 
//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    return 50;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[self dataSource] objectAtIndex:indexPath.section];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//跳转用户
        [self gotoMyUser];
    }
    else if (indexPath.section == 1) {//跳转通知
        [self gotoNotification];
    }
    else if (indexPath.section == 2) {//退出当前帐号
        [self logOut];
    }
}


- (void)gotoMyUser {
    VCUser *user = [VCUser new];
    //[user.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController pushViewController:user animated:YES];
}

- (void)gotoNotification {
    VCNotification *notification = [VCNotification new];
    //[notification.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController pushViewController:notification animated:YES];
}

- (void)logOut {
    [HIService logoutWithCallback:^(NSString * state) {
        // NSLog(@"登出：%@", state);
        if ([state isEqualToString:@"success"]) {
            [self switchToNotloginAfterLogoutSuccess];
        }
    }];
}

- (void)switchToNotloginAfterLogoutSuccess {
    [HIService getMyselfWithCallback:^(NSString * state, HIUser * me) {
        if (![state isEqualToString:@"not_login"]) {
            NSLog(@"好像还没有登出，状态码不是not_login，而是：%@", state);
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"notlogin" forKey:@"loginuid"];
        VCNotlogin * notlogin = [VCNotlogin new];
        [notlogin.view setBackgroundColor:[UIColor blackColor]];
        [self.navigationController setViewControllers:@[notlogin] animated:YES];
    }];
}


#pragma mark - forTest
//    /* 测试登出功能 */
//    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnLogout setTitle:@"测试登出" forState:UIControlStateNormal];
//    [btnLogout setBackgroundColor:[UIColor whiteColor]];
//    [btnLogout addTarget:self action:@selector(testLogout) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnLogout];
//    [btnLogout mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(self.view.frame.size.width * 0.25);
//        make.top.equalTo(self.view).offset(15);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];
//
//    /* 测试修改名字 */
//    UIButton *btnRename = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnRename setTitle:@"测试改名" forState:UIControlStateNormal];
//    [btnRename setBackgroundColor:[UIColor whiteColor]];
//    [btnRename addTarget:self action:@selector(testRename) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnRename];
//    [btnRename mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(self.view.frame.size.width * 0.25);
//        make.top.equalTo(self.view).offset(75);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];
//
//
//    /* 跳转到通知页 */
//    UIButton *btnGotoNotification = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnGotoNotification setTitle:@"跳转通知" forState:UIControlStateNormal];
//    [btnGotoNotification setBackgroundColor:[UIColor greenColor]];
//    [btnGotoNotification addTarget:self action:@selector(testGotoNoti) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnGotoNotification];
//    [btnGotoNotification mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(self.view.frame.size.width * 0.25);
//        make.top.equalTo(self.view).offset(265);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];
//
//    /* 跳转到用户页 */
//    UIButton *btnGotoUser = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnGotoUser setTitle:@"跳转用户" forState:UIControlStateNormal];
//    [btnGotoUser setBackgroundColor:[UIColor greenColor]];
//    [btnGotoUser addTarget:self action:@selector(testGotoUser) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnGotoUser];
//    [btnGotoUser mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(self.view.frame.size.width * 0.25);
//        make.top.equalTo(self.view).offset(325);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];

//- (void)testLogout {
////    [MYService logoutWithCallback:^(NSDictionary * r) {
////        NSLog(@"%@", r);
////    }];
//    [HIService logoutWithCallback:^(NSString * state) {
//        NSLog(@"登出：%@", state);
//        if ([state isEqualToString:@"success"]) {
//            [self switchToNotloginAfterLogoutSuccess];
//        }
//    }];
//}
//
//- (void)testRename {
//    [HIService modifyMyselfWithName:@"郑桌" Callback:^(NSString * state) {
//        NSLog(@"改名：%@", state);
//    }];
//}
//
//- (void)testGotoNoti {
//    [self gotoNotification];
//}
//
//- (void)testGotoUser {
//    [self gotoMyUser];
//}

@end
