//
//  VCHome.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "VCHome.h"
#import "VCDetail.h"
#import "VCPost.h"
#import "Masonry.h"
#import "HIService.h"

@interface VCHome ()

@property (nonatomic, assign) BOOL isAS;
@property (nonatomic, assign) BOOL isSearch; // 是否正在快速搜索内容
@property (nonatomic, strong) UISearchBar *searchbar; // 快速搜索内容：搜索关键词
@property (nonatomic, strong) UIButton *leftbutton; // 搜索框下第一个按钮
@property (nonatomic, strong) UIButton *midbutton;  // 搜索框下第二个按钮
@property (nonatomic, strong) UIButton *rightbutton; // 搜索框下第三个按钮
@property (nonatomic, strong) UITableView *mytableview;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *addContentbtn;
@property (nonatomic, strong) NSMutableArray *searchtmpdataSource;

@end


@implementation VCHome

- (void)viewDidAppear:(BOOL)animated{
    NSString *curtext = self.rightbutton.titleLabel.text;
    if([curtext compare:@"TEXT"] == NSOrderedSame) {
        [self getMyContents];
    } else {
        [self getMyAlbumContents];
    }
    [self.mytableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    [self.navigationController viewWillAppear:YES];
    self.navigationItem.title = @"个人主页";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray arrayWithArray:@[]];
    self.searchtmpdataSource = [NSMutableArray arrayWithArray:@[]];
    self.isAS = FALSE;
    
    [self searchbar];
    [self leftbutton];
    [self midbutton];
    [self rightbutton];
    [self mytableview];
    [self addContentbtn];

    [self getMyContents];
}



// 下拉刷新
- (void)setupRefresh {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    [self.mytableview addSubview:refreshControl];
    [refreshControl beginRefreshing];
    [self refreshClick:refreshControl];
}
// 下拉刷新触发，在此获取数据
- (void)refreshClick:(UIRefreshControl *)refreshControl {
    NSString *curtext = self.rightbutton.titleLabel.text;
    if([curtext compare:@"TEXT"] == NSOrderedSame) {
        [self getMyContents];
    } else {
        [self getMyAlbumContents];
    }
    [refreshControl endRefreshing];
    [self.mytableview reloadData];// 刷新tableView即可
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
            make.top.mas_equalTo(self.view).offset(0);
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
        // 显示text类型
        [self getMyAlbumContents];
        [self.mytableview reloadData];
    } else {
        [sender setTitle:@"TEXT" forState:UIControlStateNormal];
        // 显示album类型
        [self getMyContents];
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


- (void)addContent {
    VCPost *addCon = [VCPost new];
    [addCon.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:addCon animated:YES];
}

- (UIButton*)addContentbtn {
    if(_addContentbtn == nil) {
        _addContentbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_addContentbtn setTitle:@"+" forState:UIControlStateNormal];
        [_addContentbtn setBackgroundColor:[UIColor whiteColor]];
        [_addContentbtn addTarget:self action:@selector(addContent) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_addContentbtn];
        
        [_addContentbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
            make.bottom.equalTo(self.view).offset(-20);
            make.right.equalTo(self.view).offset(-20);
        }];
        
        _addContentbtn.layer.cornerRadius = 20;
        _addContentbtn.clipsToBounds = YES;
        
        _addContentbtn.layer.borderColor = [UIColor grayColor].CGColor;
        _addContentbtn.layer.borderWidth = 0.8;
    }
    return _addContentbtn;
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


- (void)getMyContents {
    [HIService getMyContentsWithCallback:^(NSString * state, NSArray * contents) {
        [self.dataSource removeAllObjects];
        for (HIContent * content in contents) {
            [self.dataSource addObject:content];
        }
        [self.mytableview reloadData];
    }];
}

- (void)getMyAlbumContents {
    [HIService getMyAlbumsWithCallback: ^(NSString * state, NSArray * contents) {
        [self.dataSource removeAllObjects];
        for (HIContent * content in contents) {
            [self.dataSource addObject:content];
        }
        [self.mytableview reloadData];
    }];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearch = NO;
    [self.searchbar setText:@""];
    NSString *curtext = self.rightbutton.titleLabel.text;
    if([curtext compare:@"TEXT"] == NSOrderedSame) {
        [self getMyContents];
    } else {
        [self getMyAlbumContents];
    }
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
        if ([p.title containsString:str]) {
            [ret addObject:[self.dataSource objectAtIndex:i]];
        } else if([p.detail containsString:str]) {
            [ret addObject:[self.dataSource objectAtIndex:i]];
        } else if([p.userName containsString:str]) {
            [ret addObject:[self.dataSource objectAtIndex:i]];
        } else {
            NSArray *tags = [NSArray array];
            tags = p.tags;
            for(NSString * tag in tags) {
                if([tag containsString:str]) {
                    [ret addObject:[self.dataSource objectAtIndex:i]];
                    break;
                }
            }
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
