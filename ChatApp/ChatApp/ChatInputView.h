//
//  ChatInputView.h
//  MsgCell
//
//  Created by simple on 16/3/6.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FaceView.h"

@protocol ChatInputDelegate <NSObject>

@optional
-(void)send:(NSString *)msg;
-(void)recordStart;
-(void)recordFinish;
-(void)selectImg;
@end

@interface ChatInputView : UIView<UITextViewDelegate,FaceDelegate>
{
    UITextView *inputText;
    FaceView *faceView;
    BOOL showFace;
    BOOL isKeyboard;
}

-(void)hide;

@property(nonatomic,assign)id<ChatInputDelegate>delegate;
@property (nonatomic, strong) UIButton *recordImg;
@property (nonatomic, strong) UIButton *btnRecord;
@end
