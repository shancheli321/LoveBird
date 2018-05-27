//
//  WorksViewController.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/27.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "WorksViewController.h"
#import "WorksModel.h"
#import "DiscoverDao.h"
#import <MJRefresh/MJRefresh.h>
#import "WorkTableViewCell.h"
#import "UIImage+Addition.h"

@interface WorksViewController ()<UITableViewDelegate, UITableViewDataSource>

// 刷新页数
@property (nonatomic, copy) NSString *pageNum;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation WorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = @"";
    
    _dataArray = [NSMutableArray new];
    
    [self setNavigation];
    
    // 设置UI
    [self setTableView];
    
    [self netForContentHeader];
}

- (void)netForContentHeader {
    self.pageNum = @"";
    
    [self netForContentWithPageNum:self.pageNum header:YES];
}
- (void)netForContentFooter {
    [self netForContentWithPageNum:self.pageNum header:NO];
}
- (void)netForContentWithPageNum:(NSString *)pageNum header:(BOOL)header {
    
    @weakify(self);
    [DiscoverDao getWorksList:@"" matchid:@"" minAid:pageNum successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        if (header) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        WorksDataModel *dataModel = (WorksDataModel *)responseObject;
        self.pageNum = dataModel.maxAid;
        if (header) {
            [self.dataArray removeAllObjects];
        }
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSArray *array in dataModel.imgList) {
            NSArray *modelArray = [WorksModel arrayOfModelsFromDictionaries:array error:nil];
            [tempArray addObject:modelArray];
        }
        
        [self.dataArray addObjectsFromArray:tempArray];
        [self.tableView reloadData];
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        if (header) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
    }];
}

#pragma mark-- tabelView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WorkTableViewCell class]) forIndexPath:indexPath];
    
    cell.listArray = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *listArray = self.dataArray[indexPath.row];
    if (listArray.count == 1) {
        WorksModel *model = listArray.firstObject;
        CGFloat imageHeight = (model.imgHeight) * (SCREEN_WIDTH / model.imgWidth);
        return imageHeight + AutoSize6(2);
        
    } else if (listArray.count == 2) {
        WorksModel *model1 = listArray.firstObject;
        WorksModel *model2 = listArray.lastObject;
        
        CGFloat width1 = SCREEN_WIDTH * (model1.imgWidth / (model1.imgWidth + model2.imgWidth));
        
        CGFloat imageHeight = (model1.imgHeight) * (width1 / model1.imgWidth);
        return imageHeight + AutoSize6(2);
    }
    
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)buttonDidClick:(UIButton *)button {
    if (button == self.selectButton) {
        return;
    }
    
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
}

- (void)setNavigation {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AutoSize6(270), AutoSize6(68))];
    titleView.layer.borderColor = kColorDefaultColor.CGColor;
    titleView.layer.borderWidth = 1;
    titleView.layer.cornerRadius = 5;
    titleView.clipsToBounds = YES;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleView.width / 2, titleView.height)];
    [leftButton setBackgroundImage:[[UIImage alloc] drawImageWithBackgroudColor:kColorDefaultColor withSize:leftButton.size] forState:UIControlStateSelected];
    [leftButton setBackgroundImage:[[UIImage alloc] drawImageWithBackgroudColor:[UIColor whiteColor] withSize:leftButton.size] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"精品" forState:UIControlStateNormal];
    [leftButton setTitle:@"精品" forState:UIControlStateSelected];
    leftButton.titleLabel.font = kFont6(24);
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.selected = YES;
    self.selectButton = leftButton;
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(leftButton.right, 0, titleView.width / 2, titleView.height)];
    [rightButton setBackgroundImage:[[UIImage alloc] drawImageWithBackgroudColor:kColorDefaultColor withSize:leftButton.size] forState:UIControlStateSelected];
    [rightButton setBackgroundImage:[[UIImage alloc] drawImageWithBackgroudColor:[UIColor whiteColor] withSize:leftButton.size] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"最新" forState:UIControlStateNormal];
    [rightButton setTitle:@"最新" forState:UIControlStateSelected];
    rightButton.titleLabel.font = kFont6(24);

    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleView addSubview:rightButton];
    
    self.navigationItem.titleView = titleView;
    
    
}

- (void)setTableView {
    
    self.tableView.top = total_topView_height;
    self.tableView.height = SCREEN_HEIGHT - total_topView_height;
    self.tableView.backgroundColor = kColoreDefaultBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WorkTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WorkTableViewCell class])];
    
    //默认【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netForContentHeader)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(netForContentFooter)];
}

@end