//
//  VCCommentDetail.m
//  G23
//
//  Created by student12 on 2020/11/30.
//

#import "VCCommentDetail.h"
#import "Masonry.h"
#import "HIService.h"
#import "VCReplyDetail.h"


@interface VCCommentDetail ()


@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSString *curContentID;
@property (nonatomic, assign) NSInteger curCommentIdx;

@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UITextView *detailLabel;

@property (nonatomic, strong) UIButton *replybtn;
@property (nonatomic, strong) UIButton *likebtn;

@property (nonatomic, strong) NSMutableArray *replydataSource;
@property (nonatomic, strong) UITableView *replytableview;

@property (nonatomic, strong) UIButton *deletebtn;

@end

@implementation VCCommentDetail

- (void)viewDidAppear:(BOOL)animated{
    [self initReply];
}

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

- (void)likeComment:(UIButton*) sender {
    [HIService getCommentsWithContentID:_curContentID Callback:^(NSString * state, NSArray * comments) {
        if ([comments count] == 0) {
            return;
        }
        HIComment * comment = comments[self.curCommentIdx];
        [HIService likeCommentWithID:comment.cmid Callback:^(NSString * state) {
            if([state compare:@"success"] == NSOrderedSame) {
                NSUInteger likenum = comment.likeNum+1;
                NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
                [sender setTitle:showLikeText forState:UIControlStateNormal];
            } else {
                /*
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点赞失败" message:@"不能重复点赞哦" preferredStyle:UIAlertControllerStyleAlert];

                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                }]];
                    
                [self presentViewController:alertController animated:true completion:nil];
                 */
                [HIService dislikeCommentWithID:comment.cmid Callback:^(NSString *state) {
                    if([state compare:@"success"] == NSOrderedSame) {
                        NSUInteger likenum = comment.likeNum-1;
                        NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                        NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
                        [sender setTitle:showLikeText forState:UIControlStateNormal];
                    }
                }];
            }
        }];
    }];
}

- (void)addReply:(UIButton*) sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"评论" message:@"请输入对此评论进行回复" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入回复";
    }];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alertController.textFields.firstObject;
            
            [HIService getCommentsWithContentID:self.curContentID Callback:^(NSString *state, NSArray *comments) {
                if ([comments count] == 0) {
                    return;
                }
                HIComment *comment = comments[self.curCommentIdx];
                [HIService addReplyWithComment:comment Detail:tf.text Callback:^(NSString *state) {
                    if([state compare:@"success"] == NSOrderedSame) {
                        [self initReply];
                        // NSLog(@"回复了评论：%@ %@", comment.detail, tf.text);
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回复成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                
                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSUInteger replynum = comment.replies.count+1;
                            NSString *tmpreplynum = [NSString stringWithFormat:@"%lu", replynum];
                            NSString *showreplyText = [@"回复 : " stringByAppendingString:tmpreplynum];
                            [self.replybtn setTitle:showreplyText forState:UIControlStateNormal];
                        }]];
                            
                        [self presentViewController:alertController animated:true completion:nil];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回复失败" message:@"不能回复空内容哦" preferredStyle:UIAlertControllerStyleAlert];

                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                        }]];
                            
                        [self presentViewController:alertController animated:true completion:nil];
                    }
                }];
            }];
    }]];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)initComment {
    _commentView = [[UIView alloc] init];
    _commentView.layer.borderColor = [UIColor grayColor].CGColor;
    _commentView.layer.borderWidth = 1;
    [self.view addSubview:_commentView];
    
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height/4);
        make.width.mas_equalTo(self.view.frame.size.width-40);
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(20);
    }];
    
    _commentView.layer.cornerRadius = 15;
    _commentView.layer.masksToBounds = YES;
    
    [_commentView addSubview:self.backView];
    
    _userLabel = [[UILabel alloc]init];
    [_commentView addSubview:_userLabel];
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(self.view.frame.size.width-60);
        make.top.mas_equalTo(_commentView.mas_top).offset(10);
        make.left.mas_equalTo(_commentView.mas_left).offset(10);
    }];
    
    _detailLabel = [[UITextView alloc]init];
    _detailLabel.editable = NO;
    [_commentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.frame.size.width-60);
        make.top.mas_equalTo(_userLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_commentView.mas_left).offset(10);
        make.bottom.mas_equalTo(_commentView.mas_bottom).offset(-50);
    }];
    
    _detailLabel.backgroundColor = [UIColor clearColor];
    
    
    _replybtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _replybtn.layer.borderWidth = 1;
    _replybtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_replybtn addTarget:self action:@selector(addReply:) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:_replybtn];
    
    _replybtn.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.4];
    
    [_replybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.view.frame.size.width-40)/2);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(_commentView.mas_bottom).offset(0);
        make.left.equalTo(_commentView.mas_left).offset(0);
    }];
    
    _likebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _likebtn.layer.borderWidth = 1;
    _likebtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_commentView addSubview:_likebtn];

    _likebtn.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.4];
    
    [_likebtn addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [_likebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.view.frame.size.width-40)/2);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(_commentView.mas_bottom).offset(0);
        make.left.equalTo(_replybtn.mas_right).offset(0);
    }];
     
    _deletebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_deletebtn setTitle:@"x" forState:UIControlStateNormal];
    [_deletebtn setBackgroundColor:[UIColor whiteColor]];
    [_deletebtn addTarget:self action:@selector(clickdeletebtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_commentView addSubview:_deletebtn];
    
    [_deletebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_commentView.mas_top).offset(10);
        make.right.equalTo(_commentView.mas_right).offset(-10);
    }];
    
    _deletebtn.layer.cornerRadius = 15;
    _deletebtn.clipsToBounds = YES;
    
    _deletebtn.layer.borderColor = [UIColor grayColor].CGColor;
    _deletebtn.layer.borderWidth = 0.8;
    
    [HIService getCommentsWithContentID:self.curContentID Callback:^(NSString * state, NSArray * comments) {
        if ([comments count] == 0) {
            // NSLog(@"测试失败：评论数量为0");
            return;
        }
        HIComment * comment = comments[self.curCommentIdx];
        
        self.userLabel.text = [@"作者：" stringByAppendingString:comment.userName];
        self.detailLabel.text = comment.detail;
        
        NSUInteger replynum = comment.replies.count;
        NSString *tmpreplynum = [NSString stringWithFormat:@"%lu", replynum];
        NSString *showreplyText = [@"回复 : " stringByAppendingString:tmpreplynum];
        [self.replybtn setTitle:showreplyText forState:UIControlStateNormal];
        
        NSUInteger likenum = comment.likeNum;
        NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
        NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
        [self.likebtn setTitle:showLikeText forState:UIControlStateNormal];
    }];
}

- (void)initReply {
    [HIService getCommentsWithContentID:_curContentID Callback:^(NSString * state, NSArray * comments) {
        if ([comments count] == 0) {
            // NSLog(@"测试失败：评论数量为0");
            return;
        }
        HIComment * comment = comments[self.curCommentIdx];
        NSArray * replies = comment.replies;
        /*
        if ([replies count] == 0) {
            //NSLog(@"测试失败：首条评论的回复数量为0");
            return;
        }
         */
        [self.replydataSource removeAllObjects];
        self.replydataSource = [replies mutableCopy];
        [self.replytableview reloadData];
    }];
}

- (UITableView*)replytableview {
    if(_replytableview == nil) {
        _replytableview = [[UITableView alloc] init];
        _replytableview.delegate = self;
        _replytableview.dataSource = self;
        [_replytableview  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_replytableview];
        [_replytableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.frame.size.width-20);
            make.top.equalTo(self.commentView.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    return _replytableview;
}

- (id)initWithContentID:(NSString *)aID andCommentIdx:(NSInteger)idx{
    self = [super init];
    if (self) {
        _curContentID = [NSString stringWithString:aID];
        _curCommentIdx = idx;
        self.replydataSource = [NSMutableArray arrayWithArray:@[]];
        
        [self initComment];
        [self initReply];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论详情";
    [self.navigationController viewWillAppear:YES];
}

- (void)clickdeletebtn {
    [HIService getCommentsWithContentID:_curContentID Callback:^(NSString * state, NSArray * comments) {
        if ([comments count] == 0) {
            return;
        }
        HIComment * comment = comments[self.curCommentIdx];
        [HIService deleteCommentWithID:comment.cmid Callback:^(NSString *state) {
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
    }];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _replydataSource.count;
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
    static NSString *identifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    } else {
        for(UIView* sv in [cell.contentView subviews]) {
            [sv removeFromSuperview];
        }
    }
    
    UIView *testView = [[UIView alloc]init];
    [cell.contentView addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.contentView.mas_top).offset(0);
        make.left.mas_equalTo(cell.contentView.mas_left).offset(10);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-5);
    }];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];

    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [bg.layer addSublayer:gradientLayer];
    [testView addSubview:bg];
    
    testView.layer.borderColor = [UIColor grayColor].CGColor;
    testView.layer.borderWidth = 0.5;
    testView.layer.cornerRadius = 5;
    testView.layer.masksToBounds = YES;
    
    HIReply *tmpReply = (HIReply*)[self.replydataSource objectAtIndex:indexPath.section];
    
    NSString *user = tmpReply.userName;
    user = [user stringByAppendingString:@" :@"];
    NSString *replyuser = tmpReply.repliedName;
    user = [user stringByAppendingString:replyuser];
    user = [user stringByAppendingFormat:@" "];
    NSString *detail = tmpReply.detail;
    NSString *show = [user stringByAppendingString:detail];
    
    UILabel *lb = [[UILabel alloc]init];
    lb.text = show;
    [testView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(cell.contentView.frame.size.width-150);
        make.top.mas_equalTo(testView.mas_top).offset(10);
        make.left.mas_equalTo(testView.mas_left).offset(10);
        make.bottom.mas_equalTo(testView.mas_bottom).offset(-10);
    }];
    
    UIButton *replylikebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    NSUInteger likenum = tmpReply.likeNum;
    NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
    NSString *showLikeText = [@"❤️ : " stringByAppendingString:tmplikenum];
    [replylikebtn setTitle:showLikeText forState:UIControlStateNormal];
    
    replylikebtn.tag = indexPath.section;
    [replylikebtn addTarget:self action:@selector(clickreplylikebtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:replylikebtn];
    
    [replylikebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(testView.mas_top).offset(10);
        make.right.mas_equalTo(testView.mas_right).offset(-10);
        make.bottom.mas_equalTo(testView.mas_bottom).offset(-10);
    }];
    
    UIButton *replyreplybtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [replyreplybtn setTitle:@"回复" forState:UIControlStateNormal];
    
    [cell.contentView addSubview:replyreplybtn];
    
    [replyreplybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(35);
        make.top.mas_equalTo(testView.mas_top).offset(10);
        make.right.mas_equalTo(replylikebtn.mas_left).offset(0);
        make.bottom.mas_equalTo(testView.mas_bottom).offset(-10);
    }];
    
    replyreplybtn.tag = indexPath.section;
    [replyreplybtn addTarget:self action:@selector(clickreplyreply:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    
    return cell;
}

- (void)clickreplylikebtn:(UIButton*) sender {
    [HIService getCommentsWithContentID:_curContentID Callback:^(NSString *state, NSArray *comments) {
        if ([comments count] == 0) {
            //NSLog(@"测试失败：最新的内容底下还没有评论");
            return;
        }
        HIComment * comment = comments[self.curCommentIdx];
        NSArray * replies = comment.replies;
        if ([replies count] == 0) {
            //NSLog(@"测试失败：最新内容的首条评论下还没回复呢");
            return;
        }
        HIReply * reply = replies[sender.tag];
        [HIService likeReplyWithID:reply.rid Callback:^(NSString *state) {
            //NSLog(@"点赞最新内容的首条评论的首条回复：%@", state);
            if([state compare:@"success"] == NSOrderedSame) {
                NSUInteger likenum = reply.likeNum+1;
                NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                NSString *showLikeText = [@"❤️ : " stringByAppendingString:tmplikenum];
                [sender setTitle:showLikeText forState:UIControlStateNormal];
            } else {
                /*
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点赞失败" message:@"不能重复点赞哦" preferredStyle:UIAlertControllerStyleAlert];

                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                }]];
                    
                [self presentViewController:alertController animated:true completion:nil];
                 */
                [HIService dislikeReplyWithID:reply.rid Callback:^(NSString *state) {
                    if([state compare:@"success"] == NSOrderedSame) {
                        NSUInteger likenum = reply.likeNum-1;
                        NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                        NSString *showLikeText = [@"❤️ : " stringByAppendingString:tmplikenum];
                        [sender setTitle:showLikeText forState:UIControlStateNormal];
                    }
                }];
            }
        }];
    }];
}

- (void)clickreplyreply:(UIButton*) sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回复" message:@"请输入对此回复的回复" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入回复";
    }];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alertController.textFields.firstObject;
        
            [HIService getCommentsWithContentID:self.curContentID Callback:^(NSString * state, NSArray * comments) {
                if ([comments count] == 0) {
                    //NSLog(@"测试失败：评论数量为0");
                    return;
                }
                HIComment * comment = comments[self.curCommentIdx];
                NSArray * replies = comment.replies;
                if ([replies count] == 0) {
                    //NSLog(@"测试失败：首条评论的回复数量为0");
                    return;
                }
                HIReply * reply = replies[sender.tag];
                [HIService addReplyWithReply:reply Detail:tf.text Callback:^(NSString * state) {
                    //NSLog(@"回复首条评论的首个回复：%@", state);
                    if([state compare:@"success"] == NSOrderedSame) {
                        [self initReply];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回复成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];

                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                        }]];
                            
                        [self presentViewController:alertController animated:true completion:nil];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回复失败" message:@"不能回复空内容哦" preferredStyle:UIAlertControllerStyleAlert];

                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                        }]];
                            
                        [self presentViewController:alertController animated:true completion:nil];
                    }
                }];
            }];
    }]];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HIReply *tmpReply = (HIReply*)[self.replydataSource objectAtIndex:indexPath.section];
    VCReplyDetail *detail = [[VCReplyDetail alloc] initWithUser:[tmpReply.userName stringByAppendingString:[@" :@" stringByAppendingString:tmpReply.repliedName]] andDetail:tmpReply.detail andReplyid:tmpReply.rid];
    [detail.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
