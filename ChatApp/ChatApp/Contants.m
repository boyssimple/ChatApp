//
//  Contants.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "Contants.h"

@implementation Contants
+(Contants *)shareInstance{
    static Contants *manager = nil;
    if(!manager){
        manager = [[Contants alloc]init];
    }
    return manager;
}
@end
