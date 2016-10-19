//
//  ChatInputView.m
//  MsgCell
//
//  Created by simple on 16/3/6.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "ChatInputView.h"

@implementation ChatInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50-64, [UIScreen mainScreen].bounds.size.width, 50)];
    
    if (self) {
        //输入文本框
        [self setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
        
        UIView *line = [UIView new];
        [line setBackgroundColor:[UIColor colorWithRed:218/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
        line.frame = CGRectMake(0, 0, self.frame.size.width, 1);
        [self addSubview:line];
        
        self.recordImg = [UIButton new];
        [self.recordImg setImage:IMAGE(@"ChatRecordIcon") forState:UIControlStateNormal];
        self.recordImg.frame = CGRectMake(5, (self.frame.size.height-30)/2.0, 30, 30);
        
        [self.recordImg addTarget:self action:@selector(recordKeyboardChange) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.recordImg];
        
        
        
        inputText = [UITextView new];
        inputText.frame = CGRectMake(self.recordImg.frame.origin.x+self.recordImg.frame.size.width+5, self.recordImg.frame.origin.y, self.frame.size.width-(self.recordImg.frame.origin.x+self.recordImg.frame.size.width+5)-75, 30);
        inputText.layer.borderColor = [UIColor colorWithRed:218/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
        inputText.layer.borderWidth = 1;
        inputText.returnKeyType  = UIReturnKeySend;
        inputText.layer.cornerRadius = 6;
        inputText.delegate = self;
        [self addSubview:inputText];
        
        self.btnRecord = [UIButton new];
        [self.btnRecord setTitle:@"按住说话" forState:UIControlStateNormal];
        [self.btnRecord setTitle:@"松开结束" forState:UIControlStateHighlighted];
        self.btnRecord.frame = CGRectMake(inputText.frame.origin.x, inputText.frame.origin.y, inputText.frame.size.width, inputText.frame.size.height);
        self.btnRecord.layer.borderColor = [UIColor colorWithRed:218/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
        self.btnRecord.layer.borderWidth = 1;
        self.btnRecord.layer.cornerRadius = 6;
        self.btnRecord.hidden = TRUE;
        [self.btnRecord setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnRecord addTarget:self action:@selector(recordUpAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRecord addTarget:self action:@selector(recordDownAction) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.btnRecord];
        
        UIImageView *faceImg = [UIImageView new];
        [faceImg setImage:[UIImage imageNamed:@"ChatFaceIcon"]];
        faceImg.frame = CGRectMake(inputText.frame.origin.x+inputText.frame.size.width+5, self.recordImg.frame.origin.y, 30, 30);
        faceImg.userInteractionEnabled = TRUE;
        UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFace)];
        [faceImg addGestureRecognizer:faceTap];
        [self addSubview:faceImg];
        
        UIImageView *addImg = [UIImageView new];
        [addImg setImage:[UIImage imageNamed:@"ChatAddIcon"]];
        addImg.frame = CGRectMake(faceImg.frame.origin.x+faceImg.frame.size.width+5, self.recordImg.frame.origin.y, 30, 30);
        addImg.userInteractionEnabled = TRUE;
        UITapGestureRecognizer *addImgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgAction)];
        [addImg addGestureRecognizer:addImgTap];
        [self addSubview:addImg];
    }
    
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSString *msg = inputText.text;
        inputText.text = @"";
        [self sendMsg:msg];
        NSLog(@"%@",msg);
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)hide{
    [inputText endEditing:TRUE];
    [self hideFaceAnimation];
}

-(void)showFace{
    [inputText endEditing:YES];
    if (faceView == nil) {
        faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 200)];
        faceView.delegate = self;
        [self addSubview:faceView];
    }
    [self showFaceAnimation];
}

-(void)showFaceAnimation{
    if (!showFace) {
        CGRect f = self.frame;
        f.size.height += faceView.frame.size.height;
        self.frame = f;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -faceView.frame.size.height);
        }completion:^(BOOL finished) {
            showFace = TRUE;
        }];
    }
    
}


-(void)hideFaceAnimation{
    if (showFace) {
        CGRect f = self.frame;
        f.size.height -= faceView.frame.size.height;
        self.frame = f;
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            showFace = FALSE;
        }];
    }
    
}

-(void)selectFace:(int)faceTag{
    inputText.text = [NSString stringWithFormat:@"%@[%d]",inputText.text,faceTag];
}

#pragma mark delegate代理
-(void)send{
    [self sendMsg:inputText.text];
    inputText.text = @"";
}

//发送事件
-(void)sendMsg:(NSString *)msg{
    if ([self.delegate respondsToSelector:@selector(send:)]) {
        [self.delegate send:msg];
    }
}

//录音按下
-(void)recordUpAction{
    if ([self.delegate respondsToSelector:@selector(recordFinish)]) {
        [self.delegate recordFinish];
    }
}

//录音按下后抬起
-(void)recordDownAction{
    if ([self.delegate respondsToSelector:@selector(recordStart)]) {
        [self.delegate recordStart];
    }
}

//键盘和录音切换
-(void)recordKeyboardChange{
    if (isKeyboard) {
        [self.recordImg setImage:IMAGE(@"ChatKeyboardIcon") forState:UIControlStateNormal];
        self.btnRecord.hidden = TRUE;
        inputText.hidden = FALSE;
        [inputText becomeFirstResponder];
    }else{
        [self.recordImg setImage:IMAGE(@"ChatRecordIcon") forState:UIControlStateNormal];
        self.btnRecord.hidden = FALSE;
        inputText.hidden = TRUE;
        [self hide];
    }
    isKeyboard = !isKeyboard;
}

//删除表情
-(void)deleFace{
    NSString *cccc = [inputText.text substringToIndex:[inputText.text length] - 4];
    inputText.text = cccc;
}

//选择图片
- (void)selectImgAction{
    if ([self.delegate respondsToSelector:@selector(selectImg)]) {
        [self.delegate selectImg];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    showFace = FALSE;
    return  TRUE;
}
@end
