//
//  MessageTableViewCell.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *bg;
@property(nonatomic,strong)UIView *round;
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UILabel *amount;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *content;

-(void)loadData:(Message*)msg;
@end
