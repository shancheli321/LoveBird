//
//  LogDetailHeadCell.h
//  LoveBird
//
//  Created by cheli shan on 2018/5/30.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogDetailHeadCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataArray;

+ (CGFloat)getHeight:(NSArray *)dataArray;

@end
