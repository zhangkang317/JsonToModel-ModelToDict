//
//  ViewController.m
//  JsonToModel
//
//  Created by zhangkang on 2018/8/28.
//  Copyright © 2018年 zhangkang. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+LPPZModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"zhangkang";
    dict[@"age"] = @"28.9";
    dict[@"sex"] = @"male";
    dict[@"height"] = @"170cm";
    dict[@"weight"] = @"65kg";
    dict[@"friends"] = @[@"jack",@"tom",@"jerry"];
//    dict[@"school"] = @{@"schoolName":@"NewYork University",
//                        @"studentsNumber":@"4000",
//                        @"schoolAddress" :@"USA-NewYork-Brookling"
//                        };
    
    
    NSArray * houses = @[@{@"housesOwner":@"张三",
                           @"housesAddress":@"WuHan-JieFangRoad",
                           @"housesMoney":@"100W"
                           },
                         @{@"housesOwner":@"李四",
                           @"housesAddress":@"Beijing-JieFangRoad",
                           @"housesMoney":@"200W"}];
    
    
    dict[@"ownHouses"] = houses;

    Person * tom = [Person lppz_JsonToModelWithDict:dict ModelName:[Person class]];
    
    [tom lppz_toJSonDictWithValue];
}



@end
