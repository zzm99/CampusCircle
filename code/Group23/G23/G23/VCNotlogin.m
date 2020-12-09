//
//  VCNotlogin.m
//  G23
//
//  Created by yan on 2020/11/27.
//

#import "VCNotlogin.h"
#import "Masonry.h"
#import "HIService.h"
#import "VCSetting.h"
#import "textFieldBackground.h"
#import "XLBallLoading.h"

@interface VCNotlogin ()

@property (nonatomic, strong) UIImageView *dengluhead;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *apbackground;
@property (nonatomic, strong) UITextField *account;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;

// 用于图片放大
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;

@end

@implementation VCNotlogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self backView];
    [self dengluhead];
    [self apbackground];
    [self loginButton];
    [self registerButton];
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
        
        _dengluhead.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
        [_dengluhead addGestureRecognizer:tap];
        
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

- (UIView*)apbackground {
    if(_apbackground == nil) {
        _apbackground = [[textFieldBackground alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width-40, 100)];
        [_apbackground setBackgroundColor:[UIColor whiteColor]];
        [[_apbackground layer] setCornerRadius:5];
        [[_apbackground layer] setMasksToBounds:YES];
        
        [self.view addSubview:_apbackground];
        
        [_apbackground mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(100);
            make.width.mas_equalTo(self.view.frame.size.width-100);
            make.top.equalTo(self.dengluhead.mas_bottom).offset(40);
            make.left.equalTo(self.view).offset(50);
        }];
        
        [self account];
        [self password];
    }
    return _apbackground;
}

- (UITextField*)account {
    if(_account == nil) {
        _account=[[UITextField alloc] init];
        _account.backgroundColor=[UIColor clearColor];
        _account.placeholder=[NSString stringWithFormat:@"Email"];
        _account.layer.cornerRadius=5.0;
        
        [self.apbackground addSubview:_account];
        
        [_account mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(self.view.frame.size.width-120);
            make.left.equalTo(self.apbackground).offset(10);
        }];
    }
    return _account;
}

- (UITextField*)password {
    if(_password == nil) {
        _password=[[UITextField alloc] init];
        _password.backgroundColor=[UIColor clearColor];
        _password.placeholder=[NSString stringWithFormat:@"Password"];
        _password.layer.cornerRadius=5.0;
        _password.secureTextEntry=YES;
        [self.apbackground addSubview:_password];
        
        [_password mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(self.view.frame.size.width-120);
            make.top.equalTo(self.apbackground).offset(50);
            make.left.equalTo(self.apbackground).offset(10);
        }];
    }
    return _password;
}

- (UIButton*)loginButton {
    if(_loginButton == nil) {
        _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1]];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius=5.0;
        
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_loginButton];
        
        [_loginButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(self.view.frame.size.width-100);
            make.top.equalTo(self.password.mas_bottom).offset(15);
            make.left.equalTo(self.view).offset(50);
        }];
    }
    return _loginButton;
}

- (void)login {
    [XLBallLoading showInView:self.view];
    NSString *email = self.account.text;
    NSString *pwd = self.password.text;
    [HIService loginWithEmail:email Pwd:pwd Callback:^(NSString * state) {
        // NSLog(@"登录：%@", state);
        if ([state isEqualToString:@"success"]) {
            [HIService getMyselfWithCallback:^(NSString * state, HIUser * me) {
                if (![state isEqualToString:@"success"]) {
                    // NSLog(@"试图获取自己的个人信息时失败，状态码：%@", state);
                    return;
                }
                [[NSUserDefaults standardUserDefaults] setObject:me.uid forKey:@"loginuid"];
                VCSetting *setting = [VCSetting new];
                [XLBallLoading hideInView:self.view];
                [self.navigationController setViewControllers:@[setting] animated:YES];
            }];
        } else {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"登录提示" message:@"邮箱或密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //取消处理
            }];
            [XLBallLoading hideInView:self.view];
            [alertVc addAction:ok];
            [self presentViewController:alertVc animated:YES completion:^{}];
        }
    }];
}

- (UIButton*)registerButton {
    if(_registerButton == nil) {
        _registerButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_registerButton setTitle:@"register" forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:[UIColor clearColor]];
        [_registerButton setTitleColor:[UIColor colorWithRed:115.0/255.0 green:196.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        [_registerButton addTarget:self action:@selector(regis) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_registerButton];
        
        [_registerButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(100);
            make.top.equalTo(self.loginButton.mas_bottom).offset(5);
            make.centerX.equalTo(self.view);
        }];
    }
    return _registerButton;
}

- (void)regis {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册" message:@"请输入用户名、邮箱、密码" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入用户名";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入邮箱";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入密码";
    }];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf1 = [alertController.textFields objectAtIndex:0];
            UITextField *tf2 = [alertController.textFields objectAtIndex:1];
            UITextField *tf3 = [alertController.textFields objectAtIndex:2];
            
            [HIService registerWithName:tf1.text Email:tf2.text Pwd:tf3.text Callback:^(NSString * state) {
                NSLog(@"注册：%@", state);
                NSString *showstr;
                if ([state isEqualToString:@"success"]){
                    showstr = [@"注册" stringByAppendingString:@"成功"];
                } else {
                    showstr = [@"注册" stringByAppendingString:@"失败，该邮箱已被注册"];
                }
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"注册提示" message:showstr preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        //取消处理
                }];
                [alertVc addAction:cencel];
                [self presentViewController:alertVc animated:YES completion:^{}];
            }];
    }]];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    [self presentViewController:alertController animated:true completion:nil];
}


- (void)showZoomImageView:(UITapGestureRecognizer *)tap {
     if (![(UIImageView *)tap.view image]) {
      return;
     }
     //scrollView作为背景
     UIScrollView *bgView = [[UIScrollView alloc] init];
     bgView.frame = [UIScreen mainScreen].bounds;
     bgView.backgroundColor = [UIColor blackColor];
     UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
     [bgView addGestureRecognizer:tapBg];
      
     UIImageView *picView = (UIImageView *)tap.view;
      
     UIImageView *imageView = [[UIImageView alloc] init];
     imageView.image = picView.image;
     imageView.frame = [bgView convertRect:picView.frame fromView:self.view];
     [bgView addSubview:imageView];
      
     [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
      
     self.lastImageView = imageView;
     self.originalFrame = imageView.frame;
     self.scrollView = bgView;
     //最大放大比例
     self.scrollView.maximumZoomScale = 1.5;
     self.scrollView.delegate = self;
      
     [UIView animateWithDuration:0.5 animations:^{
      CGRect frame = imageView.frame;
      frame.size.width = bgView.frame.size.width;
      frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
      frame.origin.x = 0;
      frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
      imageView.frame = frame;
     }];
}
 
- (void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer {
     self.scrollView.contentOffset = CGPointZero;
     [UIView animateWithDuration:0.5 animations:^{
      self.lastImageView.frame = self.originalFrame;
      tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
     } completion:^(BOOL finished) {
      [tapBgRecognizer.view removeFromSuperview];
      self.scrollView = nil;
      self.lastImageView = nil;
     }];
}
 
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.lastImageView;
}

@end
