//
//  VCEdit.m
//  G23
//
//  Created by student12 on 2020/11/30.
//

#import "VCEdit.h"
#import "Masonry.h"
#import "HIService.h"
#import "XLBallLoading.h"

@interface VCEdit ()

@property (nonatomic, strong) NSString *contentID; 

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *fabuButton;
@property (nonatomic, strong) UITextField *titletextfield;
@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) UICollectionView *collect;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableArray *imagearray;

@property (nonatomic, strong) UICollectionView *tagcollect;
@property (nonatomic, strong) NSMutableArray *tagarray;

@end

@implementation VCEdit

- (void)setCID:(NSString*)s {
    self.contentID = s;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改动态";
    self.imagearray = [NSMutableArray array];
    self.tagarray = [NSMutableArray array];
    
    [self backView];
    [self titleView];
    [self contentView];
    [self fabuButton];
    [self collect];
    [self tagcollect];
}

- (UICollectionView*)tagcollect {
    if(_tagcollect == nil) {
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(50, 20);
        //创建collectionView 通过一个布局策略layout来创建
        _tagcollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 180, 130) collectionViewLayout:layout];
        _tagcollect.backgroundColor = [UIColor clearColor];
        //代理设置
        _tagcollect.delegate=self;
        _tagcollect.dataSource=self;
        //注册item类型 这里使用系统的类型
        [_tagcollect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid-tag"];
        
        [self.view addSubview:_tagcollect];
        
        [_tagcollect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(250);
            make.bottom.mas_equalTo(self.fabuButton.mas_top).offset(-20);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = @"标签 : ";
        [self.view addSubview:lb];
        
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(50);
            make.top.equalTo(_tagcollect.mas_top).offset(-10);
            make.right.equalTo(_tagcollect.mas_left).offset(-5);
        }];
    }
    return _tagcollect;
}

- (UICollectionView*)collect {
    if(_collect == nil) {
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(52, 52);
        //创建collectionView 通过一个布局策略layout来创建
        _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(80, 5, 180, 130) collectionViewLayout:layout];
        _collect.backgroundColor = [UIColor clearColor];
        //代理设置
        _collect.delegate=self;
        _collect.dataSource=self;
        //注册item类型 这里使用系统的类型
        [_collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        
        [self.view addSubview:_collect];
        
        [_collect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(130);
            make.width.mas_equalTo(180);
            make.top.equalTo(_contentView.mas_bottom).offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = @"照片 : ";
        [self.view addSubview:lb];
        
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(80);
            make.top.equalTo(_collect.mas_top).offset(0);
            make.right.equalTo(_collect.mas_left).offset(-10);
        }];
    }
    return _collect;
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

- (UIView*)titleView {
    if(_titleView == nil) {
        _titleView = [[UIView alloc]init];
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.text = @"标题 : ";
        _titletextfield = [[UITextField alloc] init];
        _titletextfield.layer.borderWidth =1;
        _titletextfield.layer.borderColor = [UIColor grayColor].CGColor;
        
        [_titleView addSubview:titlelabel];
        [_titleView addSubview:_titletextfield];
        [self.view addSubview:_titleView];
        
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(self.view.frame.size.width-40);
            make.top.equalTo(self.view).offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(80);
            make.top.equalTo(_titleView.mas_top).offset(0);
            make.left.equalTo(_titleView.mas_left).offset(10);
        }];
        
        [_titletextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(200);
            make.top.equalTo(_titleView.mas_top).offset(10);
            make.left.equalTo(titlelabel.mas_right).offset(0);
        }];
        
        _titletextfield.borderStyle = UITextBorderStyleRoundedRect;
        _titletextfield.layer.cornerRadius = 10;
        _titletextfield.layer.masksToBounds = YES;
    }
    return _titleView;
}

- (UIView*)contentView {
    if(_contentView == nil) {
        _contentView = [[UIView alloc]init];
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"内容 : ";
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.layer.borderWidth =1;
        _contentTextView.layer.borderColor = [UIColor grayColor].CGColor;
        
        [_contentView addSubview:contentLabel];
        [_contentView addSubview:_contentTextView];
        [self.view addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(300);
            make.width.mas_equalTo(self.view.frame.size.width-40);
            make.top.equalTo(_titleView.mas_bottom).offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(80);
            make.top.equalTo(_contentView.mas_top).offset(0);
            make.left.equalTo(_contentView.mas_left).offset(10);
        }];
        
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(280);
            make.right.equalTo(_contentView.mas_right).offset(-10);
            make.top.equalTo(_contentView.mas_top).offset(10);
            make.left.equalTo(contentLabel.mas_right).offset(0);
        }];
        
        _contentTextView.layer.cornerRadius = 10;
        _contentTextView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (void)fabu {
    NSString *t = self.titletextfield.text;
    NSString *c = self.contentTextView.text;
    
    [XLBallLoading showInView:self.view];
    
    [HIService updateContentWithID:self.contentID Title:t Detail:c Tags:self.tagarray Callback:^(NSString *state) {
        if([state compare:@"success"] == NSOrderedSame) {
            self.titletextfield.text = @"";
            self.contentTextView.text = @"";

            [XLBallLoading hideInView:self.view];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];

            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
                
            [XLBallLoading hideInView:self.view];
            
            [self presentViewController:alertController animated:true completion:nil];
        }
    }];
}

- (UIButton*)fabuButton {
    if(_fabuButton == nil) {
        _fabuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_fabuButton setTitle:@"提交修改" forState:UIControlStateNormal];
        [_fabuButton setBackgroundColor:[UIColor whiteColor]];
        [_fabuButton addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];
        _fabuButton.layer.borderWidth = 1;
        _fabuButton.layer.borderColor = [UIColor grayColor].CGColor;
        [self.view addSubview:_fabuButton];
        [_fabuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(120);
            make.bottom.equalTo(self.view).offset(-15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        _fabuButton.layer.cornerRadius = 10;
        _fabuButton.layer.masksToBounds = YES;
    }
    return _fabuButton;
}

- (UIImageView*)imageView {
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
        _imageView.image = [UIImage imageNamed:@"jiahao"];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
        [_imageView addGestureRecognizer:clickTap];
    }
    return _imageView;
}

-(void)chooseImage {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
        
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            }
    }];
        
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
        
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //NSLog(@"点击了取消");
    }];
        
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
        
    [self presentViewController:actionSheet animated:YES completion:nil];
}

//获取选择的图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imagearray addObject:image];
    
    if(self.imagearray.count > 5) {
        [self.imagearray removeObjectAtIndex:0];
    }
    
    [self.collect reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

//从相机或者相册界面弹出
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionView

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if([collectionView isEqual:self.collect]) {
        return _imagearray.count+1;
    } else {
        return _tagarray.count+1;
    }
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if([collectionView isEqual:self.collect]) {
        UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        for(UIView* sv in [cell.contentView subviews]) {
            if ([sv isKindOfClass:[UIImageView class]]) {
                [sv removeFromSuperview];
            }
        }
        
        if(indexPath.item < _imagearray.count) {
            UIImageView* mv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
            mv.image = [self.imagearray objectAtIndex:indexPath.item];
            [cell.contentView addSubview:mv];
        } else {
            [cell.contentView addSubview:self.imageView];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } else {
        UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid-tag" forIndexPath:indexPath];
        
        for(UIView* sv in [cell.contentView subviews]) {
            [sv removeFromSuperview];
        }
        
        if(indexPath.item < _tagarray.count) {
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
            lb.text = [self.tagarray objectAtIndex:indexPath.item];
            [lb setBackgroundColor:[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:0.4]];
            [cell.contentView addSubview:lb];
        } else {
            UIImageView *mv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            mv.layer.cornerRadius = 10;
            mv.layer.masksToBounds = YES;
            mv.image = [UIImage imageNamed:@"jiahao"];
            mv.userInteractionEnabled = YES;
            mv.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1];
            UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTag)];
            [mv addGestureRecognizer:clickTap];
            [cell.contentView addSubview:mv];
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionView isEqual:self.collect]) {
        if(indexPath.item < _imagearray.count) {
            [self.imagearray removeObjectAtIndex:indexPath.item];
            [self.collect reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    } else {
        if(indexPath.item < _tagarray.count) {
            [self.tagarray removeObjectAtIndex:indexPath.item];
            [self.tagcollect reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    }
}

- (void)addTag {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标签" message:@"请输入Tag" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"tag";
    }];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alertController.textFields.firstObject;
            
            [self.tagarray addObject:tf.text];
        
            if(self.tagarray.count > 3) {
                [self.tagarray removeObjectAtIndex:0];
            }
        
            [self.tagcollect reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }]];
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    [self presentViewController:alertController animated:true completion:nil];
}

@end
