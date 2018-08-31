//
//  NSObject+LPPZModel.h
//  JsonToModel
//
//  Created by zhangkang on 2018/8/28.
//  Copyright © 2018年 zhangkang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LPPZModel)
//json转模型
+(instancetype)lppz_JsonToModelWithDict:(NSDictionary *)dict ModelName:(Class)className ;



-(NSDictionary *)lppz_toJSonDictWithValue;
@end
