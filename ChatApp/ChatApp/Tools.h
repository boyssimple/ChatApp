//
//  Tools.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

//生成from到to之间的随机数
+(int)randomNumber:(int)from to:(int)to;

//计算文字高度
+(CGFloat) calHeight:(NSString *)contentStr andWidth:(CGFloat)width andFont:(NSInteger)font;

//计算文字高度
+(CGFloat) calHeight:(NSString *)contentStr andWidth:(CGFloat)width andCustFont:(UIFont*)font;
@end
