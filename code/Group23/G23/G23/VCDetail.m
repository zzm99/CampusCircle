//
//  VCDetail.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "VCDetail.h"
#import "Masonry.h"
#import "HIService.h"
#import "VCCommentDetail.h"
#import "VCEdit.h"
#import "VCUserDetail.h"

@interface VCDetail ()


@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) NSString *curContentID;

@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UITextView *detailLabel;

@property (nonatomic, strong) UIButton *commentbtn;
@property (nonatomic, strong) UIButton *likebtn;

@property (nonatomic, strong) NSMutableArray *commentdataSource;
@property (nonatomic, strong) UITableView *commenttableview;

@property (nonatomic, strong) UIButton *editbtn;
@property (nonatomic, strong) UIButton *deletebtn;

@property (nonatomic, strong) UICollectionView *collect;
@property (nonatomic, strong) UICollectionView *tagcollect;

@property (nonatomic, strong) NSMutableArray *imagearray;
@property (nonatomic, strong) NSArray *tagarray;

// 用于图片放大
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;

@property (nonatomic, strong) UIImage *img;

@end

@implementation VCDetail

- (void)viewDidAppear:(BOOL)animated{
    [self initComment];
}

- (void)clickeditbtn {    
    VCEdit *vc = [VCEdit new];
    [vc setCID:self.curContentID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickdeletebtn {
    [HIService deleteContentWithID:self.curContentID Callback:^(NSString *state){
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

- (void)initContent {
    _contentView = [[UIView alloc] init];
    _contentView.layer.borderColor = [UIColor grayColor].CGColor;
    _contentView.layer.borderWidth = 1;
    [self.view addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height/5*2);
        make.width.mas_equalTo(self.view.frame.size.width-40);
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(20);
    }];
    
    _contentView.layer.cornerRadius = 15;
    _contentView.layer.masksToBounds = YES;
    
    [_contentView addSubview:self.backView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    [_contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.view.frame.size.width-60);
        make.top.mas_equalTo(_contentView.mas_top).offset(10);
        make.left.mas_equalTo(_contentView.mas_left).offset(10);
    }];
    
    _userLabel = [[UILabel alloc]init];
    [_contentView addSubview:_userLabel];
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(self.view.frame.size.width-60);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_contentView.mas_left).offset(10);
    }];
    
    _userLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserDetail)];
    [_userLabel addGestureRecognizer:tap];
    
    _detailLabel = [[UITextView alloc]init];
    _detailLabel.editable = NO;
    [_contentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.frame.size.width-140);
        make.top.mas_equalTo(_userLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_contentView.mas_left).offset(10);
        make.bottom.mas_equalTo(_contentView.mas_bottom).offset(-150);
    }];
    
    _detailLabel.backgroundColor = [UIColor clearColor];
    
    _commentbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _commentbtn.layer.borderWidth = 1;
    _commentbtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_commentbtn addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_commentbtn];
    
    _commentbtn.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.4];
    
    [_commentbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.view.frame.size.width-40)/2);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(_contentView.mas_bottom).offset(0);
        make.left.equalTo(_contentView.mas_left).offset(0);
    }];
    
    _likebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _likebtn.layer.borderWidth = 1;
    _likebtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_contentView addSubview:_likebtn];

    _likebtn.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.4];
    
    [_likebtn addTarget:self action:@selector(likeContent) forControlEvents:UIControlEventTouchUpInside];
    
    [_likebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.view.frame.size.width-40)/2);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(_contentView.mas_bottom).offset(0);
        make.left.equalTo(_commentbtn.mas_right).offset(0);
    }];

    _editbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_editbtn setTitle:@"-" forState:UIControlStateNormal];
    [_editbtn setBackgroundColor:[UIColor whiteColor]];
    [_editbtn addTarget:self action:@selector(clickeditbtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_editbtn];
    
    [_editbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_contentView.mas_top).offset(10);
        make.right.equalTo(_contentView.mas_right).offset(-50);
    }];
    
    _editbtn.layer.cornerRadius = 15;
    _editbtn.clipsToBounds = YES;
    
    _editbtn.layer.borderColor = [UIColor grayColor].CGColor;
    _editbtn.layer.borderWidth = 0.8;
    
    _deletebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_deletebtn setTitle:@"x" forState:UIControlStateNormal];
    [_deletebtn setBackgroundColor:[UIColor whiteColor]];
    [_deletebtn addTarget:self action:@selector(clickdeletebtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_deletebtn];
    
    [_deletebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_contentView.mas_top).offset(10);
        make.right.equalTo(_contentView.mas_right).offset(-10);
    }];
    
    _time = [[UILabel alloc] init];
    _time.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    [_contentView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(110);
        make.top.mas_equalTo(_deletebtn.mas_bottom).offset(10);
        make.right.mas_equalTo(_contentView.mas_right).offset(-5);
    }];
    
    _deletebtn.layer.cornerRadius = 15;
    _deletebtn.clipsToBounds = YES;
    
    _deletebtn.layer.borderColor = [UIColor grayColor].CGColor;
    _deletebtn.layer.borderWidth = 0.8;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(50, 50);
    _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-45, 200, 90) collectionViewLayout:layout];
    _collect.backgroundColor = [UIColor clearColor];
    _collect.delegate=self;
    _collect.dataSource=self;
    [_collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [_contentView addSubview:_collect];
    
    [_collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(310);
        make.bottom.equalTo(_likebtn.mas_top).offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UICollectionViewFlowLayout * layout1 = [[UICollectionViewFlowLayout alloc]init];
    layout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout1.itemSize = CGSizeMake(50, 20);
    _tagcollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout1];
    _tagcollect.backgroundColor = [UIColor clearColor];
    _tagcollect.delegate=self;
    _tagcollect.dataSource=self;
    [_tagcollect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid-tag"];
    [_contentView addSubview:_tagcollect];
    
    [_tagcollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(60);
        make.bottom.equalTo(_collect.mas_top).offset(10);
        make.right.equalTo(_contentView.mas_right).offset(-10);
    }];
    
    [HIService getDetailedContentWithContentID:self.curContentID Callback:^(NSString * state, HIContent * content) {
        self.titleLabel.text = content.title;
        self.userLabel.text = [@"作者：" stringByAppendingString:content.userName];
        self.detailLabel.text = content.detail;
        self.time.text = [self getTimeFromTimestamp:content.editTime];
        
        NSUInteger commentnum = content.commentNum;
        NSString *tmpcommentnum = [NSString stringWithFormat:@"%lu", commentnum];
        NSString *showCommentText = [@"评论 : " stringByAppendingString:tmpcommentnum];
        [self.commentbtn setTitle:showCommentText forState:UIControlStateNormal];
        
        NSUInteger likenum = content.likeNum;
        NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
        NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
        [self.likebtn setTitle:showLikeText forState:UIControlStateNormal];
        
        self.imagearray = [content.images mutableCopy];
        self.tagarray = [content.tags mutableCopy];
        [self.collect reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self.tagcollect reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }];
}

- (NSString*) getTimeFromTimestamp: (NSUInteger) timestamp {
    NSTimeInterval time = timestamp / 1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

- (void)initComment {
    [HIService getCommentsWithContentID:_curContentID Callback:^(NSString * state, NSArray * comments) {
        [self.commentdataSource removeAllObjects];
        
        for (HIComment * comment in comments) {
            [self.commentdataSource addObject:comment];
        }
        
        [self.commenttableview reloadData];
    }];
}

- (id)initWithContentID:(NSString *)aID {
    self = [super init];
    if (self) {
        _curContentID = [NSString stringWithString:aID];
        self.commentdataSource = [NSMutableArray arrayWithArray:@[]];
        
        [self initContent];
        [self initComment];
    }
    return self;
}

- (void)addComment {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"评论" message:@"请输入评论" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入评论";
    }];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alertController.textFields.firstObject;
            
            [HIService getDetailedContentWithContentID:self.curContentID Callback:^(NSString * state, HIContent * content) {
                [HIService addCommentWithContent:content Detail:tf.text Callback:^(NSString * state) {
                    if([state compare:@"success"] == NSOrderedSame) {
                        [self initComment];
                        [HIService getDetailedContentWithContentID:self.curContentID Callback:^(NSString * state, HIContent * content) {
                            NSUInteger commentnum = content.commentNum;
                            NSString *tmpcommentnum = [NSString stringWithFormat:@"%lu", commentnum];
                            NSString *showCommentText = [@"评论 : " stringByAppendingString:tmpcommentnum];
                            [self.commentbtn setTitle:showCommentText forState:UIControlStateNormal];
                        }];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"评论失败" message:@"不能发空白评论哦" preferredStyle:UIAlertControllerStyleAlert];

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"内容详情";
    [self.navigationController viewWillAppear:YES];
    self.imagearray = [NSMutableArray array];
    self.tagarray = [NSArray array];
}

- (UITableView*)commenttableview {
    if(_commenttableview == nil) {
        _commenttableview = [[UITableView alloc] init];
        _commenttableview.delegate = self;
        _commenttableview.dataSource = self;
        [_commenttableview  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_commenttableview];
        [_commenttableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.frame.size.width-20);
            make.top.equalTo(self.contentView.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    return _commenttableview;
}

- (void)likeContent {
    [HIService likeContentWithID:_curContentID Callback:^(NSString * state) {
        if([state compare:@"success"] == NSOrderedSame) {
            [HIService getDetailedContentWithContentID:self.curContentID Callback:^(NSString * state, HIContent * content) {
                NSUInteger likenum = content.likeNum;
                NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
                [self.likebtn setTitle:showLikeText forState:UIControlStateNormal];
            }];
        } else {
            /*
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点赞失败" message:@"不能重复点赞哦" preferredStyle:UIAlertControllerStyleAlert];

            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
            }]];
                
            [self presentViewController:alertController animated:true completion:nil];
             */
            [HIService dislikeContentWithID:self.curContentID Callback:^(NSString *state) {
                [HIService getDetailedContentWithContentID:self.curContentID Callback:^(NSString * state, HIContent * content) {
                    NSUInteger likenum = content.likeNum;
                    NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                    NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
                    [self.likebtn setTitle:showLikeText forState:UIControlStateNormal];
                }];
            }];
        }
    }];
}

- (void)gotoUserDetail{
        [HIService getDetailedContentWithContentID:self.curContentID Callback:^(NSString * state, HIContent * content) {
            if([state compare:@"success"] == NSOrderedSame) {
                VCUserDetail *vc = [[VCUserDetail alloc]initWithUserID:content.ownUID];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
}

- (void)clickcommentlikebtn:(UIButton*) sender {
    [HIService getCommentsWithContentID:_curContentID Callback:^(NSString * state, NSArray * comments) {
        if ([comments count] == 0) {
            return;
        }
        HIComment * comment = comments[sender.tag];
        [HIService likeCommentWithID:comment.cmid Callback:^(NSString * state) {
            if([state compare:@"success"] == NSOrderedSame) {
                NSUInteger likenum = comment.likeNum+1;
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
                [HIService dislikeCommentWithID:comment.cmid Callback:^(NSString *state) {
                    if([state compare:@"success"] == NSOrderedSame) {
                        NSUInteger likenum = comment.likeNum-1;
                        NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                        NSString *showLikeText = [@"❤️ : " stringByAppendingString:tmplikenum];
                        [sender setTitle:showLikeText forState:UIControlStateNormal];
                    }
                }];
            }
        }];
    }];
}


- (void)clickcommentreplybtn:(UIButton*) sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"评论" message:@"请输入对此评论的回复" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入回复";
    }];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alertController.textFields.firstObject;
            
            [HIService getCommentsWithContentID:self.curContentID Callback:^(NSString *state, NSArray *comments) {
                if ([comments count] == 0) {
                    return;
                }
                HIComment *comment = comments[sender.tag];
                [HIService addReplyWithComment:comment Detail:tf.text Callback:^(NSString *state) {
                    if([state compare:@"success"] == NSOrderedSame) {
                        // NSLog(@"回复了评论：%@ %@", comment.detail, tf.text);
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


/* 暂时未完成功能 */
- (void)testGetAllLikes {
    [HIService getAllLikesWithCallback:^(NSString * state, NSArray * likes) {
        NSLog(@"获取所有点赞：%@", state);
        for (NSString * _id in likes) {
            NSLog(@"%@", _id);
        }
    }];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _commentdataSource.count;
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
    
    HIComment *tmpComment = (HIComment*)[self.commentdataSource objectAtIndex:indexPath.section];
    
    NSString *user = tmpComment.userName;
    user = [user stringByAppendingString:@" : "];
    NSString *detail = tmpComment.detail;
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
    
    
    UIButton *commentlikebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    NSUInteger likenum = tmpComment.likeNum;
    NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
    NSString *showLikeText = [@"❤️ : " stringByAppendingString:tmplikenum];
    [commentlikebtn setTitle:showLikeText forState:UIControlStateNormal];
    
    commentlikebtn.tag = indexPath.section;
    [commentlikebtn addTarget:self action:@selector(clickcommentlikebtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:commentlikebtn];
    
    [commentlikebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(testView.mas_top).offset(10);
        make.right.mas_equalTo(testView.mas_right).offset(-10);
        make.bottom.mas_equalTo(testView.mas_bottom).offset(-10);
    }];
    
    UIButton *commentreplybtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [commentreplybtn setTitle:@"回复" forState:UIControlStateNormal];
    
    [cell.contentView addSubview:commentreplybtn];
    
    [commentreplybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(35);
        make.top.mas_equalTo(testView.mas_top).offset(10);
        make.right.mas_equalTo(commentlikebtn.mas_left).offset(0);
        make.bottom.mas_equalTo(testView.mas_bottom).offset(-10);
    }];
    
    commentreplybtn.tag = indexPath.section;
    [commentreplybtn addTarget:self action:@selector(clickcommentreplybtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VCCommentDetail *detail = [[VCCommentDetail alloc] initWithContentID:_curContentID andCommentIdx:indexPath.section];
    [detail.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UICollectionView

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if([collectionView isEqual:self.collect]) {
        return 1;
    } else {
        return 1;
    }
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if([collectionView isEqual:self.collect]) {
        return self.imagearray.count;
    } else {
        return self.tagarray.count;
    }
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if([collectionView isEqual:self.collect]) {
        UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        if(indexPath.item < self.imagearray.count) {
            [HIService getImageWithURL:[self.imagearray objectAtIndex:indexPath.item] Callback:^(UIImage *im) {
                UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                mv.image = im;
                mv.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
                [mv addGestureRecognizer:tap];
                [cell.contentView addSubview:mv];
            }];
        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } else {
        UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid-tag" forIndexPath:indexPath];
        
        if(indexPath.item < self.tagarray.count) {
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
            lb.text = [self.tagarray objectAtIndex:indexPath.item];
            
            [lb setBackgroundColor:[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.4]];
            
            lb.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showtag:)];
            [lb addGestureRecognizer:tap];
            
            [cell.contentView addSubview:lb];
        }
        return cell;
    }
}

#pragma mark 长按手势弹出警告视图确认
-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //NSLog(@"取消保存图片");
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //NSLog(@"确认保存图片");
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(self.img ,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        }];
        [alertControl addAction:cancel];
        [alertControl addAction:confirm];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
    
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    NSString*message =@"提示";
    if(!error) {
        message =@"成功保存到相册";
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {  }];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else
    {
        message = [error description];
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {   }];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

- (void)showtag:(UITapGestureRecognizer *)tap {
    NSString *t = [(UILabel*)tap.view text];
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"标签" message:t preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {  }];
    [alertControl addAction:action];
    [self presentViewController:alertControl animated:YES completion:nil];
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

     UILongPressGestureRecognizer* longaa = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
     [bgView addGestureRecognizer:longaa];
    
     UIImageView *picView = (UIImageView *)tap.view;
      
     UIImageView *imageView = [[UIImageView alloc] init];
     imageView.image = picView.image;
     self.img = picView.image;
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
