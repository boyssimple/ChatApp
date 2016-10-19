//
//  ChatViewController.h
//  MsgCell
//
//  Created by zhouMR on 16/3/4.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
#import "ChatInputView.h"
#import <AVFoundation/AVFoundation.h>

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ChatInputDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *msgTableView;
    UITextView *inputText;
    
    NSMutableArray *array;
    
    ChatInputView *inputBg;
    
    
    
    //录音器
    AVAudioRecorder *recorder;
    //播放器
    AVAudioPlayer *player;
    NSDictionary *recorderSettingsDict;
    //定时器
    NSTimer *timer;
    double lowPassResults;
    //录音名字
    NSString *playName;
}
@property(nonatomic,strong)NSString *toUser;
@end
