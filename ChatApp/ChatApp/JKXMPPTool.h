//
//  JKXMPPTool.h
//  ChatDemo
//
//  Created by Joker on 15/7/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface JKXMPPTool : NSObject<XMPPStreamDelegate,UIAlertViewDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate,XMPPIncomingFileTransferDelegate>{
    XMPPvCardAvatarModule *_xmppAvatarModule;     //头像模块
    XMPPvCardTempModule *_xmppvCardModule;        //电子身份模块
}


@property (nonatomic, strong) XMPPStream *xmppStream;
// 模块
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;

@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, strong) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;

@property (nonatomic, assign) BOOL  xmppNeedRegister;
@property (nonatomic, copy)   NSString *myPassword;

@property (nonatomic, strong) XMPPPresence *receivePresence;

@property (nonatomic, strong) User *user;

+ (instancetype)sharedInstance;
- (void)loginWithJID:(XMPPJID *)JID andPassword:(NSString *)password;
- (void)registerWithJID:(XMPPJID *)JID andPassword:(NSString *)password;

- (void)addFriend:(XMPPJID *)aJID;
- (void)addFriendById:(NSString*)userName;
- (void)goOffLine;


- (XMPPvCardAvatarModule *)avatarModule;    //头像模块;
- (XMPPvCardTempModule *)vCardModule;       //电子名片模块
@end
