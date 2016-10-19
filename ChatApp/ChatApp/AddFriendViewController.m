//
//  AddFriendViewController.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initBase{
    [super initBase];
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"帐号：";
    nameLabel.font = FONT(FONTSIZE);
    [self.view addSubview:nameLabel];
    
    nameLabel.sd_layout
    .widthIs(45)
    .heightIs(15)
    .leftSpaceToView(self.view,10)
    .topSpaceToView(self.view,50);
    
    nameText = [UITextField new];
    nameText.placeholder = @" 好友帐号";
    nameText.font = FONT(FONTSIZE);
    nameText.layer.borderColor = RGB(189, 189, 189).CGColor;
    nameText.layer.borderWidth = 0.5;
    nameText.layer.cornerRadius = RoundValue;
    [self.view addSubview:nameText];
    
    nameText.sd_layout
    .leftSpaceToView(nameLabel,5)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(self.view,42)
    .heightIs(30);
    
    UIButton *addBtn = [UIButton new];
    [addBtn setBackgroundColor:APPCOLOR];
    [addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    addBtn.layer.cornerRadius = RoundValue;
    addBtn.titleLabel.font = FONT(FONTSIZE);
    [self.view addSubview:addBtn];
    
    addBtn.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(nameLabel,30)
    .heightIs(40);
}

-(void)addAction{
    [self hideKeyBoard];
    NSString *username = nameText.text;
    if(username.length <= 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"帐号不能为空" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"添加好友...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[JKXMPPTool sharedInstance]addFriendById:username];
        });
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyBoard];
}

-(void)hideKeyBoard{
    [nameText resignFirstResponder];
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
