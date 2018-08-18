//
//  LogDetailController.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/28.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "LogDetailController.h"
#import "DetailDao.h"
#import "LogDetailHeadView.h"
#import "LogDetailBirdCell.h"
#import "LogContentCell.h"
#import <MJRefresh/MJRefresh.h>
#import "LogDetailTalkModel.h"
#import "LogDeatilTalkCell.h"
#import "LogDetailHeadCell.h"
#import "LogDetailUpModel.h"
#import "LogContentModel.h"
#import "LogContentSubjectCell.h"
#import "UserDao.h"
#import "DiscoverDao.h"

@interface LogDetailController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

// 日志
@property (nonatomic, strong) LogDetailModel *detailModel;

// 文章
@property (nonatomic, strong) LogContentModel *contentModel;


@property (nonatomic, strong) LogDetailHeadView *headerView;


@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) UIView *talkView;

@property (nonatomic, strong) UITextField *talkTextField;


@property (nonatomic, assign) NSInteger page;

// 评论
@property (nonatomic, strong) NSMutableArray *dataArray;

// 赞
@property (nonatomic, strong) NSMutableArray *headArray;


// 评论总数
@property (nonatomic, copy) NSString *count;

@end

@implementation LogDetailController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setTableView];
    
    if (self.tid.length) {
        [self netForLogDetail];
        
    } else if (self.aid.length) {
        [self netForLogContent];
    }
    
    [self netForTalkList];
    [self netforUplist];

}

#pragma mark-- tabelView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        if (self.tid.length) {
            return self.detailModel.postBody.count;
        } else if (self.aid.length) {
            return self.contentModel.articleList.count + 2;
        }
    }
    
    if (section == 2) { // 头像列表
        return 1;
    }
    
    if (section == 3) {
        return self.dataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell;
    if (section == 0) {
        LogDetailBirdCell *birdcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogDetailBirdCell class]) forIndexPath:indexPath];
        if (row == 0) {
            birdcell.birdArray = self.detailModel.birdInfo;
        } else if (row == 1) {
            birdcell.location = self.detailModel.locale;
        } else if (row == 2) {
            birdcell.time = [[AppDateManager shareManager] getDateWithTime:self.detailModel.publishTime formatSytle:DateFormatYMD];
        } else if (row == 3) {
            birdcell.evHuanjing = self.detailModel.environment;
        }
        cell = birdcell;
    } else if (section == 1) {
        if (self.aid.length) {
            if (row == 0) {
                LogContentSubjectCell *birdcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogContentSubjectCell class]) forIndexPath:indexPath];
                birdcell.title = [NSString stringWithFormat:@"责任编辑:%@", self.contentModel.author];
                birdcell.detail = [NSString stringWithFormat:@"作者：%@", self.contentModel.author];
                cell = birdcell;
            } else if (row == (self.contentModel.articleList.count + 1)) {
                LogContentSubjectCell *birdcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogContentSubjectCell class]) forIndexPath:indexPath];
                birdcell.title = [NSString stringWithFormat:@"来源:%@", self.contentModel.from];
                birdcell.detail = @"";
                cell = birdcell;
            } else {
                LogContentCell *birdcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogContentCell class]) forIndexPath:indexPath];

                if (self.contentModel.articleList.count + 1 > row) {
                    birdcell.contentModel = self.contentModel.articleList[row - 1];
                }
                cell = birdcell;
            }
        } else {
            LogContentCell *birdcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogContentCell class]) forIndexPath:indexPath];
            if (self.tid.length) {
                if (self.detailModel.postBody.count > row) {
                    birdcell.bodyModel = self.detailModel.postBody[row];
                }
            } else if (self.aid.length) {
                if (self.contentModel.articleList.count > row) {
                    birdcell.contentModel = self.contentModel.articleList[row];
                }
            }
            cell = birdcell;
        }
    } else if (section == 2) {
        
        LogDetailHeadCell *birdcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogDetailHeadCell class]) forIndexPath:indexPath];
        birdcell.dataArray = self.headArray;
        cell = birdcell;

    } else if (section == 3) {
        LogDeatilTalkCell *birdcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogDeatilTalkCell class]) forIndexPath:indexPath];
        if (self.dataArray.count > row) {
            birdcell.bodyModel = self.dataArray[row];
        }
        cell = birdcell;
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            return self.detailModel.birdInfo.count ? AutoSize6(94) : 0.0f;
        }
        
        if (row == 1) {
//            return self.detailModel.locale.length ? AutoSize6(94) : 0.0f;
            return self.detailModel.birdInfo.count ? AutoSize6(94) : 0.0f;
        }
        
        if (row == 2) {
//            return self.detailModel.publishTime.length ? AutoSize6(94) : 0.0f;
            return self.detailModel.birdInfo.count ? AutoSize6(94) : 0.0f;
        }
        
        if (row == 3) {
            return self.detailModel.birdInfo.count ? AutoSize6(94) : 0.0f;
        }
    }

    if (section == 1) {
        if (self.tid.length) {
            if (self.detailModel.postBody.count > row) {
                
                if ((self.detailModel.postBody.count - 1) == row) {
                    return [LogContentCell getHeightWithModel:self.detailModel.postBody[row]] + AutoSize6(10);
                }
                return [LogContentCell getHeightWithModel:self.detailModel.postBody[row]];
            }
        } else if (self.aid.length) {
            if (row == 0) {
                if (self.contentModel.author.length) {
                    return AutoSize6(80);
                } else {
                    return 0;
                }
            }
            if (row == (self.contentModel.articleList.count + 1)) {
                return AutoSize6(80);
            }
            if (self.contentModel.articleList.count + 1 > row) {
                return [LogContentCell getHeightWithContentModel:self.contentModel.articleList[row -1]];
            }
        }

    }
    
    if (section == 2) {
        if (self.headArray.count) {
            return AutoSize6(138);
        }
    }
    
    if (section == 3) {
        if (self.dataArray.count) {
            return [LogDeatilTalkCell getHeightWithModel:self.dataArray[row]];
        }
    }
    
    return AutoSize6(0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        if (self.detailModel.birdInfo.count ) {
            return AutoSize6(20);
        }
    }
    
    if (section == 3) {
        if (self.dataArray.count) {
            return AutoSize6(60);
        }
    }
    return AutoSize6(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(60))];
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(AutoSize6(30), AutoSize6(35), AutoSize6(400), AutoSize6(25))];
        label1.text = [NSString stringWithFormat:@"已有%@人评论过", self.count];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.textColor = kColorTextColorLightGraya2a2a2;
        label1.font = kFont6(22);
        [backView addSubview:label1];
        return backView;
        
    }
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)netForLogDetail {
    [AppBaseHud showHudWithLoding:self.view];
    @weakify(self);
    [DetailDao getLogDetail:self.tid successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        [AppBaseHud hideHud:self.view];
        
        LogDetailModel *detailModel = (LogDetailModel *)responseObject;
        
        if ([detailModel.authorid isEqualToString:[UserPage sharedInstance].userModel.uid]) {
            [self setRightButton];
        }
        
        self.tableView.tableHeaderView = self.headerView;
        self.headerView.detailModel = detailModel;
        self.headerView.height = [self.headerView getHeight];

        self.detailModel = detailModel;
        [self.tableView reloadData];
        
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
    }];
}

- (void)netForLogContent {
    [AppBaseHud showHudWithLoding:self.view];
    @weakify(self);
    [DetailDao getLogContent:self.aid successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        [AppBaseHud hideHud:self.view];
        
        LogContentModel *contentModel = (LogContentModel *)responseObject;
        
        self.tableView.tableHeaderView = self.headerView;
        self.headerView.contentModel = contentModel;
        self.headerView.height = [self.headerView getHeight];
        
        self.contentModel = contentModel;
        [self.tableView reloadData];
        
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
    }];
}


- (void)netForTalkList {
    
    NSString *string;
    if (self.tid.length) {
        string = self.tid;
    } else {
        string = self.aid;
    }
    
    @weakify(self);
    [DetailDao getLogDetail:string aid:self.aid page:[NSString stringWithFormat:@"%ld", self.page] successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        self.page ++;
        
        LogDetailTalkDataModel *dataModel = (LogDetailTalkDataModel *)responseObject;
        self.count = dataModel.count;
        if (dataModel.commentList.count) {
            [self.dataArray addObjectsFromArray: dataModel.commentList];
        } else {
            [self.tableView.mj_footer removeFromSuperview];
            self.tableView.tableFooterView = self.footerView;
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
        [self.tableView.mj_footer endRefreshing];

    }];
}

- (void)netforUplist {
    
    NSString *string;
    if (self.tid.length) {
        string = self.tid;
    } else {
        string = self.aid;
    }
    
    [AppBaseHud showHudWithLoding:self.view];
    @weakify(self);
    [DetailDao getLogUPDetail:string aid:self.aid successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        [AppBaseHud hideHud:self.view];
        LogDetailUpDataModel *dataModel = (LogDetailUpDataModel *)responseObject;
        
        self.headArray = [NSMutableArray new];
        
        [self.headArray addObjectsFromArray:dataModel.data];
        [self.tableView reloadData];
        
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
    }];
}

#pragma mark--- UI

- (void)setNavigation {
    if (self.tid.length) {
        if (self.logType == 1) {
            self.title = @"观鸟记录";
        } else {
            self.title = @"日志详情";
        }
    } else {
        self.title = @"文章详情";
    }

    self.page = 1;
    self.dataArray = [NSMutableArray new];
}

- (void)setRightButton {
    
    self.rightButton.title = @"操作";
    [self.rightButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName: kFont6(30)} forState:UIControlStateNormal];
    [self.rightButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName: kFont6(30)} forState:UIControlStateHighlighted];
    
}

- (void)rightButtonAction {
    
    UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑", @"删除", @"投稿", @"分享",@"举报", nil];
    [actionsheet03 showInView:self.view];
}

// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        if (0 == buttonIndex) {
            
        } else if (1 == buttonIndex) {
            
            [AppBaseHud showHudWithLoding:self.view];
            @weakify(self);
            [DetailDao getDeleteDetail:self.tid successBlock:^(__kindof AppBaseModel *responseObject) {
                @strongify(self);
                [AppBaseHud showHudWithSuccessful:@"删除成功" view:self.view block:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            } failureBlock:^(__kindof AppBaseModel *error) {
                @strongify(self);
                [AppBaseHud showHudWithfail:error.errstr view:self.view];
            }];
            
          
        } else if (2 == buttonIndex) {
           
        } else if (3 == buttonIndex) {
            
        }
}

- (void)setTableView {
    
    self.tableView.top = total_topView_height;
    self.tableView.height = SCREEN_HEIGHT - total_topView_height - AutoSize6(98);
    self.tableView.backgroundColor = kColoreDefaultBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LogDetailBirdCell class] forCellReuseIdentifier:NSStringFromClass([LogDetailBirdCell class])];
    [self.tableView registerClass:[LogContentCell class] forCellReuseIdentifier:NSStringFromClass([LogContentCell class])];
    [self.tableView registerClass:[LogDeatilTalkCell class] forCellReuseIdentifier:NSStringFromClass([LogDeatilTalkCell class])];
    [self.tableView registerClass:[LogDetailHeadCell class] forCellReuseIdentifier:NSStringFromClass([LogDetailHeadCell class])];
    [self.tableView registerClass:[LogContentSubjectCell class] forCellReuseIdentifier:NSStringFromClass([LogContentSubjectCell class])];

    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(netForTalkList)];
    
    self.toolView = [self makeToolView];
    
    self.talkView = [self makeTalkView];
}

- (LogDetailHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[LogDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(300))];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(400))];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(AutoSize6(100), AutoSize6(78), AutoSize6(174), AutoSize6(115))];
        icon.image = [UIImage imageNamed:@"detail_no_talk"];
        icon.contentMode = UIViewContentModeCenter;
        [_footerView addSubview:icon];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + AutoSize6(15), AutoSize6(78), AutoSize6(400), AutoSize6(50))];
        label1.text = @"抢沙发的机会只有一次，";
        label1.textAlignment = NSTextAlignmentLeft;
        label1.textColor = kColorTextColorLightGraya2a2a2;
        label1.font = kFont6(30);
        [_footerView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + AutoSize6(15), label1.bottom + AutoSize6(10), AutoSize6(400), AutoSize6(50))];
        label2.text = @"你还在等什么?";
        label2.textAlignment = NSTextAlignmentLeft;
        label2.textColor = kColorTextColorLightGraya2a2a2;
        label2.font = kFont6(30);
        [_footerView addSubview:label2];
    }
    return _footerView;
}


- (UIView *)makeToolView {
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - AutoSize6(98), SCREEN_WIDTH, AutoSize6(98))];
    toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolView];
    [self.view bringSubviewToFront:toolView];
    
    CGFloat width = SCREEN_WIDTH / 4;
    
    [toolView addSubview:[UIFactory buttonWithFrame:CGRectMake(0, 0, width, toolView.height)
                                             target:self
                                              image:@"operat_big_icon_forward"
                                        selectImage:@"operat_big_icon_forward"
                                              title:@"转发"
                                             action:@selector(zhuanfaButtonDidClick:)]];
    
    [toolView addSubview:[UIFactory buttonWithFrame:CGRectMake(width, 0, width, toolView.height)
                                             target:self
                                              image:@"operat_big_icon_collect"
                                        selectImage:@"operat_big_icon_collected"
                                              title:@"收藏"
                                             action:@selector(collectButtonDidClick:)]];
    
    [toolView addSubview:[UIFactory buttonWithFrame:CGRectMake(width * 2, 0, width, toolView.height)
                                             target:self
                                              image:@"operat_big_icon_comment"
                                        selectImage:@"operat_big_icon_comment"
                                              title:@"评论"
                                             action:@selector(talkButtonDidClick:)]];
    
    [toolView addSubview:[UIFactory buttonWithFrame:CGRectMake(width * 3, 0, width, toolView.height)
                                             target:self
                                              image:@"operat_big_icon_like"
                                        selectImage:@"operat_big_icon_liked"
                                              title:@"赞"
                                             action:@selector(upButtonDidClick:)]];
    
    return toolView;
}

- (void)zhuanfaButtonDidClick:(UIButton *)button {
    
}

- (void)collectButtonDidClick:(UIButton *)button {
    
    NSString *stringId;
    if (self.aid.length) {
        stringId = self.aid;
    } else if (self.tid.length) {
        stringId = self.tid;
    }
    
    [UserDao userCollect:stringId successBlock:^(__kindof AppBaseModel *responseObject) {
        button.selected = !button.selected;
    } failureBlock:^(__kindof AppBaseModel *error) {
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
    }];

}

- (void)talkButtonDidClick:(UIButton *)button {
    
    [self registerForKeyboardNotifications];
    self.toolView.hidden = YES;
    self.talkView.hidden = NO;
    [self.talkTextField becomeFirstResponder];
}

- (void)upButtonDidClick:(UIButton *)button {
    NSString *stringId;
    if (self.aid.length) {
        stringId = self.aid;
    } else if (self.tid.length) {
        stringId = self.tid;
    }
    
    [UserDao userUp:stringId successBlock:^(__kindof AppBaseModel *responseObject) {
        button.selected = !button.selected;
        [AppBaseHud showHudWithSuccessful:@"点赞成功" view:self.view];
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
    }];
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;

    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        
        self.talkView.top = self.view.height - keyboardSize.height + AutoSize6(20);
    }];
    
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.toolView.hidden = NO;
    self.talkView.hidden = YES;
}

- (void)sendButtonDidClick {
    [self.talkTextField resignFirstResponder];
    
    NSString *stringId;
    if (self.aid.length) {
        stringId = self.aid;
    } else if (self.tid.length) {
        stringId = self.tid;
    }
    [DiscoverDao talkWithTid:stringId content:self.talkTextField.text successBlock:^(__kindof AppBaseModel *responseObject) {

    } failureBlock:^(__kindof AppBaseModel *error) {
        
    }];
    self.talkTextField.text = nil;

}


- (UIView *)makeTalkView {
    UIView *talkView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, AutoSize6(102))];
    talkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:talkView];
    [self.view bringSubviewToFront:talkView];
    
    UITextField *textFieled = [[UITextField alloc] initWithFrame:CGRectMake(AutoSize6(10), AutoSize6(15), SCREEN_WIDTH - AutoSize6(16) - AutoSize6(150), talkView.height - AutoSize6(32))];
    textFieled.backgroundColor = kColoreDefaultBackgroundColor;
    textFieled.placeholder = @"写一条高能评论";
    textFieled.textColor = kColorTextColor333333;
    textFieled.layer.cornerRadius = 5;
    [talkView addSubview:textFieled];
    textFieled.tintColor = UIColorFromRGB(0x999999);
    
    CGRect frame = textFieled.frame;
    frame.size.width = AutoSize6(20);// 距离左侧的距离
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textFieled.leftViewMode = UITextFieldViewModeAlways;
    textFieled.leftView = leftview;
    self.talkTextField = textFieled;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(textFieled.right + AutoSize6(10), textFieled.top, AutoSize6(150) - AutoSize6(20), textFieled.height)];
    [button setBackgroundColor:kColorDefaultColor];
    [talkView addSubview:button];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFont6(30);
    button.layer.cornerRadius = 3;
    [button addTarget:self action:@selector(sendButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    talkView.hidden = YES;
    return talkView;
}


@end
