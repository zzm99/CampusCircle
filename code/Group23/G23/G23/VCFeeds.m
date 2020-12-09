//
//  VCFeeds.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "VCFeeds.h"
#import "Masonry.h"
#import "VCDetail.h"
#import "HIService.h"
#import "LoadingTableViewCell.h"


@interface VCFeeds ()

@property (nonatomic, assign) BOOL isAS;
@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, assign) BOOL isSearch; // 是否正在快速搜索内容
@property (nonatomic, strong) UISearchBar *searchbar; // 快速搜索内容：搜索关键词
@property (nonatomic, strong) UIButton *leftbutton; // 搜索框下第一个按钮
@property (nonatomic, strong) UIButton *midbutton;  // 搜索框下第二个按钮
@property (nonatomic, strong) UIButton *rightbutton; // 搜索框下第三个按钮
@property (nonatomic, strong) UITableView *mytableview; // 查看某个用户的不同分类的全部内容，若是本人账户，则提供增删改功能
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isREMEN;
@property (nonatomic, strong) NSMutableArray *tmpdataSource;
@property (nonatomic, assign) LoadingStatus status;
@property (nonatomic, strong) NSMutableArray *searchtmpdataSource;
@property (nonatomic, assign) NSInteger sectionid;

@end

@implementation VCFeeds

- (void)getSecContent {
    self.nextPage = 1;
    self.isAS = FALSE;
    self.isREMEN = FALSE;
    self.isSearch = NO;
    [self.dataSource removeAllObjects];
    
    [HIService getAllContentsWithPage:self.nextPage EachPage:self.sectionid+4 Callback:^(NSString *state, NSArray *contents) {
        if(contents.count == 0) {
            return;
        }

        for (HIContent * content in contents) {
            [self.dataSource addObject:content];
        }
        
        self.nextPage += 1;
        
        [self.mytableview reloadData];
        
        NSIndexPath *pp = [NSIndexPath indexPathForRow:0 inSection:self.sectionid];
        [self.mytableview scrollToRowAtIndexPath:pp atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [self getSecContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    [self getNewContent];
    [self.navigationController viewWillAppear:YES];
    self.sectionid = 0;
    self.navigationItem.title = @"广场";
    self.view.backgroundColor = [UIColor whiteColor];
    self.nextPage = 1;
    self.dataSource = [NSMutableArray arrayWithArray:@[]];
    self.tmpdataSource = [NSMutableArray arrayWithArray:@[]];
    self.searchtmpdataSource = [NSMutableArray arrayWithArray:@[]];
    self.isAS = FALSE;
    self.isREMEN = FALSE;
    
    [self searchbar];
    [self leftbutton];
    [self midbutton];
    [self rightbutton];
    [self mytableview];
    
    [self.mytableview reloadData];
}

- (void)getContents {
    if(self.isAS == TRUE) {
        self.dataSource = (NSMutableArray*)[[self.dataSource reverseObjectEnumerator] allObjects];
        self.isAS = FALSE;
    }
    if(self.isREMEN == TRUE) {
        self.dataSource = [self.tmpdataSource mutableCopy];
        self.isREMEN = FALSE;
    }
    [HIService getAllContentsWithPage:self.nextPage EachPage:10 Callback:^(NSString *state, NSArray *contents) {
        if(contents.count == 0) {
            return;
        }

        for (HIContent * content in contents) {
            [self.dataSource addObject:content];
        }
        
        self.nextPage += 1;
        
        [self.mytableview reloadData];
    }];
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
    [self getNewContent];
    [refreshControl endRefreshing];
    [self.mytableview reloadData];// 刷新tableView即可
}

- (void)getNewContent {
    self.nextPage = 1;
    self.isAS = FALSE;
    self.isREMEN = FALSE;
    self.isSearch = NO;
    [self.dataSource removeAllObjects];
    [self getContents];
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
    if(self.isSearch == YES) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"啊啊啊啊" message:@"先把搜索Cancel吧" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
        }]];
            
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
    if(self.isREMEN == TRUE) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"啊啊啊啊" message:@"再按一次热门恢复原来的样子先吧" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
        }]];
            
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
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
    if(self.isSearch == YES) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"啊啊啊啊" message:@"先把搜索Cancel吧" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
        }]];
            
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
    if(self.isREMEN == TRUE) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"啊啊啊啊" message:@"再按一次热门恢复原来的样子先吧" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
        }]];
            
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
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

- (void)rightbtnselect {
    if(self.isSearch == YES) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"啊啊啊啊" message:@"先把搜索Cancel吧" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
        }]];
            
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
    if(self.isAS == TRUE) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"啊啊啊啊" message:@"把排序变回降序好么" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
        }]];
            
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
    if(self.isREMEN == TRUE) {
        self.dataSource = [self.tmpdataSource mutableCopy];
        self.isREMEN = FALSE;
        [self.mytableview reloadData];
        return;
    }
    self.tmpdataSource = [self.dataSource mutableCopy];
    NSArray *sortedArray = [(NSArray*)self.dataSource sortedArrayUsingComparator:^NSComparisonResult(id a, id b)  {
        NSUInteger n1 = [(HIContent*)a likeNum];
        NSUInteger n2 = [(HIContent*)b likeNum];
        if(n1 < n2) {
            return NSOrderedDescending;
        } else if (n1 > n2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    self.isREMEN = TRUE;
    self.dataSource = [sortedArray mutableCopy];
    [self.mytableview reloadData];
}

- (UIButton*)rightbutton {
    if(_rightbutton == nil) {
        _rightbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rightbutton.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.2];
        [_rightbutton setTitle:@"热门" forState:UIControlStateNormal];
        [_rightbutton addTarget:self action:@selector(rightbtnselect) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self getNewContent];
    
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
        }else if([p.userName containsString:str]) {
            [ret addObject:[self.dataSource objectAtIndex:i]];
        }else {
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
                    [HIService getDetailedContentWithContentID:tmpContent.cnid Callback:^(NSString * state, HIContent * content) {
                        NSUInteger commentnum = content.commentNum;
                        NSString *tmpcommentnum = [NSString stringWithFormat:@"%lu", commentnum];
                        NSString *showCommentText = [@"评论 : " stringByAppendingString:tmpcommentnum];
                        [sender setTitle:showCommentText forState:UIControlStateNormal];
                    }];
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
    return _dataSource.count+1;
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
    if(indexPath.section == _dataSource.count) {
        return 50;
    }
    return 200;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isLodingCell = (indexPath.section == self.dataSource.count);
    NSString *identifer = [NSString stringWithFormat:@"cellID:%d", isLodingCell];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell==nil) {
        if (isLodingCell) {
            cell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            ((LoadingTableViewCell*)cell).status = self.status;
            cell.selectionStyle = ((self.status == LoadingStatusDefault) ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone);
        } else {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
    } else {
        if(!isLodingCell) {
            for(UIView* sv in [cell.contentView subviews]) {
                [sv removeFromSuperview];
            }
        }
    }
    
    if (isLodingCell) {
        ((LoadingTableViewCell*)cell).status = self.status;
        cell.selectionStyle = ((self.status == LoadingStatusDefault) ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone);
    } else {
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
        
        // 发布者
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
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLodingCell = (indexPath.section == self.dataSource.count);
    if (isLodingCell) {
        self.status = LoadingStatusLoding;
        
        [tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.status = LoadingStatusDefault;
            [self getContents];
        });
    } else {
        self.sectionid = indexPath.section;
        HIContent *tmpContent = (HIContent*)[self.dataSource objectAtIndex:indexPath.section];
        VCDetail *detail = [[VCDetail alloc] initWithContentID:tmpContent.cnid];
        [detail.view setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController pushViewController:detail animated:YES];
    }
}


@end
