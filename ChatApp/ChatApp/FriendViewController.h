//
//  FriendViewController.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

@interface FriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *selfTable;
@property (nonatomic, retain) NSMutableArray *contacts;
@end
