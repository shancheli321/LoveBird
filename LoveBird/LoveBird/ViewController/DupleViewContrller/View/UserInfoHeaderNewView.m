//
//  UserInfoHeaderNewView.m
//  LoveBird
//
//  Created by cheli shan on 2018/9/14.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "UserInfoHeaderNewView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"
#import "MineFollowController.h"

@interface UserInfoHeaderNewView()

// 头像
@property (nonatomic, strong) UIImageView *iconImageView;

//昵称
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *followLabel;

@property (nonatomic, strong) UILabel *fansLabel;

@property (nonatomic, strong) UILabel *scorleLabel;

@property (nonatomic, strong) UILabel *gradeLabel;

@property (nonatomic, strong) UIButton *logButton;

@property (nonatomic, strong) UIButton *birdButton;

@property (nonatomic, strong) UIButton *friendButton;

@property (nonatomic, strong) UIView *redView;

@property (nonatomic, strong) UIButton *selectedButton;


@property (nonatomic, strong) UserModel *userModel;


@end


@implementation UserInfoHeaderNewView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(470))];
        backImageView.image = [UIImage imageNamed:@"mine_header_back"];
        backImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:backImageView];
        
        //头像
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AutoSize6(165), AutoSize6(165))];
        self.iconImageView.center = backImageView.center;
        self.iconImageView.contentMode = UIViewContentModeScaleToFill;
        self.iconImageView.layer.cornerRadius = self.iconImageView.width / 2;
        self.iconImageView.layer.borderWidth = AutoSize6(4);
        self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.iconImageView.layer.masksToBounds = YES;
        [self addSubview:self.iconImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImageView.bottom + AutoSize6(22), SCREEN_WIDTH, AutoSize6(28))];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = kFont6(30);
        [self addSubview:self.nameLabel];
        
        self.followLabel = [self makeLabel:AutoSize6(46)];
        self.followLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followLabelDidClick)];
        [self.followLabel addGestureRecognizer:tap];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.followLabel.right, self.followLabel.top, 1, self.followLabel.height)];
        line1.backgroundColor = [UIColor whiteColor];
        [self addSubview:line1];
        
        self.fansLabel = [self makeLabel:self.followLabel.right];
        self.fansLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapfans = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansLabelDidClick)];
        [self.fansLabel addGestureRecognizer:tapfans];
        
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(self.fansLabel.right, self.followLabel.top, 1, self.followLabel.height)];
        line2.backgroundColor = [UIColor whiteColor];
        [self addSubview:line2];
        
        
        self.scorleLabel = [self makeLabel:self.fansLabel.right];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(self.scorleLabel.right, self.followLabel.top, 1, self.followLabel.height)];
        line3.backgroundColor = [UIColor whiteColor];
        [self addSubview:line3];
        
        self.gradeLabel = [self makeLabel:self.scorleLabel.right];
        
//        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, backImageView.bottom, SCREEN_WIDTH, AutoSize6(142))];
//        bottomView.backgroundColor= [UIColor whiteColor];
//        [self addSubview:bottomView];
//
//        self.logButton = [self makeButton:0 image:@"mine_header_log_no" selectImage:@"mine_header_log_yes" title:@"日志" tag:100];
//        [bottomView addSubview:self.logButton];
//
//        self.birdButton = [self makeButton:self.logButton.right image:@"mine_header_bird_no" selectImage:@"mine_header_bird_yes" title:@"鸟种" tag:300];
//        [bottomView addSubview:self.birdButton];
//
//        UIButton *pictureButton = [self makeButton:self.birdButton.right image:@"mine_header_picture_no" selectImage:@"mine_header_picture_yes" title:@"相册" tag:400];
//        [bottomView addSubview:pictureButton];
//
//
//        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, bottomView.bottom - 0.5, SCREEN_WIDTH, 0.5)];
//        lineview.backgroundColor = kLineColoreDefaultd4d7dd;
//        [self addSubview:lineview];
//
//        // 进来选中日志
//        [self bottomButtonDidClick:self.logButton];
    }
    return self;
}


- (void)bottomButtonDidClick:(UIButton *)button {
    if (button.tag == self.friendButton.tag) {
        self.redView.hidden = YES;
    }
    
    if (self.selectedButton.tag == button.tag) {
        return;
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    
    
    if (self.headerBlock) {
        self.headerBlock(button.tag);
    }
}

- (void)followLabelDidClick {
    MineFollowController *followvc = [[MineFollowController alloc] init];
    followvc.type = 1;
    followvc.taid = self.userModel.uid;
    
    [[UIViewController currentViewController].navigationController pushViewController:followvc animated:YES];
}

- (void)fansLabelDidClick {
    MineFollowController *followvc = [[MineFollowController alloc] init];
    followvc.type = 2;
    followvc.taid = self.userModel.uid;
    [[UIViewController currentViewController].navigationController pushViewController:followvc animated:YES];
}

- (UILabel *)makeLabel:(CGFloat)x {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, AutoSize6(416), AutoSize6(168), AutoSize6(27))];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = kFont6(22);
    [self addSubview:label];
    
    return label;
}

- (UIButton *)makeButton:(CGFloat)x image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title tag:(NSInteger)tag {
    CGFloat width = SCREEN_WIDTH / 3;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, AutoSize6(142))];
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x7f7f7f) forState:UIControlStateNormal];
    [button setTitleColor:kColorDefaultColor forState:UIControlStateSelected];
    button.titleLabel.font = kFont6(22);
    [button addTarget:self action:@selector(bottomButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    [self reloadButton:button];
    
    return button;
}

- (void)reloadButton:(UIButton *)button {
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = AutoSize6(28);
    
    //设置按钮内边距
    imgViewSize = button.imageView.bounds.size;
    titleSize = button.titleLabel.bounds.size;
    btnSize = button.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace, 0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [button setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [button setTitleEdgeInsets:titleEdge];
}

- (void)reloadData:(UserModel *)model {
    _userModel = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.nameLabel.text = model.username;
    self.followLabel.text = [NSString stringWithFormat:@"关注 %@", model.followNum];
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝 %@", model.fansNum];
    self.scorleLabel.text = [NSString stringWithFormat:@"积分 %@", model.credit];
    self.gradeLabel.text = [NSString stringWithFormat:@"%@", model.honor];
    
    [self.logButton setTitle:[NSString stringWithFormat:@"日志 %@", model.articleNum] forState:UIControlStateNormal];
    [self reloadButton:self.logButton];
    [self.birdButton setTitle:[NSString stringWithFormat:@"鸟种 %@", model.birdspeciesNum] forState:UIControlStateNormal];
    [self reloadButton:self.birdButton];
    self.redView.hidden = (model.hasMessage) ? NO : YES;
    
}
@end
