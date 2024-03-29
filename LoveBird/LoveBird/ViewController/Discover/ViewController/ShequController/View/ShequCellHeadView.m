//
//  ShequCellHeadView.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/14.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "ShequCellHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ShequCellHeadView()

@property (nonatomic, strong) UIImageView *headIcon;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UILabel *gradeLabel;

// 关注按钮
@property (nonatomic, strong) UIButton *followButton;

@end

@implementation ShequCellHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 头像
        self.headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(AutoSize6(30), AutoSize6(0), AutoSize6(65), AutoSize6(65))];
        self.headIcon.contentMode = UIViewContentModeScaleToFill;
        self.headIcon.clipsToBounds = YES;
        self.headIcon.layer.cornerRadius = self.headIcon.width / 2;
        self.headIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        self.headIcon.layer.borderWidth = AutoSize6(2);
        [self addSubview:self.headIcon];
        
        self.headIcon.userInteractionEnabled = YES;
        [self.headIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headIconDidClick)]];
        
        // 昵称
        self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headIcon.right + AutoSize(5), self.headIcon.top, SCREEN_WIDTH / 2, self.headIcon.height)];
        self.nickNameLabel.textColor = [UIColor blackColor];
        self.nickNameLabel.centerY -= AutoSize6(3);
        self.nickNameLabel.font = kFontPF6(28);
        self.nickNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nickNameLabel];
        
        self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nickNameLabel.right + AutoSize(5), self.headIcon.top, AutoSize6(54), AutoSize6(26))];
        self.gradeLabel.centerY = self.nickNameLabel.centerY;
        self.gradeLabel.textColor = [UIColor whiteColor];
        self.gradeLabel.backgroundColor = kColorDefaultColor;
        self.gradeLabel.font = kFont6(18);
        self.gradeLabel.textAlignment = NSTextAlignmentCenter;
        self.gradeLabel.layer.masksToBounds = YES;
        [self addSubview:self.gradeLabel];
        
        // 关注
        self.followButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - AutoSize6(130), self.headIcon.top, AutoSize6(100), self.headIcon.height)];
        self.followButton.centerY = self.nickNameLabel.centerY - AutoSize6(2);
        self.followButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.followButton setTitle:@"已关注" forState:UIControlStateSelected];
        self.followButton.titleLabel.font = kFontPF6(28);
        [self.followButton setTitleColor:UIColorFromRGB(0x7faf41) forState:UIControlStateNormal];
        [self.followButton setTitleColor:UIColorFromRGB(0xa2a2a2) forState:UIControlStateSelected];
        [self.followButton addTarget:self action:@selector(followButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.followButton];
        self.followButton.tag = 500;
    }
    return self;
}

- (void)followButtonDidClick:(UIButton *)button {
    
    [UserDao userFollow:self.shequModel.authorid successBlock:^(__kindof AppBaseModel *responseObject) {
        button.selected = !button.selected;
    } failureBlock:^(__kindof AppBaseModel *error) {
        [AppBaseHud showHudWithfail:error.errstr view:[UIViewController currentViewController].view];
    }];
}

- (void)setShequModel:(ShequModel *)shequModel {
    _shequModel = shequModel;
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:shequModel.head] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.nickNameLabel.text = shequModel.author;
    
    CGFloat width = [shequModel.author getTextWightWithFont:self.nickNameLabel.font];
    self.nickNameLabel.width = width + AutoSize6(10);
    
    NSString *grade = @"0";
    if (shequModel.authorlv.length) {
        grade = shequModel.authorlv;
    }
    self.gradeLabel.text = [NSString stringWithFormat:@"Lv.%@", grade];
    
    CGFloat gradewidth = [self.gradeLabel.text getTextWightWithFont:self.gradeLabel.font];
    self.gradeLabel.width = gradewidth + AutoSize6(20);

    self.gradeLabel.left = self.nickNameLabel.right;
    self.followButton.selected = shequModel.is_follow;
    self.gradeLabel.layer.cornerRadius = 3;

}

- (void)headIconDidClick {
    
    if ([self.shequModel.authorid isEqualToString:[UserPage sharedInstance].uid]) {
        
        ((UITabBarController *)(kTabBarController)).selectedIndex = 4;
        
        [[UIViewController currentViewController].navigationController popToRootViewControllerAnimated:NO];
        return;
    }
    
    UserInfoViewController *uservc = [[UserInfoViewController alloc] init];
    uservc.uid = self.shequModel.authorid;
    uservc.userName = self.shequModel.author;
    [[UIViewController currentViewController].navigationController pushViewController:uservc animated:YES];
}

@end
