//
//  LoadingTableViewCell.m
//  G23
//
//  Created by student12 on 2020/11/28.
//

#import "LoadingTableViewCell.h"

@interface LoadingTableViewCell()

@property(nonatomic, strong) UILabel *tipsLabel;
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation LoadingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.tipsLabel];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:self.indicatorView];
        
        [self updateData];
    }
    
    return self;
}

- (void)layoutSubviews {
    [self.tipsLabel sizeToFit];
    
    if (LoadingStatusDefault == _status) {
        self.tipsLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    } else if (LoadingStatusLoding == _status) {
        CGFloat indicatorWidth = self.indicatorView.frame.size.width;
        CGFloat labelWidth = self.tipsLabel.frame.size.width;
        CGFloat space = 5;
        CGFloat leftMargin = (self.bounds.size.width - indicatorWidth - space - labelWidth)/2;
        self.indicatorView.center = CGPointMake(leftMargin + indicatorWidth/2, self.bounds.size.height/2);
        self.tipsLabel.center = CGPointMake(leftMargin + indicatorWidth + space + labelWidth/2, self.bounds.size.height/2);
    } else if (LoadingStatusNoMore == _status) {
        self.tipsLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
}

- (void)setStatus:(LoadingStatus)status {
    if (_status == status) {
        return;
    }
    
    _status = status;
    [self updateData];
    
    [self setNeedsLayout];
}

- (void)updateData {
    if (LoadingStatusDefault == _status) {
        self.tipsLabel.text = @"点击加载更多";
        [self.indicatorView stopAnimating];
    } else if (LoadingStatusLoding == _status) {
        self.tipsLabel.text = @"正在加载...";
        [self.indicatorView startAnimating];
    } else if (LoadingStatusNoMore == _status) {
        self.tipsLabel.text = @"数据加载完成";
        [self.indicatorView stopAnimating];
    }
}


@end

