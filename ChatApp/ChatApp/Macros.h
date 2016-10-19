//
//  Macros.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define HEIGHT self.view.frame.size.height
#define WIDTH self.view.frame.size.width
#define S_WIDTH [UIScreen mainScreen].bounds.size.width
#define S_SIZE [UIScreen mainScreen].bounds.size

//字体大小
#define FONTSIZE 14

#pragma mark --------- 颜色自定义
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#define APPCOLOR RGB(27,214,169)

//黑色
#define BlackColor [UIColor blackColor]
//白色
#define WhiteColor [UIColor whiteColor]
//红色
#define RedColor [UIColor redColor]
//透明色
#define ClearColor [UIColor clearColor]
//绿色
#define GreenColor [UIColor greenColor]
//蓝色
#define BlueColor [UIColor blueColor]


#pragma mark --------- 图片
#define IMAGE(img)[UIImage imageNamed:img]

#pragma mark --------- 字体大小
#define FONT(size) [UIFont systemFontOfSize:size]


#pragma mark --------- 圆角值
#define RoundValue 6




#define kXMPP_HOST @"121.41.121.240"
#define kXMPP_PORT 5222
#define kXMPP_PlNTFORM @"IOS"

//*********************** 通知 *****************
#define kLOGIN_SUCCESS      @"kLOGIN_SUCCESS"
#define kREGIST_RESULT      @"kREGIST_RESULT"
#define kXMPP_ROSTER_CHANGE @"kXMPP_ROSTER_CHANGE"
#define kXMPP_MESSAGE_CHANGE @"kXMPP_MESSAGE_CHANGE"


#define XMPP_MESSAGE_RECEIVE @"XMPP_MESSAGE_RECEIVE"
#define XMPP_MESSAGE_ADD @"XMPP_MESSAGE_ADD"
#define XMPP_USER_CHATTING @"XMPP_USER_CHATTING"//用于传递用户id
#define XMPP_BADGE @"XMPP_BADGE"//badge数量

//中文固定值
#define SYSTEMINFO @"系统消息"


#define MESSAGE_DB @"message.db"
#define MESSAGE_TABLE @"MessageTable"


#define DefaultHeadImage @"DefaultProfileHead"
#endif /* Macros_h */
