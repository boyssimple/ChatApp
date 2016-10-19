//
//  MessageViewController.h
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//


@interface MessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *messages;
}
@property (weak, nonatomic) IBOutlet UITableView *selfTable;
@end
