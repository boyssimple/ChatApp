//
//  FriendTableViewCell.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FriendTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *status;

-(void)loadData:(User*)user;
@end
