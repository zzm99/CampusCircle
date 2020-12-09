//
//  VCUserDetail.m
//  G23
//
//  Created by student12 on 2020/12/1.
//

#import "VCUserDetail.h"
#import "VCDetail.h"
#import "Masonry.h"
#import "HIService.h"

@interface VCUserDetail ()

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *userInfoView;
@property (nonatomic, strong) UIImageView *userInfoImg;
@property (nonatomic, strong) UILabel *userInfoName;
@property (nonatomic, strong) UILabel *userInfoEmail;

@property (nonatomic, assign) BOOL isAS;
@property (nonatomic, assign) BOOL isSearch; // 是否正在快速搜索内容
@property (nonatomic, strong) UISearchBar *searchbar; // 快速搜索内容：搜索关键词
@property (nonatomic, strong) UIButton *leftbutton; // 搜索框下第一个按钮
@property (nonatomic, strong) UIButton *midbutton;  // 搜索框下第二个按钮
@property (nonatomic, strong) UIButton *rightbutton; // 搜索框下第三个按钮
@property (nonatomic, strong) UITableView *mytableview;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *searchtmpdataSource;

@end

@implementation VCUserDetail


- (id)initWithUserID:(NSString *)uid {
    self = [super init];
    if (self) {
        _userID = [NSString stringWithString:uid];
        self.dataSource = [NSMutableArray arrayWithArray:@[]];
        self.searchtmpdataSource = [NSMutableArray arrayWithArray:@[]];
        self.isAS = FALSE;
        [self initContent];
        [self searchbar];
        [self leftbutton];
        [self midbutton];
        [self rightbutton];
        [self mytableview];
        [self getUserContent];
    }
    return self;
}

- (void)getUserContent {
    [HIService getContentsWithUserID:self.userID Callback:^(NSString * state, NSArray * contents){
        [self.dataSource removeAllObjects];
        for (HIContent * content in contents) {
            [self.dataSource addObject:content];
        }
        [self.mytableview reloadData];
    }];
}

- (void)getUserAlbumContent {
    [HIService getAlbumsWithUserID:self.userID Callback:^(NSString * state, NSArray * contents){
        [self.dataSource removeAllObjects];
        for (HIContent * content in contents) {
            [self.dataSource addObject:content];
        }
        [self.mytableview reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.mytableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户详情";
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
    _userInfoView = [[UIView alloc] init];
    _userInfoView.layer.borderColor = [UIColor grayColor].CGColor;
    _userInfoView.layer.borderWidth = 1;
    [self.view addSubview:_userInfoView];
    
    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height/5);
        make.width.mas_equalTo(self.view.frame.size.width-40);
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(20);
    }];
    _userInfoView.layer.cornerRadius = 15;
    _userInfoView.layer.masksToBounds = YES;
    
    [_userInfoView addSubview:self.backView];
    
    _userInfoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
    _userInfoImg.frame = CGRectMake(0, 0, 100, 100);
    int h = self.view.frame.size.height/5;
    _userInfoImg.layer.cornerRadius = (h-40)/2;
    _userInfoImg.layer.masksToBounds = YES;
    
    [_userInfoView addSubview:_userInfoImg];
    
    [_userInfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h-40);
        make.width.mas_equalTo(h-40);
        make.top.mas_equalTo(_userInfoView.mas_top).offset(20);
        make.left.mas_equalTo(_userInfoView.mas_left).offset(10);
    }];
    
    _userInfoName = [[UILabel alloc]init];
    _userInfoName.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_userInfoView addSubview:_userInfoName];
    
    [_userInfoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h/4);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(_userInfoView.mas_top).offset(40);
        make.left.mas_equalTo(_userInfoImg.mas_right).offset(20);
    }];
    
    _userInfoEmail = [[UILabel alloc]init];
    _userInfoEmail.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_userInfoView addSubview:_userInfoEmail];
    
    [_userInfoEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h/4);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(_userInfoName.mas_bottom).offset(10);
        make.left.mas_equalTo(_userInfoImg.mas_right).offset(20);
    }];
    
    [HIService getUserWithID:self.userID Callback:^(NSString *state, HIUser *user) {
        if([state compare:@"success"] == NSOrderedSame) {
            self.userInfoName.text = user.name;
            self.userInfoEmail.text = user.email;
            //NSLog(@"%@", user);
        }
    }];
    
    
}



- (UISearchBar*)searchbar {
    if(_searchbar == nil) {
        self.isSearch = NO;
        _searchbar = [[UISearchBar alloc] init];
        [_searchbar setPlaceholder:@"请输入要搜索的关键词"];
        _searchbar.showsCancelButton = true;
        _searchbar.delegate = self;
        
        [self.view addSubview:_searchbar];
        
        [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(self.view.frame.size.width);
            make.top.mas_equalTo(self.userInfoView.mas_bottom).offset(5);
        }];
        
    }
    return _searchbar;
}

- (void)leftbtnselect {
    if(self.isAS == TRUE) return;
    self.dataSource = (NSMutableArray*)[[self.dataSource reverseObjectEnumerator] allObjects];
    self.isAS = TRUE;
    [self.mytableview reloadData];
}

- (UIButton*)leftbutton {
    if(_leftbutton == nil) {
        _leftbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _leftbutton.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.2];
        [_leftbutton setTitle:@"时间升序" forState:UIControlStateNormal];
        [_leftbutton addTarget:self action:@selector(leftbtnselect) forControlEvents:UIControlEventTouchUpInside];
        [_leftbutton.layer setBorderWidth:1];
        [_leftbutton.layer setBorderColor:[UIColor grayColor].CGColor];
        [self.view addSubview:_leftbutton];
        
        [_leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(self.view.frame.size.width/3);
            make.top.equalTo(self.searchbar.mas_bottom).offset(0);
            make.left.equalTo(self.view).offset(0);
        }];
    }
    return _leftbutton;
}

- (void)midbtnselect {
    if(self.isAS == FALSE) return;
    self.dataSource = (NSMutableArray*)[[self.dataSource reverseObjectEnumerator] allObjects];
    self.isAS = FALSE;
    [self.mytableview reloadData];
}

- (UIButton*)midbutton {
    if(_midbutton == nil) {
        _midbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _midbutton.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.2];
        [_midbutton setTitle:@"时间降序" forState:UIControlStateNormal];
        [_midbutton addTarget:self action:@selector(midbtnselect) forControlEvents:UIControlEventTouchUpInside];
        [_midbutton.layer setBorderWidth:1];
        [_midbutton.layer setBorderColor:[UIColor grayColor].CGColor];
        [self.view addSubview:_midbutton];
        
        [_midbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(self.view.frame.size.width/3);
            make.top.equalTo(self.searchbar.mas_bottom).offset(0);
            make.left.equalTo(self.leftbutton.mas_right).offset(0);
        }];
    }
    return _midbutton;
}

- (void)rightbtnselect:(UIButton*) sender {
    NSString *curtext = sender.titleLabel.text;
    if([curtext compare:@"TEXT"] == NSOrderedSame) {
        [sender setTitle:@"ALBUM" forState:UIControlStateNormal];
        [self getUserAlbumContent];
        [self.mytableview reloadData];
    } else {
        [sender setTitle:@"TEXT" forState:UIControlStateNormal];
        [self getUserContent];
        [self.mytableview reloadData];
    }
}

- (UIButton*)rightbutton {
    if(_rightbutton == nil) {
        _rightbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rightbutton.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.2];
        [_rightbutton setTitle:@"TEXT" forState:UIControlStateNormal];
        [_rightbutton addTarget:self action:@selector(rightbtnselect:) forControlEvents:UIControlEventTouchUpInside];
        [_rightbutton.layer setBorderWidth:1];
        [_rightbutton.layer setBorderColor:[UIColor grayColor].CGColor];
        [self.view addSubview:_rightbutton];
        
        [_rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(self.view.frame.size.width/3);
            make.top.equalTo(self.searchbar.mas_bottom).offset(0);
            make.left.equalTo(self.midbutton.mas_right).offset(0);
        }];
    }
    return _rightbutton;
}

- (UITableView*)mytableview {
    if(_mytableview == nil) {
        _mytableview = [[UITableView alloc] init];
        _mytableview.delegate = self;
        _mytableview.dataSource = self;
        
        [_mytableview  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_mytableview];
        [_mytableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.frame.size.width);
            make.top.equalTo(self.leftbutton.mas_bottom).offset(0);
            make.left.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    return _mytableview;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearch = NO;
    [self.searchbar setText:@""];
    [self getUserContent];
    [self.mytableview reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(self.isSearch == NO) {
        self.searchtmpdataSource = [self.dataSource mutableCopy];
    }
    self.dataSource = [self.searchtmpdataSource mutableCopy];
    [self myfilter:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self myfilter:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)myfilter:(NSString*)str {
    self.isSearch = YES;
    
    NSMutableArray *ret = [NSMutableArray array];
    
    for(NSInteger i=0; i<self.dataSource.count; i++) {
        HIContent *p = [self.dataSource objectAtIndex:i];
        if([p.title containsString:str]) {
            [ret addObject:[self.dataSource objectAtIndex:i]];
        }else if([p.detail containsString:str]) {
            [ret addObject:[self.dataSource objectAtIndex:i]];
        }
    }
    self.dataSource = ret;
    
    [self.mytableview reloadData];
}

- (void)clickcomment:(UIButton*) sender {
    HIContent *tmpContent = (HIContent*)[self.dataSource objectAtIndex:sender.tag];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"评论" message:@"请输入评论" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入评论";
    }];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alertController.textFields.firstObject;
            
            [HIService getDetailedContentWithContentID:tmpContent.cnid Callback:^(NSString * state, HIContent * content) {
                [HIService addCommentWithContent:content Detail:tf.text Callback:^(NSString * state) {
                    if([state compare:@"success"] == NSOrderedSame) {
                        [HIService getDetailedContentWithContentID:tmpContent.cnid Callback:^(NSString * state, HIContent * content) {
                            NSUInteger commentnum = content.commentNum;
                            NSString *tmpcommentnum = [NSString stringWithFormat:@"%lu", commentnum];
                            NSString *showCommentText = [@"评论 - " stringByAppendingString:tmpcommentnum];
                            [sender setTitle:showCommentText forState:UIControlStateNormal];
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

- (void)clicklike:(UIButton*) sender {
    HIContent *tmpContent = (HIContent*)[self.dataSource objectAtIndex:sender.tag];
    
    [HIService likeContentWithID:tmpContent.cnid Callback:^(NSString * state) {
        if([state compare:@"success"] == NSOrderedSame) {
            [HIService getDetailedContentWithContentID:tmpContent.cnid Callback:^(NSString * state, HIContent * content) {
                NSUInteger likenum = content.likeNum;
                NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
                [sender setTitle:showLikeText forState:UIControlStateNormal];
            }];
        } else {
            /*
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点赞失败" message:@"不能重复点赞哦" preferredStyle:UIAlertControllerStyleAlert];

            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
            }]];
                
            [self presentViewController:alertController animated:true completion:nil];
             */
            [HIService dislikeContentWithID:tmpContent.cnid Callback:^(NSString *state) {
                [HIService getDetailedContentWithContentID:tmpContent.cnid Callback:^(NSString * state, HIContent * content) {
                    NSUInteger likenum = content.likeNum;
                    NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
                    NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
                    [sender setTitle:showLikeText forState:UIControlStateNormal];
                }];
            }];
        }
    }];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
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
    return 200;
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
    testView.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.3];
    testView.layer.cornerRadius = 20;
    testView.layer.masksToBounds = YES;
    testView.layer.borderColor = [UIColor grayColor].CGColor;
    testView.layer.borderWidth = 1;
    [cell.contentView addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cell.contentView.frame.size.height-20);
        make.width.mas_equalTo(cell.contentView.frame.size.width-20);
        make.top.mas_equalTo(cell.mas_top).offset(10);
        make.left.mas_equalTo(cell.mas_left).offset(10);
    }];

    HIContent *tmpContent = (HIContent*)[self.dataSource objectAtIndex:indexPath.section];
    
    // 标题
    UILabel *tmptitle = [[UILabel alloc] init];
    [tmptitle setText:tmpContent.title];
    tmptitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    [testView addSubview:tmptitle];
    [tmptitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cell.contentView.frame.size.height/5);
        make.width.mas_equalTo(cell.contentView.frame.size.width-180);
        make.top.mas_equalTo(cell.contentView.mas_top).offset(20);
        make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
    }];
    
    /*
    // 发布者, 自己的内容username貌似为空，那就不显示好了
    UILabel *tmpUser = [[UILabel alloc] init];
    [tmpUser setText:tmpContent.userName];
    tmpUser.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [testView addSubview:tmpUser];
    [tmpUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cell.contentView.frame.size.height/5);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(cell.contentView.mas_top).offset(20);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
    }];
    */
    
    // 内容
    UILabel *tmpdetail = [[UILabel alloc] init];
    [tmpdetail setText:tmpContent.detail];
    tmpdetail.lineBreakMode = NSLineBreakByWordWrapping;
    tmpdetail.numberOfLines = 0;
    [tmpdetail sizeToFit];
    [testView addSubview:tmpdetail];
    [tmpdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cell.contentView.frame.size.height/4);
        make.width.mas_equalTo(cell.contentView.frame.size.width-40);
        make.top.mas_equalTo(tmptitle.mas_bottom).offset(10);
        make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
    }];
    
    // 评论按钮
    UIButton *tmpcomment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tmpcomment.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.6];
    NSUInteger commentnum = tmpContent.commentNum;
    NSString *tmpcommentnum = [NSString stringWithFormat:@"%lu", commentnum];
    NSString *showCommentText = [@"评论 : " stringByAppendingString:tmpcommentnum];
    [tmpcomment setTitle:showCommentText forState:UIControlStateNormal];
    tmpcomment.layer.borderWidth = 1;
    tmpcomment.layer.borderColor = [UIColor grayColor].CGColor;
    
    tmpcomment.tag = indexPath.section;
    [tmpcomment addTarget:self action:@selector(clickcomment:) forControlEvents:UIControlEventTouchUpInside];
    
    [testView addSubview:tmpcomment];
    
    [tmpcomment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((cell.contentView.frame.size.width-20)/2);
        make.height.mas_equalTo(cell.contentView.frame.size.height/5);
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        make.left.equalTo(cell.contentView.mas_left).offset(10);
    }];
    
    // 点赞按钮
    UIButton *tmplike = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tmplike.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.6];
    NSUInteger likenum = tmpContent.likeNum;
    NSString *tmplikenum = [NSString stringWithFormat:@"%lu", likenum];
    NSString *showLikeText = [@"点赞 : " stringByAppendingString:tmplikenum];
    [tmplike setTitle:showLikeText forState:UIControlStateNormal];
    tmplike.layer.borderWidth = 1;
    tmplike.layer.borderColor = [UIColor grayColor].CGColor;
    
    tmplike.tag = indexPath.section;
    [tmplike addTarget:self action:@selector(clicklike:) forControlEvents:UIControlEventTouchUpInside];
    
    [testView addSubview:tmplike];
    
    [tmplike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((cell.contentView.frame.size.width-20)/2);
        make.height.mas_equalTo(cell.contentView.frame.size.height/5);
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
    }];
    
    NSArray *tags = [NSArray array];
    tags = tmpContent.tags;
    if(tags.count > 0) {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        lb.text = [tags objectAtIndex:0];
        [lb setBackgroundColor:[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.4]];
        [testView addSubview:lb];
        
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(tmplike.mas_top).offset(-10);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
        }];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HIContent *tmpContent = (HIContent*)[self.dataSource objectAtIndex:indexPath.section];
    VCDetail *detail = [[VCDetail alloc] initWithContentID:tmpContent.cnid];
    [detail.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
