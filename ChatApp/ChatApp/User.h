//
//  User.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,assign)int type;


@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *phone;
@property (strong, nonatomic) UIImage *photo;
@property (copy, nonatomic) NSString *myJidResource;
@end
