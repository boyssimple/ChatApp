//
//  FriendViewController.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableViewCell.h"
#import "FriendSearchTableViewCell.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.selfTable setBackgroundColor:RGB(244, 244, 244)];
    self.selfTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.selfTable setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    self.contacts = [NSMutableArray new];
    [self addDefault];
    Contants *cont = [Contants shareInstance];
    if (cont.contacts != nil) {
        [self installData:cont.contacts];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rosterChange) name:kXMPP_ROSTER_CHANGE object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }
    return 62;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    User *user = [self.contacts objectAtIndex:indexPath.row];
    if (user.type == 0) {
        static NSString *identifier = @"FriendSearchTableViewCell";
        FriendSearchTableViewCell *cell = (FriendSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [FriendSearchTableViewCell new];
        }
        return cell;
    }else{
        static NSString *identifier = @"FriendTableViewCell";
        FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [FriendTableViewCell new];
        }

        [cell loadData:user];
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中
    User *user = [self.contacts objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_USER_CHATTING object:user.userId];
}

#pragma mark - notification event
- (void)rosterChange
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[JKXMPPTool sharedInstance].xmppRosterMemoryStorage.unsortedUsers];
    if (array != nil && [array count] > 0) {
        [self.contacts removeAllObjects];
        [self addDefault];
        //从存储器中取出我得好友数组，更新数据源
        
        [self installData:array];
    }
    
}

-(void)installData:(NSMutableArray *)array{
    for (XMPPUserMemoryStorageObject *user in array) {
        User *u = [User new];
        u.userId = user.jid.user;
        u.type = 1;
        if ([user isOnline]) {
            u.status = @"[在线]";
        } else {
            u.status = @"[离线]";
        }
        [self.contacts addObject:u];
    }
    [self.selfTable reloadData];
}

-(void)addDefault{
    User *u = [User new];
    u.type = 0;
    [self.contacts addObject:u];
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
