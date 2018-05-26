//
//  MineBirdViewController.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/23.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "MineBirdViewController.h"
#import "UserDao.h"
#import "MineBirdLeftCell.h"
#import "MineBirdRightCell.h"
#import "UserBirdModel.h"
#import "MJRefresh.h"


@interface MineBirdViewController ()<UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

//@property (nonatomic, strong) UILabel *tipsLabel;


@end

@implementation MineBirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self setTableView];
    [self netForLog];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)netForLog {
    
    [AppBaseHud showHudWithLoding:self.view];
    @weakify(self);
    [UserDao userBirdList:1 fid:@"" successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        [AppBaseHud hideHud:self.view];
        [self.tableView.mj_header endRefreshing];
        UserBirdDataModel *dataModel = (UserBirdDataModel *)responseObject;
        [self.dataArray addObjectsFromArray:dataModel.birdInfo];
        
        [self refreshHeaderView:[NSString stringWithFormat:@"%ld", (long)dataModel.birdNum]];
        [self.tableView reloadData];
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark-- tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.row % 2 == 0) {
        MineBirdLeftCell *leftcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineBirdLeftCell class]) forIndexPath:indexPath];
        leftcell.birdModel = self.dataArray[indexPath.row];
        cell = leftcell;
    } else {
        MineBirdRightCell *rightcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineBirdRightCell class]) forIndexPath:indexPath];
        rightcell.birdModel = self.dataArray[indexPath.row];
        cell = rightcell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AutoSize6(170);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AutoSize6(20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)setTableView {
    
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = kColoreDefaultBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[MineBirdLeftCell class] forCellReuseIdentifier:NSStringFromClass([MineBirdLeftCell class])];
    [self.tableView registerClass:[MineBirdRightCell class] forCellReuseIdentifier:NSStringFromClass([MineBirdRightCell class])];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(30))];
    
    //默认【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netForLog)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(netForLog)];
}

- (void)refreshHeaderView:(NSString *)count {
    
    self.tableView.tableHeaderView = nil;
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(70))];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AutoSize6(30), SCREEN_WIDTH, AutoSize6(40))];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSString *textString = [NSString stringWithFormat:@"「您一共发现了%@种鸟，继续加油哦」", count];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textString];
    [attrString addAttribute:NSForegroundColorAttributeName value:kColorTextColor7f7f7f range:NSMakeRange(0, 7)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, count.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:kColorTextColor7f7f7f range:NSMakeRange(7 + count.length, 9)];
    
    [attrString addAttribute:NSFontAttributeName value:kFont6(24) range:NSMakeRange(0, textString.length)];
    tipLabel.attributedText = attrString;
    [headview addSubview:tipLabel];
    
    self.tableView.tableHeaderView = headview;
}



@end