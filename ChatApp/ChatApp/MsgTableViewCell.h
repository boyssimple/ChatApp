//
//  MsgTableViewCell.h
//  MsgCell
//
//  Created by zhouMR on 16/3/4.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@protocol MsgTableViewCellDelegate;
@interface MsgTableViewCell : UITableViewCell{
    int type;
}
@property(nonatomic,strong)UIImageView *userImg;
@property(nonatomic,strong)UIImageView *messageImage;
@property(nonatomic,strong)UIImageView *bgImage;
@property(nonatomic,strong)UIView *container;
@property(nonatomic,strong)UILabel *text;
@property(nonatomic,assign)id<MsgTableViewCellDelegate> delegate;
-(void)loadData:(Message *)msg;
@end

@protocol MsgTableViewCellDelegate <NSObject>

-(void)showImage:(UIImageView*)view;

@end