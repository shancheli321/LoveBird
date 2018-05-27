//
//  FindBodyResultController.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/27.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "FindBodyResultController.h"
#import "FindResultCell.h"

@interface FindBodyResultController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) FindSelectBirdModel *selectBirdModel;

@end

@implementation FindBodyResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查询结果";
    self.rightButton.title = @"完成";
    [self.rightButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName: kFont6(30)} forState:UIControlStateNormal];
    [self.rightButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName: kFont6(30)} forState:UIControlStateHighlighted];
    
    [self setTableView];
}


#pragma mark-- tabelView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindResultCell class]) forIndexPath:indexPath];
    cell.birdModel = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return AutoSize6(130);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FindSelectBirdModel *bridModel = self.dataArray[indexPath.row];
    if (self.selectBirdModel == bridModel) {
        return;
    }
    
    for (FindSelectBirdModel *cellmodel in self.dataArray) {
        if (cellmodel.isSelect) {
            cellmodel.isSelect = NO;
            break;
        }
    }
    self.selectBirdModel = bridModel;
    bridModel.isSelect = YES;
    [self.tableView reloadData];
}

- (void)setDataModel:(FindSelectBirdDataModel *)dataModel {
    _dataModel = dataModel;
    _dataArray = [NSMutableArray new];

    [self.dataArray addObjectsFromArray:dataModel.data];
    [self.tableView reloadData];
}

- (void)setTableView {
    
    self.tableView.top = total_topView_height;
    self.tableView.height = SCREEN_HEIGHT - total_topView_height;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = nil;
    [self.tableView registerClass:[FindResultCell class] forCellReuseIdentifier:NSStringFromClass([FindResultCell class])];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(50))];
}

@end