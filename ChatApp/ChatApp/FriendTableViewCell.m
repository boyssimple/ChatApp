//
//  FriendTableViewCell.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:WhiteColor];
        //头像
        self.img = [UIImageView new];
        [self.img setImage:IMAGE(@"abc1.jpg")];
        [self addSubview:self.img];
        
        self.img.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10)
        .heightIs(42)
        .widthEqualToHeight(1);
        
        self.img.sd_cornerRadiusFromHeightRatio = @(0.5);
        
        //名称
        self.name = [UILabel new];
        self.name.textColor = APPCOLOR;
        self.name.font = FONT(FONTSIZE);
        self.name.text = @"admin";
        [self addSubview:self.name];
        
        self.name.sd_layout
        .widthIs(150)
        .heightIs(20)
        .centerYEqualToView(self)
        .leftSpaceToView(self.img,10);
        
        
        //名称
        self.status = [UILabel new];
        self.status.textColor = BlackColor;
        self.status.font = FONT(FONTSIZE);
        self.status.text = @"[在线]";
        [self addSubview:self.status];
        
        self.status.sd_layout
        .widthIs(70)
        .heightIs(20)
        .centerYEqualToView(self)
        .rightSpaceToView(self,10);
        
        UIView *line = [UIView new];
        [line setBackgroundColor:RGB(244, 244, 244)];
        [self addSubview:line];
        
        line.sd_layout
        .heightIs(1)
        .widthRatioToView(self,1)
        .bottomSpaceToView(self,0);
    }
    return self;
}


-(void)loadData:(User*)user{
    self.name.text = user.userId;
    self.status.text = user.status;
    
    NSString *userName = [NSString stringWithFormat:@"%@@%@",user.userId,kXMPP_HOST];
    XMPPJID *jid = [XMPPJID jidWithString:userName resource:kXMPP_PlNTFORM];
    NSData *photoData = [[[JKXMPPTool sharedInstance] avatarModule] photoDataForJID:jid];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        self.img.image = headImg;
    }else{
        self.img.image = IMAGE(DefaultHeadImage);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
