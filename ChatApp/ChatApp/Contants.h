//
//  Contants.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contants : NSObject
@property(nonatomic,strong)NSMutableArray *contacts;
+(Contants *)shareInstance;
@end
