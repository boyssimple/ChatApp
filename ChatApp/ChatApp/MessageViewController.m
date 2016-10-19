//
//  MessageViewController.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "Message.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.selfTable setBackgroundColor:RGB(244, 244, 244)];
    self.selfTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.selfTable setContentInset:UIEdgeInsetsMake(20, 0, 20, 0)];
    messages = [NSMutableArray new];
    [self loadData];
    //接收好友消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNofitify:) name:XMPP_MESSAGE_RECEIVE object:nil];
    
    //添加发送给好友的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMsgNofitify:) name:XMPP_MESSAGE_ADD object:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MessageTableViewCell";
    MessageTableViewCell *cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [MessageTableViewCell new];
        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = backView;
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    }
    
    Message *msg = [messages objectAtIndex:indexPath.row];
    [cell loadData:msg];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中
    Message *msg = [messages objectAtIndex:indexPath.row];
    msg.type = 1;
    msg.amount = 0;
    [self calBadge];
    [self.selfTable reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_USER_CHATTING object:msg.whoFrom];
    [self cacheData];
}

-(void)receiveNofitify:(NSNotification*)nofitycation{
    XMPPMessage *xmppMessage = nofitycation.object;
    if ([xmppMessage.type isEqualToString:@"chat"]) {
        Message *msg = [Message new];
        NSString *from = xmppMessage.from.bare;
        if ([from isEqualToString:kXMPP_HOST]) {
            from = SYSTEMINFO;
        }else{
            NSRange range = [from rangeOfString:@"@"];
            from = [from substringToIndex:range.location];//截取范围类的字符串
        }
        msg.whoFrom = from;
        msg.type = 0;
        msg.amount = 1;
        msg.content = xmppMessage.body;
        
        //如果存在就添加数量，如果不存在就添加到数组
        BOOL flag = FALSE;
        for (Message *m in messages) {
            if ([m.whoFrom isEqualToString:msg.whoFrom]) {
                flag = TRUE;
                m.amount++;
                m.whoFrom = msg.whoFrom;
                m.content = msg.content;
                m.type = 0;
            }
        }
        if (!flag) {
            [messages addObject:msg];
        }
        [self cacheData];
        
        [self calBadge];
        [self.selfTable reloadData];
    }
    
}

- (void)cacheData{
    NSMutableArray *array = [NSMutableArray new];
    for (Message *m in messages) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:m.whoFrom,@"from",[NSString stringWithFormat:@"%d",m.type],@"type",[NSString stringWithFormat:@"%d",m.amount],@"amount",m.content,@"content", nil];
        [array addObject:dic];
    }
    
    DataStore *store = [[DataStore alloc] initDBWithName:MESSAGE_DB];
    [store createTableWithName:MESSAGE_TABLE];
    [store deleteObjectById:@"MESSAGE" fromTable:MESSAGE_TABLE];
    
    [store putObject:array withId:@"MESSAGE" intoTable:MESSAGE_TABLE];
}

#pragma mark ------- 计算未读数量
-(void)calBadge{
    int count = 0;
    for (Message *m in messages) {
        count += m.amount;
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"typeClass",[NSString stringWithFormat:@"%d",count],@"count", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_BADGE object:dic];
}

#pragma mark ------- 加载存储的聊天记录
-(void)loadData{
    DataStore *store = [[DataStore alloc] initDBWithName:MESSAGE_DB];
    [store createTableWithName:MESSAGE_TABLE];
    DataStoreItem *item = [store getYTKKeyValueItemById:@"MESSAGE" fromTable:MESSAGE_TABLE];
    if (item) {
        NSMutableArray* dataArray = [item.itemObject mutableCopy];
        
        for (NSDictionary *d in dataArray) {
            Message *msg = [Message new];
            msg.whoFrom = [d objectForKey:@"from"];
            msg.type = [[d objectForKey:@"type"]intValue];
            msg.amount = [[d objectForKey:@"amount"]intValue];
            msg.content = [d objectForKey:@"content"];
            
            [messages addObject:msg];
        }
        [self calBadge];
        [self.selfTable reloadData];
    }
}

-(void)addMsgNofitify:(NSNotification*)nofitycation{
    NSDictionary *dic = nofitycation.object;
    Message *msg = [Message new];

    msg.whoFrom = [dic objectForKey:@"whoFrom"];
    msg.type = 1;
    msg.amount = 0;
    msg.content = [dic objectForKey:@"content"];
    
    //如果存在就添加数量，如果不存在就添加到数组
    BOOL flag = FALSE;
    for (Message *m in messages) {
        if ([m.whoFrom isEqualToString:msg.whoFrom]) {
            flag = TRUE;
            m.whoFrom = msg.whoFrom;
            m.content = msg.content;
            m.type = 1;
        }
    }
    if (!flag) {
        [messages addObject:msg];
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (Message *m in messages) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:m.whoFrom,@"from",@"0",@"type",@"1",@"amount",m.content,@"content", nil];
        [array addObject:dic];
    }
    
    [self cacheData];
    [self calBadge];
    [self.selfTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
