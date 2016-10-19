//
//  Message.h
//  MsgCell
//
//  Created by simple on 16/3/4.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    TEXT,
    MEDIA,
    IMAGE
} MessageType;

typedef enum{
    OTHER,
    ME
} MessageWho;

@interface Message : NSObject
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *whoFrom;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,assign)MessageWho from;
@property(nonatomic,assign)MessageType type;
@property(nonatomic,assign)int amount;
@end
