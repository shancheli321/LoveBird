//
//  MineBirdRightCell.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/26.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "MineBirdRightCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MineBirdLeftBackView.h"

#define kWidthForBackView (SCREEN_WIDTH / 2 - AutoSize6(35))


@interface MineBirdRightCell()

@property (nonatomic, strong) MineBirdLeftBackView *backView;

// 标题
@property (nonatomic, strong) UILabel *titleLable;

// 内容图片
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *timeLabel;


@end
@implementation MineBirdRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
//        self.backView = [self makeBackView];
        self.backView = [[MineBirdLeftBackView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + AutoSize6(5), AutoSize6(44), kWidthForBackView, AutoSize6(84))];
        self.backView.isLeft = NO;
        [self.contentView addSubview:self.backView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - AutoSize6(40) - AutoSize6(74) - AutoSize6(5), AutoSize6(5), AutoSize6(74), AutoSize6(74))];
        self.iconImageView.layer.cornerRadius = self.iconImageView.width / 2;
        self.iconImageView.contentMode = UIViewContentModeCenter;
        self.iconImageView.backgroundColor = [UIColor redColor];
        [self.backView addSubview:self.iconImageView];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.backView.width - self.iconImageView.width - AutoSize6(20), AutoSize6(84))];
        self.titleLable.font = kFont6(26);
        self.titleLable.textColor = UIColorFromRGB(0x666666);
        self.titleLable.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:self.titleLable];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2 - AutoSize6(25), AutoSize6(84))];
        self.timeLabel.centerY = self.backView.centerY;
        self.timeLabel.font = kFont6(24);
        self.timeLabel.textColor = kColorTextColorLightGraya2a2a2;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 0.5, 0, 1, AutoSize6(170))];
        lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [self.contentView addSubview:lineView];
        
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AutoSize6(36), AutoSize6(36))];
        timeImageView.image = [UIImage imageNamed:@"mine_bird_time"];
        timeImageView.contentMode = UIViewContentModeCenter;
        timeImageView.centerX = SCREEN_WIDTH / 2;
        timeImageView.centerY = self.backView.centerY;
        [self.contentView addSubview:timeImageView];
    }
    return self;
}


- (void)setBirdModel:(UserBirdModel *)birdModel {
    _birdModel = birdModel;
    
    self.timeLabel.text = _birdModel.dateline;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_birdModel.birdHead] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLable.text = _birdModel.name;
}


- (UIView *)makeBackView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + AutoSize6(10), AutoSize6(44), SCREEN_WIDTH / 2 - AutoSize6(40), AutoSize6(84))];
    backView.backgroundColor = kColorViewBackground;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(AutoSize6(84), AutoSize6(84))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = backView.bounds;
    maskLayer.path = maskPath.CGPath;
    backView.layer.mask = maskLayer;
    
    
    
    return backView;
}

@end