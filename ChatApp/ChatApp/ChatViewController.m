//
//  ChatViewController.m
//  MsgCell
//
//  Created by zhouMR on 16/3/4.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "ChatViewController.h"
#import "MsgTableViewCell.h"
#import "Message.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface ChatViewController ()<XMPPStreamDelegate,MsgTableViewCellDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMain];
    [self addNotifition];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    [[JKXMPPTool sharedInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)initMain{
    array = [NSMutableArray new];
    msgTableView = [UITableView new];
    msgTableView.dataSource = self;
    msgTableView.delegate = self;
    msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [msgTableView setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
    msgTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
    [self.view addSubview:msgTableView];
    UITapGestureRecognizer *tableTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [msgTableView addGestureRecognizer:tableTap];
    
    
    inputBg = [[ChatInputView alloc]init];
    inputBg.delegate = self;
    [self.view addSubview:inputBg];
    
    //是否允许录音
    [self tipRecord];
}

-(void)addNotifition{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MsgTableViewCell";
    MsgTableViewCell *cell = (MsgTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [MsgTableViewCell new];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Message *msg = [array objectAtIndex:indexPath.row];
    [cell loadData:msg];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [inputBg hide];
    
}

-(void)showImage:(UIImageView*)view{

    MJPhoto *photo = [[MJPhoto alloc] init];
    
    
    photo.srcImageView = view;
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = @[photo];
    [browser show];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 1.缩回键盘
    [inputBg hide];
}

#pragma mark - 监听事件
- (void) keyboardWillChangeFrame:(NSNotification *)note{
    // 1.取得弹出后的键盘frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.键盘弹出的耗时时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 3.键盘变化时，view的位移，包括了上移/恢复下移
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        inputBg.transform = CGAffineTransformMakeTranslation(0, transformY-64);
        CGRect f = msgTableView.frame;
        if(transformY < 0){
            f.size.height = f.size.height+transformY;
        }else{
            f.size.height = self.view.frame.size.height-50;
        }
        msgTableView.frame = f;
        
        NSLog(@"%f",transformY);
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSString *msg = inputText.text;
        inputText.text = @"";
        NSLog(@"%@",msg);
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(int)randomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to-from + 1)));
}


#pragma mark - ChatInputDelegate
-(void)send:(NSString *)msg{
    XMPPJID *chatJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.toUser,kXMPP_HOST]];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:chatJID];
    [message addBody:msg];
    [[JKXMPPTool sharedInstance].xmppStream sendElement:message];
    
    Message *m = [Message new];
    m.content = msg;
    m.type = TEXT;
    m.from = ME;
    m.whoFrom = [JKXMPPTool sharedInstance].user.userId;
    [array addObject:m];
    [msgTableView reloadData];
    [self scrollToBottom];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.toUser,@"whoFrom",msg,@"content", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_MESSAGE_ADD object:dic];
}

//录制声音
-(void)recordStart{
    
    
    //按下录音
    if ([self canRecord]) {
        
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:playName] settings:recorderSettingsDict error:&error];
        
        if (recorder) {
            recorder.meteringEnabled = YES;
            [recorder prepareToRecord];
            [recorder record];
            
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            
        } else
        {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }
}


-(void)recordFinish{
    //松开 结束录音
    
    //录音停止
    [recorder stop];
    recorder = nil;
    //结束定时器
    [timer invalidate];
    timer = nil;
    [self playRecord];
}


- (void)tipRecord{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    playName = [NSString stringWithFormat:@"%@/play.aac",docDir];
    //录音设置
    recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                           [NSNumber numberWithInt:1000.0],AVSampleRateKey,
                           [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                           nil];
}

-(void)levelTimer:(NSTimer*)timer_
{
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    
//    if (lowPassResults>=0.8) {
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:7]];
//    }else if(lowPassResults>=0.7){
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:6]];
//    }else if(lowPassResults>=0.6){
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:5]];
//    }else if(lowPassResults>=0.5){
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:4]];
//    }else if(lowPassResults>=0.4){
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:3]];
//    }else if(lowPassResults>=0.3){
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:2]];
//    }else if(lowPassResults>=0.2){
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:1]];
//    }else if(lowPassResults>=0.1){
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:0]];
//    }else{
//        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:0]];
//    }
    
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}


-(void)playRecord{
    NSError *playerError;
    
    //播放
    player = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:playName] error:&playerError];
    
    if (player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }else{
        [player play];
    }
}

//滚动到最下方
-(void)scrollToBottom{
    if (array.count > 0) {
        [msgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:array.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

-(void)closeKeyboard{
    [inputBg hide];
}

#pragma mark - 选择图片
- (void)selectImg{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - imgPickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(image,0.3);
    
    [self sendMessageWithData:data bodyName:@"image"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 发送二进制文件 */
- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name
{
    XMPPJID *chatJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.toUser,kXMPP_HOST]];
    XMPPMessage *message = [XMPPMessage messageWithType:@"image" to:chatJID];
    
    [message addBody:name];
    
    // 转换成base64的编码
    NSString *base64str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // 设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
    
    // 包含子节点
    [message addChild:attachment];
    
    // 发送消息
    [[JKXMPPTool sharedInstance].xmppStream sendElement:message];
    
    

    Message *m = [Message new];
    m.content = base64str;
    m.type = IMAGE;
    m.whoFrom =  [JKXMPPTool sharedInstance].user.userId;
    m.from = ME;
    [array addObject:m];
    [msgTableView reloadData];
    [self scrollToBottom];

}


#pragma mark - Message
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *from = message.from.bare;
    if ([from isEqualToString:kXMPP_HOST]) {
        from = SYSTEMINFO;
    }else{
        NSRange range = [from rangeOfString:@"@"];
        from = [from substringToIndex:range.location];//截取范围类的字符串
    }
    if ([self.toUser isEqualToString:from]) {
        if ([message.type isEqualToString:@"chat"]) {
            Message *m = [Message new];
            m.content = message.body;
            m.type = TEXT;
            m.whoFrom = from;
            m.from = OTHER;
            [array addObject:m];
            [msgTableView reloadData];
            [self scrollToBottom];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:from,@"whoFrom",message.body,@"content", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_MESSAGE_ADD object:dic];
        }else if([message.type isEqualToString:@"image"]){
            NSString *content;
            for (XMPPElement *node in message.children) {
                if ([node.name isEqualToString:@"attachment"]) {
                    content = node.stringValue;
                    break;
                }
                
            }
            Message *m = [Message new];
            m.content = content;
            m.type = IMAGE;
            m.whoFrom = from;
            m.from = OTHER;
            [array addObject:m];
            [msgTableView reloadData];
            [self scrollToBottom];
        }
        
        NSLog(@"type:--%@",message.type);
    }
}


- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didSucceedWithData:(NSData *)data named:(NSString *)name
{
    NSLog(@"%s  %@",__FUNCTION__,data);
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
