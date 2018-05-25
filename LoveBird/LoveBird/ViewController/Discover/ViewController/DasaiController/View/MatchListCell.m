//
//  MatchListCell.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/20.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "MatchListCell.h"
#import "MatchModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MatchListCell()

@property (nonatomic, strong) UIImageView *iconImageView;


@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation MatchListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(442))];
        _iconImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_iconImageView];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconImageView.bottom, SCREEN_WIDTH, AutoSize6(115))];
        self.titleLable.font = kFont6(32);
        self.titleLable.textColor = UIColorFromRGB(0x333333);
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLable];
        
    }
    return self;
}

- (void)setModel:(AppBaseCellModel *)model {
    MatchModel *matchModel = (MatchModel *)model.userInfo;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:matchModel.imgUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLable.text = matchModel.title;
}

@end