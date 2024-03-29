//
//  MineFriendViewController.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/23.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "MineFriendViewController.h"
#import "UserDao.h"
#import "ShequModel.h"
#import "ShequFrameModel.h"
#import "ShequCell.h"
#import "MJRefresh.h"
#import "LogDetailController.h"



@interface MineFriendViewController ()<UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MineFriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify) name:kLoginSuccessNotification object:nil];

    
    [self setTableView];
    
    [self netForHeader];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notify {
    [self.tableView.mj_header beginRefreshing];
}


- (void)netForHeader {
    self.page = 1;
    [self netForLog];
}

- (void)netForLog {

    @weakify(self);
    [UserDao userContenPage:self.page SuccessBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        [AppBaseHud hideHud:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        self.page ++;

        ShequDataModel *dataModel = (ShequDataModel *)responseObject;
        for (ShequModel *model in dataModel.data) {
            ShequFrameModel *frameModel = [[ShequFrameModel alloc] init];
            frameModel.shequModel = model;
            [self.dataArray addObject:frameModel];
        }
        if (dataModel.data.count) {
            [self.tableView reloadData];
        }
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
}

#pragma mark-- tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShequCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShequCell class]) forIndexPath:indexPath];
    ShequFrameModel *model = self.dataArray[indexPath.row];
    cell.shequFrameModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShequFrameModel *model = self.dataArray[indexPath.row];
    return model.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return AutoSize6(20);
    }
    
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShequFrameModel *frameModel = self.dataArray[indexPath.row];
    if (frameModel.shequModel.tid.length) {
        LogDetailController *detailController = [[LogDetailController alloc] init];
        detailController.tid = frameModel.shequModel.tid;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)setTableView {
    
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = kColoreDefaultBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(30))];

    [self.tableView registerClass:[ShequCell class] forCellReuseIdentifier:NSStringFromClass([ShequCell class])];
    
    //默认【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netForHeader)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(netForLog)];
}


@end
