//
//  UserDao.h
//  LoveBird
//
//  Created by cheli shan on 2018/5/2.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppHttpManager.h"

//100：系统消息；200:评论；300：关注；400：赞
typedef NS_ENUM(NSInteger,UserMessageType) {
    UserMessageTypeSystem = 100,
    UserMessageTypeTalk = 200,
    UserMessageTypeFollow = 300,
    UserMessageTypeUp = 400,
};


@interface UserDao : NSObject

// 1微信 2微博 3qq
+ (void)checkUserType:(NSInteger)type unionid:(NSString *)unionid openid:(NSString *)openid successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 手机注册 yes   第三方no
+ (void)getCode:(NSString *)mobile isRegister:(BOOL)isRegister successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;


// 获取推送消息
+ (void)userMessageType:(UserMessageType)type successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 关注列表
+ (void)userFollowList:(NSString *)taid page:(NSInteger)page successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 我的朋友圈 文章列表
+ (void)userContenPage:(NSInteger)pageNum SuccessBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 我的收藏列表
+ (void)userCollectList:(NSInteger)pageNum successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 我的日志列表
+ (void)userLogList:(NSInteger)pageNum
            matchId:(NSString *)matchId
                fid:(NSString *)taid
       successBlock:(LFRequestSuccess)successBlock
       failureBlock:(LFRequestFail)failureBlock;

// 我的鸟种列表
+ (void)userBirdList:(NSInteger)pageNum
                 fid:(NSString *)taid
             matchid:(NSString *)matchid
        successBlock:(LFRequestSuccess)successBlock
        failureBlock:(LFRequestFail)failureBlock;

// 相册列表
+ (void)userPhotoList:(NSString *)taid pageNum:(NSInteger)pageNum successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 粉丝列表
+ (void)userFansList:(NSString *)taid page:(NSInteger)page successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 搜索用户列表
+ (void)userGetList:(NSString *)word page:(NSInteger)page successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 我的个人信息
+ (void)userMyInfo:(NSString *)taid SuccessBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 注册
+ (void)userRegister:(NSString *)mobile
            password:(NSString *)password
                name:(NSString *)name
                code:(NSString *)code
                type:(NSInteger)type
              openID:(NSString *)openid
             unionid:(NSString *)unionid
           headImage:(NSString *)headImage
        SuccessBlock:(LFRequestSuccess)successBlock
        failureBlock:(LFRequestFail)failureBlock;


// 登录
+ (void)userLogin:(NSString *)mobile
         password:(NSString *)password
     SuccessBlock:(LFRequestSuccess)successBlock
     failureBlock:(LFRequestFail)failureBlock;


// 关注
+ (void)userFollow:(NSString *)taid successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 收藏
+ (void)userCollect:(NSString *)taid successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

// 点赞
+ (void)userUp:(NSString *)taid successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock ;

+ (void)sendMessage:(NSString *)taid message:(NSString *)message successBlock:(LFRequestSuccess)successBlock failureBlock:(LFRequestFail)failureBlock;

@end
