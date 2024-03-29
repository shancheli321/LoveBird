//
//  PublishHeaderView.h
//  LoveBird
//
//  Created by cheli shan on 2018/5/6.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishEditModel.h"

@interface PublishHeaderView : UIView

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) NSMutableArray *choosePhotoArr;

@property (nonatomic, strong) UIImageView *headerImageView;

- (PublishEditModel *)getFengmian;


@end
