//
//  VCReplyDetail.m
//  G23
//
//  Created by student12 on 2020/11/30.
//

#import "VCReplyDetail.h"
#import "Masonry.h"
#import "HIService.h"


@interface VCReplyDetail ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *replytext;
@property (nonatomic, strong) NSString *rid;

@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UITextView *detailLabel;

@property (nonatomic, strong) UIButton *deletebtn;

@end


@implementation VCReplyDetail

- (UIView*)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];

        gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1].CGColor];

        //位置x,y 自己根据需求进行设置 使其从不同位置进行渐变
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

        [self.backView.layer addSublayer:gradientLayer];
        [self.view addSubview:_backView];
    }
    return _backView;
}

- (void)initReply {
    _replyView = [[UIView alloc] init];
    _replyView.layer.borderColor = [UIColor grayColor].CGColor;
    _replyView.layer.borderWidth = 1;
    [self.view addSubview:_replyView];
    
    [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height/4);
        make.width.mas_equalTo(self.view.frame.size.width-40);
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(20);
    }];
    
    _replyView.layer.cornerRadius = 15;
    _replyView.layer.masksToBounds = YES;
    
    [_replyView addSubview:self.backView];
    
    _userLabel = [[UILabel alloc]init];
    [_replyView addSubview:_userLabel];
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(self.view.frame.size.width-60);
        make.top.mas_equalTo(_replyView.mas_top).offset(10);
        make.left.mas_equalTo(_replyView.mas_left).offset(10);
    }];
    
    _userLabel.text = _name;
    
    _detailLabel = [[UITextView alloc]init];
    _detailLabel.editable = NO;
    [_replyView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.frame.size.width-60);
        make.top.mas_equalTo(_userLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_replyView.mas_left).offset(10);
        make.bottom.mas_equalTo(_replyView.mas_bottom).offset(-50);
    }];
    
    _detailLabel.backgroundColor = [UIColor clearColor];
    
    _detailLabel.text = _replytext;
    
    _deletebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_deletebtn setTitle:@"x" forState:UIControlStateNormal];
    [_deletebtn setBackgroundColor:[UIColor whiteColor]];
    [_deletebtn addTarget:self action:@selector(clickdeletebtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_replyView addSubview:_deletebtn];
    
    [_deletebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_replyView.mas_top).offset(10);
        make.right.equalTo(_replyView.mas_right).offset(-10);
    }];
    
    _deletebtn.layer.cornerRadius = 15;
    _deletebtn.clipsToBounds = YES;
    
    _deletebtn.layer.borderColor = [UIColor grayColor].CGColor;
    _deletebtn.layer.borderWidth = 0.8;
}

- (id)initWithUser:(NSString*)username andDetail:(NSString*)replydetail andReplyid:(NSString *)replyid {
    self = [super init];
    if (self) {
        _name = username;
        _replytext = replydetail;
        _rid = replyid;
        [self initReply];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"回复详情";
}

- (void)clickdeletebtn {
    [HIService deleteReplyWithID:self.rid Callback:^(NSString * state) {
        if([state compare:@"success"] == NSOrderedSame) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];

            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
                
            [self presentViewController:alertController animated:true completion:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除失败" message:@"你不是本人啦" preferredStyle:UIAlertControllerStyleAlert];

            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
                
            [self presentViewController:alertController animated:true completion:nil];
        }
    }];
}



@end
