//
//  Person.h
//  JsonToModel
//
//  Created by zhangkang on 2018/8/28.
//  Copyright © 2018年 zhangkang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NSString
@end
@protocol Houses
@end
@class School;
@class Houses;

@interface Person : NSObject
@property (strong, nonatomic) NSArray<NSString>   *friends;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) float  age;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *weight;

@property (strong, nonatomic) NSArray<Houses>   *ownHouses;
@property (strong, nonatomic) School *school;



@end
