//
//  CaogaoTableViewCell.m
//  LoveBird
//
//  Created by cheli shan on 2018/8/11.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "CaogaoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CaogaoTableViewCell ()

@property (nonatomic, strong) UIView *backView;


@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabe;

@property (nonatomic, strong) UILabel *timeLabe;

// edit
@property (nonatomic, strong) UIButton *editButton;

// 发表
@property (nonatomic, strong) UIButton *publishButton;


@end

@implementation CaogaoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(AutoSize6(20), AutoSize6(14), SCREEN_WIDTH - AutoSize6(40), AutoSize6(260))];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        self.backView = backView;
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(-AutoSize6(12), -AutoSize6(12), AutoSize6(42), AutoSize6(42))];
        [closeButton setImage:[UIImage imageNamed:@"pub_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeDidClilck) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:closeButton];
        
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(AutoSize6(30), AutoSize6(35), AutoSize6(288), AutoSize6(194))];
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconView.clipsToBounds = YES;
        [backView addSubview:self.iconView];
        
        self.titleLabe = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right + AutoSize6(20), self.iconView.top, AutoSize6(286), AutoSize6(132))];
        self.titleLabe.textColor = kColorTextColor333333;
        self.titleLabe.textAlignment = NSTextAlignmentLeft;
        self.titleLabe.font = kFont6(20);
        self.titleLabe.numberOfLines = 0;
        [backView addSubview:self.titleLabe];
        
        self.timeLabe = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right + AutoSize6(20), self.iconView.bottom + AutoSize6(40), AutoSize6(60), AutoSize6(40))];
        self.titleLabe.textColor = kColorTextColorLightGraya2a2a2;
        self.titleLabe.textAlignment = NSTextAlignmentLeft;
        self.titleLabe.font = kFont6(20);
        [backView addSubview:self.titleLabe];
        
        self.editButton = [UIFactory buttonWithFrame:CGRectMake(self.timeLabe.right, self.timeLabe.top, AutoSize6(60), self.timeLabe.height)
                                              target:self
                                               image:@""
                                         selectImage:@""
                                               title:@"编辑"
                                              action:@selector(editButtonDidClick)];
        [backView addSubview:self.editButton];
        
        self.publishButton = [UIFactory buttonWithFrame:CGRectMake(self.editButton.right, self.timeLabe.top, AutoSize6(60), self.timeLabe.height)
                                              target:self
                                               image:@""
                                         selectImage:@""
                                               title:@"发表"
                                              action:@selector(PublishButtonDidClick)];
        [backView addSubview:self.publishButton];

    }
    return self;
}

- (void)editButtonDidClick {
    
}

- (void)PublishButtonDidClick {
    
}

- (void)closeDidClilck {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(publishCellCloseDelegate:)]) {
//        [self.delegate publishCellCloseDelegate:self];
//    }
}

- (void)setCaogaomodel:(MineCaogaoModel *)caogaomodel {
    _caogaomodel = caogaomodel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:caogaomodel.imgUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.titleLabe.text = caogaomodel.title;
    self.timeLabe.text = [[AppDateManager shareManager] getDateWithTime:caogaomodel.dateline formatSytle:DateFormatYMD];
    
}


@end
