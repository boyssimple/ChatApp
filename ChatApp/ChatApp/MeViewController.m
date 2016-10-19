//
//  MeViewController.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "MeViewController.h"
#import "XMPPvCardTemp.h"


@interface MeViewController ()
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initBase{
    [super initBase];
    
    img = [UIImageView new];
    [img setImage:IMAGE(@"DefaultProfileHead")];
    img.layer.cornerRadius = 25;
    img.layer.masksToBounds = TRUE;
    img.userInteractionEnabled = TRUE;
    [self.view addSubview:img];
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick)];
    [img addGestureRecognizer:imgTap];
    
    img.sd_layout
    .widthIs(50)
    .heightIs(50)
    .topSpaceToView(self.view,15)
    .leftSpaceToView(self.view,15);
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    label.sd_layout
    .leftSpaceToView(img,10)
    .rightSpaceToView(self.view,10)
    .heightIs(15)
    .topSpaceToView(self.view,25);
    
    
    UIButton *exitBtn = [UIButton new];
    [exitBtn setBackgroundColor:RGB(241, 71, 4)];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.layer.cornerRadius = 3;
    exitBtn.titleLabel.font = FONT(FONTSIZE);
    [self.view addSubview:exitBtn];
    
    exitBtn.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .topSpaceToView(img,50)
    .heightIs(40);
    
    
    
    NSString *userName = [NSString stringWithFormat:@"%@@%@",[JKXMPPTool sharedInstance].user.userId,kXMPP_HOST];
    XMPPJID *jid = [XMPPJID jidWithString:userName resource:kXMPP_PlNTFORM];
    NSData *photoData = [[[JKXMPPTool sharedInstance] avatarModule] photoDataForJID:jid];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        img.image = headImg;
    }else{
        img.image = IMAGE(DefaultHeadImage);
    }
    label.text = [JKXMPPTool sharedInstance].user.userId;
}

-(void)exitAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)imgClick{
    // 让用户选择照片来源
    // * 用相机作为暗示按钮可以获取到更多的真实有效的照片
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"选择照片", nil];
    
    [sheet showInView:self.view];
}

#pragma mark - ActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // 1. 设置照片源，提示在模拟上不支持相机！
    if (buttonIndex == 0) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // 2. 允许编辑
    [picker setAllowsEditing:YES];
    // 3. 设置代理
    [picker setDelegate:self];
    // 4. 显示照片选择控制器
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 照片选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1. 设置头像
    UIImage *image = info[UIImagePickerControllerEditedImage];
    CGRect rect = img.bounds;
    
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    img.image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 2. 保存名片
    [self savevCard];
    
    // 3. 关闭照片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)savevCard{
    // 1. 获取电子名片
    XMPPvCardTemp *myCard = [[[JKXMPPTool sharedInstance] vCardModule] myvCardTemp];
    
    // 2. 设置名片内容
    myCard.photo = UIImagePNGRepresentation(img.image);
    myCard.title = @"hello";
    
    // 3. 保存电子名片
    XMPPvCardTempModule *vCardModule = [[JKXMPPTool sharedInstance] vCardModule];
    [vCardModule updateMyvCardTemp:myCard];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[JKXMPPTool sharedInstance]goOffLine];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"退出登录...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIViewController *main = [[UIStoryboard storyboardWithName:@"Login" bundle:nil]instantiateInitialViewController];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = main;
        });
    }
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid{
    MyLog(@"didReceivevCardTemp");
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    MyLog(@"xmppvCardTempModuleDidUpdateMyvCard");
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error{
    MyLog(@"xmppvCardTempModule");
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
