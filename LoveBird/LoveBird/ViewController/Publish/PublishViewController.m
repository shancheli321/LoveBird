//
//  PublishViewController.m
//  LoveBird
//
//  Created by ShanCheli on 2018/1/27.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "PublishViewController.h"
#import "PublishHeaderView.h"
#import "PublishSelectCell.h"
#import "PublishDetailCell.h"
#import "PublishDetailModel.h"
#import "PublishFooterView.h"
#import "PublishDao.h"
#import "PublishCell.h"
#import "PublishEditModel.h"
#import "PublishContenController.h"
#import "ApplyTimePickerView.h"
#import "PublishSelectModel.h"
#import "PublishBirdInfoModel.h"
#import "PublishEVController.h"
#import "PublishEVModel.h"

@interface PublishViewController ()<UITableViewDataSource, PublishFooterViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PublishCellDelegate, PublishSelectDelegate>

// tableview数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 保存选择的图片或者文字
@property (nonatomic, strong) NSMutableArray *dataModelArray;

// 鸟种
@property (nonatomic, strong) NSMutableArray *birdInfoArray;

@property (nonatomic, strong) PublishHeaderView *headerView;

@property (nonatomic, strong) PublishFooterView *footerView;

// 显示添加 的model
@property (nonatomic, strong) PublishEditModel *selectEditModel;

// 生态环境
@property (nonatomic, strong) PublishEVModel *selectEVModel;

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self setTableView];
    [self setModels];
}

#pragma mark-- 发布

- (void)rightButtonAction {
    [AppBaseHud showHudWithLoding:self.view];
    @weakify(self);
    [PublishDao publish:self.dataModelArray birdInfo:self.birdInfoArray successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        [AppBaseHud showHudWithSuccessful:@"发布成功" view:self.view];
        [self.dataArray removeAllObjects];
        self.dataArray = nil;
        [self.dataModelArray removeAllObjects];
        self.dataModelArray = nil;
        [self.birdInfoArray removeAllObjects];
        self.birdInfoArray = nil;
        
        [self reloadHeaderView];
        [self reloadFooterView:NO];
        [self setModels];
        [self.tableView reloadData];
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);
        [AppBaseHud showHudWithfail:error.errstr view:self.view];
    }];
}

#pragma mark-- tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        PublishSelectCell *scell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishSelectCell class]) forIndexPath:indexPath];
        scell.selectModel = self.dataArray[indexPath.section][indexPath.row];
        scell.delegate = self;
        cell = scell;
    } else if (indexPath.section == 1) {
        PublishDetailCell *dcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishDetailCell class]) forIndexPath:indexPath];
        dcell.detailModel = self.dataArray[indexPath.section][indexPath.row];
        cell = dcell;
    } else {
        PublishCell *dcell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishCell class]) forIndexPath:indexPath];
        PublishEditModel *model = self.dataArray[indexPath.section][indexPath.row];
        
        model.isLast = NO;
        model.isFirst = NO;
        
        // 判断首行 和 尾行
        if (self.dataModelArray.count <= 2) {
            if (indexPath.row == 1) {
                model.isFirst = YES;
                model.isLast = YES;
            } else if (indexPath.row == 0) {
                model.isZero = YES;
            }
        } else {
            if (indexPath.row == 1) {
                model.isFirst = YES;
                model.isLast = NO;
            }  else if (indexPath.row == (self.dataModelArray.count - 1)) {
                model.isLast = YES;
                model.isFirst = NO;
            }
        }
        dcell.editModel = model;
        dcell.delegate = self;
        cell = dcell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 选择鸟种
    if (indexPath.section == 0) {
        
        return;
    }
    
    if ((indexPath.section == 1) && (indexPath.row == 0)) {
        ApplyTimePickerView *pickerView = [[ApplyTimePickerView alloc] initWithFrame:self.view.bounds];
        @weakify(self)
        pickerView.handler = ^(ApplyTimePickerView *timePickerView, NSString *date) {
            @strongify(self)
            [timePickerView removeFromSuperview];
            timePickerView = nil;
            if (date.length) {
                PublishDetailModel *model = self.dataArray[indexPath.section][indexPath.row];
                model.detailString = date;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        [self.view addSubview:pickerView];
        return;
    }
    
    // 生态环境
    if ((indexPath.section == 1) && (indexPath.row == 2)) {
        PublishEVController *evvc = [[PublishEVController alloc] init];
        evvc.selectEVModel = self.selectEVModel;
        @weakify(self);
        evvc.viewControllerActionBlock = ^(UIViewController *viewController, NSObject *userInfo) {
            @strongify(self);
            self.selectEVModel = (PublishEVModel *)userInfo;
            
            PublishDetailModel *model = self.dataArray[indexPath.section][indexPath.row];
            model.detailString = self.selectEVModel.name;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:evvc animated:YES];
        return;
    }
    
    if (indexPath.section == 2) {
        PublishEditModel *model = self.dataModelArray[indexPath.row];
        if (model.message.length) { // 如果是文字类型的可编辑
            PublishContenController *contentVC = [[PublishContenController alloc] init];
            contentVC.text = model.message;
            [self.navigationController pushViewController:contentVC animated:YES];
        }
        
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AutoSize6(112);
    }
    
    if (indexPath.section == 1) {
        return AutoSize6(95);
    }
    
    PublishEditModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.row == 0) {
        return model.isShow ? AutoSize6(154) : AutoSize6(74);
    } else {
        return model.isShow ? AutoSize6(428): AutoSize6(344);
    }
}

#pragma mark-- PublishCell 代理

// 关闭这一行
- (void)publishCellCloseDelegate:(PublishCell *)cell  {
    [self.dataModelArray removeObject:cell.editModel];
    
    if (self.dataModelArray.count == 1) {
        [self.dataModelArray removeAllObjects];
        [self reloadFooterView:NO];
    }
    [self.tableView reloadData];
}

// 上移
- (void)publishCellUpDelegate:(PublishCell *)cell {
    
    if (self.dataModelArray.count < 2) return;
    
    for (int i = 0; i < self.dataModelArray.count; i++) {
        PublishEditModel *model = self.dataModelArray[i];
        if ([cell.editModel isEqual:model]) {
            
            if (i > 0) {
                [self.dataModelArray removeObject:model];
                [self.dataModelArray insertObject:model atIndex:(i - 1)];
                [self.tableView reloadData];
            }
            break;
        }
    }
}

// 下移
- (void)publishCellDownDelegate:(PublishCell *)cell {
    if (self.dataModelArray.count < 2) return;
    
    for (int i = 0; i < self.dataModelArray.count; i++) {
        PublishEditModel *model = self.dataModelArray[i];
        if ([cell.editModel isEqual:model]) {
            
            if (i < (self.dataModelArray.count - 1)) {
                [self.dataModelArray removeObject:model];
                [self.dataModelArray insertObject:model atIndex:(i + 1)];
                [self.tableView reloadData];
            }
            break;
        }
    }
}

// 添加文字
- (void)publishCellTextDelegate:(PublishCell *)cell {
    [self textViewClickDelegate:cell.editModel];
}

// 添加图片
- (void)publishCellImageDelegate:(PublishCell *)cell {
    [self imageViewClickDelegate:cell.editModel];
}

// 显示 添加文字和图片
- (void)publishCellAddDelegate:(PublishCell *)cell {
    PublishEditModel *model = cell.editModel;
    if (model.isShow) {
        return;
    }
    model.isShow = YES;
    [self.tableView reloadData];
}

// 减少鸟的数量
- (void)publishSelectCellLessDelegate:(PublishSelectCell *)cell {
    
    PublishSelectModel *model = cell.selectModel;
    model.count --;
}

// 添加鸟种 添加鸟的数量
- (void)publishSelectCellAddDelegate:(PublishSelectCell *)cell {
    
    if (cell.selectModel.isSelect) {
        PublishSelectModel *model = self.birdInfoArray.lastObject;
        model.count++;
        
        PublishSelectModel *modeladd = [[PublishSelectModel alloc] init];
        modeladd.title = @"选择鸟种";
        modeladd.isSelect = NO;
        modeladd.count = 1;
        [self.birdInfoArray insertObject:modeladd atIndex:0];
        [self.tableView reloadData];
    } else {
        PublishSelectModel *model = cell.selectModel;
        model.count ++;
    }
}

// 删除鸟种 这一行
- (void)publishSelectCellDeleteDelegate:(PublishSelectCell *)cell {
    
    PublishSelectModel *model = self.birdInfoArray.lastObject;
    model.count--;
    
    [self.birdInfoArray removeObject:cell.selectModel];
    [self.tableView reloadData];

}

#pragma mark-- footerview 选择图片 添加文字 代理
- (void)textViewClickDelegate:(PublishEditModel *)model {
    PublishContenController *contentvc = [[PublishContenController alloc] init];
    @weakify(self);
    @weakify(model);
    contentvc.contentblock = ^(NSString *contentString) {
        @strongify(self);
        @strongify(model);
        // 设置数据
        
        // 添加第一行
        [self adFirstObject];
        
        PublishEditModel *modeladd = [[PublishEditModel alloc] init];
        modeladd.message = contentString;
        modeladd.isShow = NO;
        modeladd.isImg = NO;
        [self getIndex:modeladd selectModel:model];
        
        model.isShow = NO;
        [self reloadFooterView:YES];
        [self.tableView reloadData];
    };
    contentvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contentvc animated:YES];
}

- (void)imageViewClickDelegate:(PublishEditModel *)model {
    self.selectEditModel = model;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择照片"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

// 获得在数组中次序
- (void)getIndex:(PublishEditModel *)model selectModel:(PublishEditModel *)selectModel {
    NSInteger index = 0;
    for (int i = 0; i < self.dataModelArray.count; i++ ) {
        if (selectModel == self.dataModelArray[i]) {
            index = i;
            break;
        }
    }
    if ((self.dataModelArray.count == 0) || (index == (self.dataModelArray.count - 1))) {
        [self.dataModelArray addObject:model];
    } else {
        [self.dataModelArray insertObject:model atIndex:(index + 1)];
    }
}

- (void)adFirstObject {
    if (self.dataModelArray.count == 0) {
        PublishEditModel *modeladd = [[PublishEditModel alloc] init];
        modeladd.isShow = NO;
        modeladd.isImg = NO;
        modeladd.isZero = YES;
        [self.dataModelArray addObject:modeladd];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self makePhoto];
        } else {
            [self showAlert];
        }
    } else if (buttonIndex == 1) {//相片
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self choosePicture];
        } else {
            [self showAlert];
        }
    }
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"我知道了", nil];
    [alert show];
}

//跳转到imagePicker里
- (void)makePhoto {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}
        
//跳转到相册
- (void)choosePicture {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *iamge = [info objectForKey:UIImagePickerControllerOriginalImage];
    @weakify(self);
    [PublishDao upLoad:iamge successBlock:^(__kindof AppBaseModel *responseObject) {
        @strongify(self);
        if (self.headerView.headerImageView.image == nil) {
            self.headerView.headerImageView.image = iamge;
        }
        
        self.selectEditModel.isShow = NO;
        PublishUpModel *upModel = (PublishUpModel *)responseObject;
        
        // 添加第一行
        [self adFirstObject];
        
        // 设置数据
        PublishEditModel *model = [[PublishEditModel alloc] init];
        model.isShow = NO;
        model.isImg = YES;
        model.imgUrl = upModel.imgUrl;
        model.aid = upModel.aid;
        model.isNewAid = YES;
        [self getIndex:model selectModel:self.selectEditModel];

        [self reloadFooterView:YES];
        [self.tableView reloadData];
        
    } failureBlock:^(__kindof AppBaseModel *error) {
        @strongify(self);

        [AppBaseHud showHud:error.errstr view:self.view];
    }];
}

#pragma mark-- 刷新footer
- (void)reloadFooterView:(BOOL)isHide {
    if (isHide) {
        self.footerView = nil;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(50))];
    } else {
        self.footerView = [[PublishFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize6(200))];
        self.footerView.delegate = self;
        self.tableView.tableFooterView = self.footerView;
    }
}

- (void)reloadHeaderView {
    self.headerView = nil;
    self.headerView = [[PublishHeaderView alloc] init];
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.headerView;
}


#pragma mark-- UI
- (void)setNavigation {
    self.navigationItem.title = @"编辑";
    self.rightButton.title = @"完成";
    [self.rightButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName: kFont6(30)} forState:UIControlStateNormal];
    [self.rightButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName: kFont6(30)} forState:UIControlStateHighlighted];

    [self.leftButton setImage:[UIImage imageNamed:@"nav_close_black"]];
}

- (void)leftButtonAction {
    if (self.viewControllerActionBlock) {
        self.viewControllerActionBlock(self, nil);
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)setTableView {
    
    self.tableView.top = total_topView_height;
    self.tableView.height = SCREEN_HEIGHT - total_topView_height;
    self.tableView.backgroundColor = kColoreDefaultBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PublishSelectCell class] forCellReuseIdentifier:NSStringFromClass([PublishSelectCell class])];
    [self.tableView registerClass:[PublishDetailCell class] forCellReuseIdentifier:NSStringFromClass([PublishDetailCell class])];
    [self.tableView registerClass:[PublishCell class] forCellReuseIdentifier:NSStringFromClass([PublishCell class])];
    
    [self reloadHeaderView];
    [self reloadFooterView:NO];
}

- (void)setModels {
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.birdInfoArray = [[NSMutableArray alloc] init];
    PublishSelectModel *model01 = [[PublishSelectModel alloc] init];
    model01.title = @"选择鸟种";
    model01.isSelect = YES;
    model01.count = 0;
    [self.birdInfoArray addObject:model01];
    [self.dataArray addObject:self.birdInfoArray];
    
    //
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    PublishDetailModel *model1 = [[PublishDetailModel alloc] init];
    model1.title = @"时间";
    model1.detailString = @"2017-09-13";
    [array2 addObject:model1];
    
    PublishDetailModel *model2 = [[PublishDetailModel alloc] init];
    model2.title = @"位置";
    model2.detailString = @"北京市海淀区";
    [array2 addObject:model2];
    
    PublishDetailModel *model3 = [[PublishDetailModel alloc] init];
    model3.title = @"生境";
    model3.detailString = @"选择";
    [array2 addObject:model3];
    [self.dataArray addObject:array2];
    
    self.dataModelArray = [[NSMutableArray alloc] init];
    [self.dataArray addObject:self.dataModelArray];
}

@end
