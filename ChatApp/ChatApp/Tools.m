//
//  Tools.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+(int)randomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to-from + 1)));
}

//计算文字高度
+(CGFloat) calHeight:(NSString *)contentStr andWidth:(CGFloat)width andFont:(NSInteger)font{
    return [self calHeight:contentStr andWidth:width andCustFont:[UIFont systemFontOfSize:font]];
    
}
//计算文字高度
+(CGFloat) calHeight:(NSString *)contentStr andWidth:(CGFloat)width andCustFont:(UIFont*)font{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    return retSize.height;
    
}

@end
