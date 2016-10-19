//
//  MsgTableViewCell.m
//  MsgCell
//
//  Created by zhouMR on 16/3/4.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "MsgTableViewCell.h"

#define kMaxContainerWidth 220.f
#define MaxChatImageViewWidh 200.f
#define MaxChatImageViewHeight 300.f

#define SWIDTH [UIScreen mainScreen].bounds.size.width

@implementation MsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.userImg = [UIImageView new];
    [self addSubview:self.userImg];
    
    
    self.messageImage = [[UIImageView alloc]init];
    self.messageImage.userInteractionEnabled = TRUE;
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImg)];
    [self.messageImage addGestureRecognizer:imgTap];
    
    self.bgImage = [UIImageView new];
    
    
    self.container = [UIView new];
    [self.container addSubview:self.messageImage];
    
    [self.container addSubview:self.bgImage];
    [self addSubview:self.container];
}

-(void)showImg{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showImage:)]) {
        [self.delegate showImage:self.messageImage];
    }
}

-(void)loadData:(Message *)msg{
    CGSize size;
    if (msg.type == IMAGE) {
        size = [self calSize:msg.content];//计算图片显示尺寸
        //隐藏图片
        self.messageImage.hidden = FALSE;
        self.messageImage.frame = CGRectMake(0, 0, size.width, size.height);
        NSData *data = [[NSData alloc]initWithBase64EncodedString:msg.content options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *calImage = [[UIImage alloc]initWithData:data];
        [self.messageImage setImage:calImage];
        
        self.container.layer.mask = self.bgImage.layer;
    }else if(msg.type == TEXT){
        //隐藏图片
        self.messageImage.hidden = TRUE;
        
        self.text = [UILabel new];
        self.text.numberOfLines = 0;
        self.text.font = [UIFont systemFontOfSize:14];
        self.text.text = msg.content;
        self.text.lineBreakMode = NSLineBreakByCharWrapping;
        
        CGFloat w = [self calWidthOld:msg.content height:15];
        if (w > kMaxContainerWidth) {
            w = kMaxContainerWidth;
        }else{
            w += 30;
        }
        
        CGFloat h = [self calHeightOld:msg.content width:w-30];
        self.text.frame = CGRectMake(15, 10, w-30, h);
        h += 20;
        size = CGSizeMake(w, h);
        [self.container addSubview:self.text];
    }
    
    if (msg.from == OTHER) {
        self.userImg.frame = CGRectMake(10, 15, 35, 35);
        [self.userImg setImage:[self loadImg:msg.whoFrom]];
        
        

        self.bgImage.frame = CGRectMake(0, 0, size.width, size.height+10);
        self.bgImage.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        
        
        self.container.frame = CGRectMake(self.userImg.frame.origin.x+self.userImg.frame.size.width+10, 10, size.width, size.height);
        
        
    }else{
        
        self.userImg.frame = CGRectMake(SWIDTH-45, 15, 35, 35);
        [self.userImg setImage:[self loadImg:msg.whoFrom]];
    
        self.bgImage.frame = CGRectMake(0, 0, size.width, size.height+10);
        self.bgImage.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        
    
        self.container.frame = CGRectMake(SWIDTH-self.userImg.frame.size.width-20-size.width, 10, size.width, size.height);
    }
    
    CGFloat totalHeight =  self.container.frame.size.height+20;
    CGRect f = self.frame;
    f.size.height = totalHeight;
    self.frame = f;
}


- (UIImage *)loadImg:(NSString*)userId{
    NSString *userName = [NSString stringWithFormat:@"%@@%@",userId,kXMPP_HOST];
    XMPPJID *jid = [XMPPJID jidWithString:userName resource:kXMPP_PlNTFORM];
    NSData *photoData = [[[JKXMPPTool sharedInstance] avatarModule] photoDataForJID:jid];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        return headImg;
    }else{
        return IMAGE(DefaultHeadImage);
    }
}

// 根据图片的宽高尺寸设置图片约束
-(CGSize)calSize:(NSString *)str{
    CGFloat standardWidthHeightRatio = MaxChatImageViewWidh / MaxChatImageViewHeight;
    CGFloat widthHeightRatio = 0;
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *calImage = [[UIImage alloc]initWithData:data];
    CGFloat h = calImage.size.height;
    CGFloat w = calImage.size.width;
    
    if (w > MaxChatImageViewWidh || w > MaxChatImageViewHeight) {
        
        widthHeightRatio = w / h;
        if (widthHeightRatio > standardWidthHeightRatio) {
            w = MaxChatImageViewWidh;
            h = w * (calImage.size.height / calImage.size.width);
        } else {
            h = MaxChatImageViewHeight;
            w = h * widthHeightRatio;
        }
    }
    return CGSizeMake(w, h);
}


//计算文字高度
-(CGFloat) calHeight:(NSString *)contentStr andWidth:(CGFloat)width{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGSize retSize = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    return retSize.height;
    
}

-(CGFloat)calHeightOld:(NSString *)aString width:(CGFloat)width{
    CGSize titleSize = [aString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return titleSize.height;
}

-(CGFloat)calWidthOld:(NSString *)aString height:(CGFloat)height{
    CGSize titleSize = [aString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:NSLineBreakByCharWrapping];
    return titleSize.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
