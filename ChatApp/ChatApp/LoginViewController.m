//
//  LoginViewController.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = TRUE;
    [self.view setBackgroundColor:APPCOLOR];
    
    UIImageView *logoImg = [UIImageView new];
    [logoImg setImage:IMAGE(@"LoginLogo")];
    [self.view addSubview:logoImg];
    
    logoImg.sd_layout
    .widthIs(113)
    .heightIs(110)
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,100);
    
    //用户名、密码背景
    
    UIView *bg = [UIView new];
    [bg setBackgroundColor:WhiteColor];
    bg.layer.cornerRadius = RoundValue;
    bg.layer.masksToBounds = TRUE;
    [self.view addSubview:bg];
    
    bg.sd_layout
    .topSpaceToView(logoImg,30)
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .heightIs(93);
    
    UILabel *userLabel = [UILabel new];
    userLabel.text = @"帐号：";
    userLabel.textColor = RGB(164, 164, 164);
    userLabel.font = FONT(FONTSIZE);
    
    userText = [UITextField new];
    userText.delegate = self;
    
    UIView *line = [UIView new];
    [line setBackgroundColor:RGB(164, 164, 164)];
    
    UILabel *pwdLabel = [UILabel new];
    pwdLabel.text = @"密码：";
    pwdLabel.textColor = RGB(164, 164, 164);
    pwdLabel.font = FONT(FONTSIZE);
    
    pwdText = [UITextField new];
    pwdText.delegate = self;
    pwdText.secureTextEntry = TRUE;
    
    [bg addSubview:userLabel];
    [bg addSubview:userText];
    [bg addSubview:line];
    [bg addSubview:pwdLabel];
    [bg addSubview:pwdText];
    
    userLabel.sd_layout
    .heightIs(46)
    .widthIs(60)
    .leftSpaceToView(bg,15);
    
    userText.sd_layout
    .heightIs(46)
    .leftSpaceToView(userLabel,0)
    .rightSpaceToView(bg,15);
    
    line.sd_layout
    .heightIs(0.5)
    .leftSpaceToView(bg,10)
    .rightSpaceToView(bg,10)
    .topSpaceToView(userLabel,0);
    
    pwdLabel.sd_layout
    .heightIs(46)
    .widthIs(60)
    .leftSpaceToView(bg,15)
    .topSpaceToView(line,0);
    
    pwdText.sd_layout
    .heightIs(46)
    .leftSpaceToView(pwdLabel,0)
    .rightSpaceToView(bg,15)
    .topEqualToView(pwdLabel);
    
    //登录按钮
    UIButton *loginBtn = [UIButton new];
    [loginBtn setBackgroundColor:RGB(4, 241, 189)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = RoundValue;
    loginBtn.titleLabel.font = FONT(FONTSIZE);
    [self.view addSubview:loginBtn];
    
    loginBtn.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .topSpaceToView(bg,30)
    .heightIs(40);
    
    //读取沙盒
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    NSString *userPassword = [user objectForKey:@"userPassword"];
    if (userName != nil) {
        userText.text = userName;
    }
    if (userPassword != nil) {
        pwdText.text = userPassword;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kLOGIN_SUCCESS object:nil];
}

-(void)loginAction{
    NSString *username = userText.text;
    NSString *password = pwdText.text;
    
    NSString *message = nil;
    if (username.length < 3) {
        message = @"用户名不能少于6位";
    } else if (password.length < 6) {
        message = @"密码不能少于6位";
    }
    
    if (message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    } else {
        //登录
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"登录中...";
        [[JKXMPPTool sharedInstance] loginWithJID:[XMPPJID jidWithUser:username domain:kXMPP_HOST resource:kXMPP_PlNTFORM] andPassword:password];
    }
}

#pragma mark - notification event
- (void)loginSuccess
{
    //存入沙盒
    NSString *username = userText.text;
    NSString *password = pwdText.text;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:@"userName"];
    [userDefaults setObject:password forKey:@"userPassword"];
    [userDefaults synchronize];
    
    User *user = [JKXMPPTool sharedInstance].user;
    user.userId = username;
    [JKXMPPTool sharedInstance].user = user;
    
    NSLog(@"loginSuccess");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIViewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = main;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [userText resignFirstResponder];
    [pwdText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
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
