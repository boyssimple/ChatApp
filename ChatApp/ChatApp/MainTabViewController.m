//
//  MainTabViewController.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "MainTabViewController.h"
#import "ChatViewController.h"
#import "MessageViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    //用于传递用户id
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toChatAction:) name:XMPP_USER_CHATTING object:nil];
    
    //badge数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeShow:) name:XMPP_BADGE object:nil];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    MyLog(@"%@",viewController.title);
    self.navigationItem.title = viewController.title;
    if([viewController.title isEqualToString:@"好友"]){
        UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
        right.tag = 1010;
        [right setFrame:CGRectMake(0, 12, 50, 15)];
        [right setTitle:@"添加" forState:UIControlStateNormal];
        right.titleLabel.font = FONT(FONTSIZE+2);
        right.contentEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
        right.titleLabel.textAlignment = NSTextAlignmentRight;
        [right addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark ------ 跳转到添加好友视图
-(void)addUser{
    MyLog(@"hello");
    [self performSegueWithIdentifier:@"addFriend" sender:nil];
}

#pragma mark ------ 跳转到聊天视图
-(void)toChatAction:(NSNotification*)noti{
    toUserId = noti.object;
    [self performSegueWithIdentifier:@"toChatting" sender:nil];
}

#pragma mark ------ 显示badge数量
-(void)badgeShow:(NSNotification*)noti{
    NSArray *array = self.viewControllers;
    NSDictionary *dic = noti.object;
    for (UIViewController *vc in array) {
        if([vc isKindOfClass:[MessageViewController class]] && [[dic objectForKey:@"typeClass"] isEqualToString:@"1"]){
            if ([[dic objectForKey:@"count"]intValue] == 0) {
                vc.tabBarItem.badgeValue = nil;
            }else{
                vc.tabBarItem.badgeValue = [dic objectForKey:@"count"];
            }
            
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addFriend"]) {
        
    }else if([[segue identifier] isEqualToString:@"toChatting"]){
        ChatViewController *chat = [segue destinationViewController];
        chat.toUser = toUserId;
        chat.title = toUserId;
    }
    
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
