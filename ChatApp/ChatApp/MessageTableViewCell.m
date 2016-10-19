//
//  MessageTableViewCell.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:ClearColor];
        
        self.bg = [UIView new];
        [self.bg setBackgroundColor:APPCOLOR];
        self.bg.layer.cornerRadius = RoundValue;
        [self addSubview:self.bg];
        
        self.bg.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self,10)
        .topSpaceToView(self,5)
        .bottomSpaceToView(self,5);
        
        //圆
        self.round = [UIView new];
        [self.round setBackgroundColor:RGB(25, 190, 150)];
        [self.bg addSubview:self.round];
        
        self.round.sd_layout
        .leftSpaceToView(self.bg,10)
        .topSpaceToView(self.bg,10)
        .bottomSpaceToView(self.bg,10)
        .widthEqualToHeight(1);
        self.round.sd_cornerRadiusFromHeightRatio = @(0.5);
        
        
        //头像
        self.img = [UIImageView new];
        [self.img setImage:IMAGE(@"abc1.jpg")];
        [self.round addSubview:self.img];
        
        self.img.sd_layout
        .leftSpaceToView(self.round,4)
        .topSpaceToView(self.round,4)
        .bottomSpaceToView(self.round,4)
        .widthEqualToHeight(1);
        
        self.img.sd_cornerRadiusFromHeightRatio = @(0.5);
        
        //数量
        self.amount = [UILabel new];
        [self.amount setBackgroundColor:RedColor];
        self.amount.textColor = WhiteColor;
        self.amount.font = FONT(FONTSIZE);
        self.amount.text = @"5";
        self.amount.textAlignment = NSTextAlignmentCenter;
        [self.bg addSubview:self.amount];
        
        self.amount.sd_layout
        .widthIs(20)
        .heightIs(20)
        .topSpaceToView(self.bg,10)
        .leftSpaceToView(self.round,-20);
        
        self.amount.sd_cornerRadiusFromHeightRatio = @(0.5);
        
        
        //用户昵称
        self.name = [UILabel new];
        self.name.textColor = WhiteColor;
        self.name.font = FONT(FONTSIZE);
        self.name.text = @"找幸福给你";
        [self.bg addSubview:self.name];
        
        self.name.sd_layout
        .heightIs(20)
        .topSpaceToView(self.bg,10)
        .leftSpaceToView(self.round,10)
        .rightSpaceToView(self.bg,80);
        
        //时间
        self.time = [UILabel new];
        [self.time setTextColor:WhiteColor];
        self.time.font = FONT(FONTSIZE);
        self.time.text = @"下午04:02";
        self.time.textAlignment = NSTextAlignmentRight;
        [self.bg addSubview:self.time];
        
        self.time.sd_layout
        .heightIs(20)
        .widthIs(80)
        .topSpaceToView(self.bg,10)
        .rightSpaceToView(self.bg,10);
        
        //内容
        self.content = [UILabel new];
        self.content.textColor = WhiteColor;
        self.content.font = FONT(FONTSIZE);
        self.content.numberOfLines = 2;
        self.content.text = @"十三五”开局之年的两会，比往年更受舆论关注。据介绍，参与2016年全国两会报道的记者总人数超过3200人，其";
        [self.bg addSubview:self.content];
        
        self.content.sd_layout
        .topSpaceToView(self.name,10)
        .rightSpaceToView(self.bg,10)
        .leftEqualToView(self.name)
        .heightIs(15);
    }
    return self;
}


-(void)loadData:(Message*)msg{
    if (msg.type == 1) {
        [self change];
    }
    self.content.text = msg.content;
    self.amount.text = [NSString stringWithFormat:@"%d",msg.amount];
    self.name.text = msg.whoFrom;
    
    NSString *userName = [NSString stringWithFormat:@"%@@%@", msg.whoFrom,kXMPP_HOST];
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

-(void)change{
    [self.bg setBackgroundColor:WhiteColor];
    [self.round setBackgroundColor:RGB(231, 229, 230)];
    [self.name setTextColor:APPCOLOR];
    self.amount.hidden = TRUE;
    [self.time setTextColor:RGB(202, 202, 202)];
    [self.content setTextColor:RGB(202, 202, 202)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
