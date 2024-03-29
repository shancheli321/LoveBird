//
//  WorksModel.m
//  LoveBird
//
//  Created by cheli shan on 2018/5/27.
//  Copyright © 2018年 shancheli. All rights reserved.
//

#import "WorksModel.h"


@implementation WorksDataModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONBlock:^NSString *(NSString *keyName) {
        return [NSString stringWithFormat:@"data.%@", keyName];
    }];
}


+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation WorksModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end
