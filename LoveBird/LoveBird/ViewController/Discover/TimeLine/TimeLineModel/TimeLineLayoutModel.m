//
//  TimeLineLayoutModel.m
//  LFBaseProject
//
//  Created by ShanCheli on 2018/1/30.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "TimeLineLayoutModel.h"

@implementation TimeLineLayoutModel

- (void)setContentModel:(DiscoverContentModel *)contentModel {
    _contentModel = contentModel;
    
    CGFloat height = 0;
    
    // 头部空白
    _topViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(5));
    height = CGRectGetMaxY(_topViewFrame);
    
    // 昵称栏
    _titleViewFrame = CGRectMake(0, height, SCREEN_WIDTH, AutoSize(60));
    height = CGRectGetMaxY(_titleViewFrame);

    // 图片  不一定存在
    if (contentModel.imgUrl.length) {
        CGFloat imageHeight = (contentModel.imgHeight) * (SCREEN_WIDTH / contentModel.imgWidth);
        _contentImageViewFrame = CGRectMake(0, height, SCREEN_WIDTH, imageHeight);
        height = CGRectGetMaxY(_contentImageViewFrame);
    }

    // 文章标题
    CGFloat titleLabelHeight = [contentModel.subject getTextHeightWithFont:kFontDiscoverTitle withWidth:(SCREEN_WIDTH - AutoSize(26))];
    _titleLabelFrame = CGRectMake(AutoSize(13), height + AutoSize(10), SCREEN_WIDTH - AutoSize(26), titleLabelHeight);
    height = CGRectGetMaxY(_titleLabelFrame);

    
    //文章内容 不一定存在
    if (contentModel.summary.length) {
        CGFloat contentLabelHeight = [contentModel.summary getTextHeightWithFont:kFontDiscoverContent withWidth:_titleLabelFrame.size.width];
        _contentLabelFrame = CGRectMake(_titleLabelFrame.origin.x, height + AutoSize(10), _titleLabelFrame.size.width, contentLabelHeight);
        height = CGRectGetMaxY(_contentLabelFrame);
    }

    height = height + AutoSize(10);
    
    // 底部空白
    _bottomViewFrame = CGRectMake(_titleLabelFrame.origin.x, height, _titleLabelFrame.size.width, 1);
    height = CGRectGetMaxY(_bottomViewFrame);
    
    // 工具条
    _toolViewFrame = CGRectMake(0, height, SCREEN_WIDTH, AutoSize(45));
    height = CGRectGetMaxY(_toolViewFrame);

    _height = height;
}

@end