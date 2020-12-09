//
//  VCUser.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "VCUser.h"
#import "Masonry.h"
#import "HIService.h"

@interface VCUser ()

@property (nonatomic, strong) UIImageView *dengluhead;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel* idLabel;
@property (nonatomic, strong) UILabel* emailLabel;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIButton* btnRename;

@end




@implementation VCUser

- (id)initWithUserID:(NSString *)aID {
    self = [super init];
    if (self) {
        if ([aID isEqualToString:@"self"] || [aID isEqualToString:@""]) {
            self.navigationItem.title = @"我的信息";
        }
        else {
            self.navigationItem.title = @"用户信息";
        }
        // TODO: 根据传入的aID来初始化一些东西
    }
    return self;
}

- (id)init {
    return [self initWithUserID:@"self"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self backView];
    [self dengluhead];
    [self idLabel];
    [self nameLabel];
    [self btnRename];
    [self emailLabel];
    [self getInfo];
    
}

- (UIImageView*)dengluhead {
    if(_dengluhead == nil) {
        _dengluhead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
        int screenWidth = self.view.frame.size.width;
        int headWidth = screenWidth/2;
        _dengluhead.frame = CGRectMake(screenWidth/2-headWidth/2, 80, headWidth, headWidth);
        _dengluhead.layer.cornerRadius = _dengluhead.frame.size.width/2;
        _dengluhead.layer.masksToBounds = YES;
        [self.view addSubview:_dengluhead];
    }
    return _dengluhead;
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

- (UILabel*) idLabel {
    if (_idLabel == nil) {
        _idLabel = [[UILabel alloc] init];
        _idLabel.text = @"用户ID  ";
        [self.view addSubview:_idLabel];
        
        [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(self.view.frame.size.width - 20);
            make.top.mas_equalTo(self.dengluhead.mas_bottom).offset(30);
            make.left.mas_equalTo(self.view.mas_left).offset(20);
        }];
    }
    return _idLabel;
}

- (UILabel*) nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"用户名  ";
        [self.view addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(self.view.frame.size.width - 100);
            make.top.mas_equalTo(self.idLabel).offset(30);
            make.left.mas_equalTo(self.view.mas_left).offset(20);
        }];
    }
    return _nameLabel;
}

- (UIButton*) btnRename {
    if (_btnRename == nil) {
        _btnRename = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnRename setTitle:@"修改" forState:UIControlStateNormal];
        [_btnRename addTarget:self action:@selector(rename) forControlEvents:UIControlEventTouchUpInside];
        //[_btnManage setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:_btnRename];
        
        [_btnRename mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(60);
            make.top.equalTo(_nameLabel.mas_top);
            make.left.equalTo(_nameLabel.mas_right).offset(20);
        }];
    }
    return _btnRename;
}

- (void) rename {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改用户名" message:@"请输入新的用户名" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"用户名";
    }];
    
    
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf1 = [alertController.textFields objectAtIndex:0];
        [HIService modifyMyselfWithName:tf1.text Callback:^(NSString * state) {
                //NSLog(@"改名：%@", state);
                if([state compare:@"success"] == NSOrderedSame) {
                    self.nameLabel.text = [NSString stringWithFormat:@"用户名  %@", tf1.text];
                } else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改用户名失败" message:@"请输入合法的用户名" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:true completion:nil];
                }
            }];
            
    }]];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    [self presentViewController:alertController animated:true completion:nil];
}

- (UILabel*) emailLabel {
    if (_emailLabel == nil) {
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.text = @"邮箱      ";
        [self.view addSubview:_emailLabel];
        
        [_emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(self.view.frame.size.width - 20);
            make.top.mas_equalTo(self.nameLabel).offset(30);
            make.left.mas_equalTo(self.view.mas_left).offset(20);
        }];
    }
    return _emailLabel;
}




- (void) getInfo {
    [HIService getMyselfWithCallback:^(NSString * state, HIUser * user) {
        [self idLabel].text = [[self idLabel].text stringByAppendingString:user.uid];
        [self nameLabel].text = [[self nameLabel].text stringByAppendingString:user.name];
        [self emailLabel].text = [[self emailLabel].text stringByAppendingString:user.email];
    }];
}


#pragma mark - forTest

/* 测试获取用户信息功能 */
//    UIButton *btnGetInfo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnGetInfo setTitle:@"测试获取信息" forState:UIControlStateNormal];
//    [btnGetInfo setBackgroundColor:[UIColor whiteColor]];
//    [btnGetInfo addTarget:self action:@selector(testGetInfo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnGetInfo];
//    [btnGetInfo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(self.view.frame.size.width * 0.25);
//        make.top.equalTo(self.view).offset(15);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];

//- (void)testGetInfo {
////    [MYService getUserInfoWithID:@"" Callback:^(NSDictionary * r) {
////        NSLog(@"%@", r);
////    }];
//    [HIService getMyselfWithCallback:^(NSString * state, HIUser * user) {
//        NSLog(@"获取个人信息：%@", state);
//        NSLog(@"%@", user);
//    }];
//}

@end
