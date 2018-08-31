//
//  NSObject+LPPZModel.m
//  JsonToModel
//
//  Created by zhangkang on 2018/8/28.
//  Copyright © 2018年 zhangkang. All rights reserved.
//

#import "NSObject+LPPZModel.h"
#import <objc/runtime.h>
#import"Person.h"
@implementation NSObject (LPPZModel)
+(instancetype)lppz_JsonToModelWithDict:(NSDictionary *)dict ModelName:(Class)className{
    id model = [[className alloc] init];
//    [model setValue:@"god" forKey:@"name"];
    //获取model中的所有属性的变量
    unsigned int count;
    Ivar * ivarList = class_copyIvarList(className, &count);
    //遍历所有的属性变量
    for (int i = 0; i<count; i++) {
        //根据下标获取成员变量
        Ivar var = ivarList[i];
        //获取成员变量的名字
        NSString * propertyName = [NSString stringWithUTF8String:ivar_getName(var)];
        //获取成员变量的类型
        NSString * type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        
        //去掉“_”方便取出dict中的数值
        NSString * dictKey = propertyName;
        if ([propertyName hasPrefix:@"_"]) {
            dictKey = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        //简化属性的数据类型
        if (![type isEqualToString:@"f"]) {
            type = [type stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
            type = [type stringByReplacingCharactersInRange:NSMakeRange(type.length-1, 1) withString:@""];
        }
        
      

        id dictValue = [dict valueForKey:dictKey];
        
        
        if ([type isEqualToString:@"NSString"]) {
            [model setValue:dictValue
                     forKey:propertyName];
        }else if([type isEqualToString:@"f"]){
            NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:dictValue];
            [model setValue:discount1
                     forKey:propertyName];
        }else if ([type isEqualToString:@"NSNumber"]){
            [model setValue:dictValue
                     forKey:propertyName];
        }else if ([type rangeOfString:@"NSArray"].location != NSNotFound){
            Class subClass = [NSObject getSubClassWithString:type];
            if ([NSStringFromClass(subClass) isEqualToString:@"NSString"]) {
                [model setValue:dictValue
                         forKey:propertyName];
            }else{//数组包含数据模型
                NSArray * arrayValue = (NSArray * )dictValue;
                Class subClass = [NSObject getSubClassWithString:type];
                NSMutableArray * tmpArray = [NSMutableArray array];
                [arrayValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    id newValue  = [subClass lppz_JsonToModelWithDict:obj ModelName:subClass];
                    [tmpArray addObject:newValue];
                }];
                [model setValue:tmpArray
                         forKey:propertyName];
            }
        }else{//不是基础数据类型
            Class subClass = NSClassFromString(type);
            id newValue  = [subClass lppz_JsonToModelWithDict:dictValue ModelName:subClass];
            [model setValue:newValue
                     forKey:propertyName];
        }
    }
    
    return model;
}
-(NSDictionary *)lppz_toJSonDictWithValue{

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    Class curentClass = [self class];
    
    unsigned int count;
//    Ivar * ivarList = class_copyIvarList([self class], &count);
    objc_objectptr_t * propertes = class_copyPropertyList(curentClass, &count);
    
    for (int i = 0; i<count; i++) {
        objc_objectptr_t property = propertes[i];
        
        char *  name = property_getName(property);
      char * Attribute =   property_getAttributes(property);
        
        NSString * attributeString = [NSString stringWithUTF8String:Attribute];
        NSArray *tmpArray = [attributeString componentsSeparatedByString:@","];
        
        
        NSString * firstString = tmpArray.firstObject;
        NSRange startRange;
        NSString *typeString = firstString;


        if (![firstString isEqualToString:@"Tf"]) {
             startRange =NSMakeRange(3,firstString.length -3 -1);
             typeString = [firstString substringWithRange:startRange];
        }
        NSString *keyName = [NSString stringWithUTF8String:name];
        printf("%s\n",Attribute);

//
        if ([typeString isEqualToString:@"NSString"]) {
            dict[keyName] =[self valueForKey:keyName];
        }else if ([typeString isEqualToString:@"NSNumber"]){
            dict[keyName] =[self valueForKey:keyName];
        }else if ([typeString isEqualToString:@"Tf"]){
            
            dict[keyName] =[self valueForKey:keyName];

            NSLog(@"%@",[self valueForKey:keyName]);
        }else if ([typeString rangeOfString:@"NSArray"].location != NSNotFound){
            Class subclass = [NSObject getSubClassWithString:typeString];
            if ([NSStringFromClass(subclass) isEqualToString:@"NSString"]) {
                dict[keyName] = [self valueForKey:keyName];
            }else{
                NSMutableArray * tmpArray  =[NSMutableArray array];
                NSArray * propertyArray = [self valueForKey:keyName];
                [propertyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tmpArray addObject:[obj lppz_toJSonDictWithValue]];
                    
                }];
                dict[keyName] = tmpArray;

                
            }

        }
        
        
        
    }
    
    
    return dict;
}


+(Class )getSubClassWithString:(NSString *)text{
    NSRange startRange = [text rangeOfString:@"<"];
    NSRange endRange = [text rangeOfString:@">"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [text substringWithRange:range];
    Class subClass = NSClassFromString(result);
    return subClass;
    
}
@end
