//
//  RegViewController.h
//  LoveBird
//
//  Created by ShanCheli on 2017/7/12.
//  Copyright © 2017年 shancheli. All rights reserved.
//

#import "AppBaseTableViewController.h"

typedef NS_ENUM(NSInteger, RegViewControllerType) {
    RegViewControllerTypeReg, // 注册
    RegViewControllerTypeForgetPassword, // 找回密码
};

@interface RegViewController : AppBaseTableViewController


/**
 *  页面类型
 */
@property (nonatomic, assign) RegViewControllerType controllerType;



@end
