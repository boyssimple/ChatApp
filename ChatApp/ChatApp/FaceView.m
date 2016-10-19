//
//  FaceView.m
//  MsgCell
//
//  Created by simple on 16/3/6.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "FaceView.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define FACE_SEND_BTN @"发送"
@implementation FaceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:RGB(248,248,248)];
        UIScrollView *faceScrollView = [UIScrollView new];
        faceScrollView.pagingEnabled = TRUE;
        faceScrollView.delegate = self;
        faceScrollView.bounces = FALSE;
        faceScrollView.showsHorizontalScrollIndicator = FALSE;
        faceScrollView.showsVerticalScrollIndicator = FALSE;
        faceScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-50);
        [self addSubview:faceScrollView];
        //计算多少列
        int col = faceScrollView.frame.size.width/34;
        CGFloat ox = (faceScrollView.frame.size.width-col*24.0)/(col+1);
        
        //计算一页有多少行
        int row = faceScrollView.frame.size.height/34;
        
        int total = 104;
        int page = total/(col * row-1);
        if (total%(col * row) != 0) {
            page ++;
        }
        NSLog(@"多少：%d",page);
        
        for(int i=0;i < page;i++){
            UIView *bg = [UIView new];
            bg.frame = CGRectMake(i*faceScrollView.frame.size.width, 0, faceScrollView.frame.size.width, faceScrollView.frame.size.height);
            [faceScrollView addSubview:bg];
            
            //分享标题
            CGFloat y = 10;
            int x = 0;
            int n = row *col;
            if (i == page-1) {
                n = total-i*(row*col);
            }
            
            for(int j=0;j<n;j++){
                int c = j / col;
                
                NSString *url = [NSString stringWithFormat:@"%d",(i+1)*j];
                if (j == n-1) {
                    url = @"ChatFaceDelete";
                }
                UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:url]];
                image.frame = CGRectMake((x+1)*ox+x*24, c*24+c*10+y, 24, 24);
                if ([url isEqualToString:@"ChatFaceDelete"]) {
                    image.tag = 10000;
                }else{
                    image.tag = (i+1)*j;
                }
                image.userInteractionEnabled = TRUE;
                UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFace:)];
                [image addGestureRecognizer:imageTap];
                [bg addSubview:image];
                x++;
                if (x >= col) {
                    x = 0;
                }
            }
        }
        faceScrollView.contentSize = CGSizeMake(faceScrollView.frame.size.width*page, faceScrollView.contentSize.height);
        
        pageControl = [[UIPageControl alloc]init];
        pageControl.numberOfPages = page;
        pageControl.currentPage = 0;
        pageControl.currentPageIndicatorTintColor = RGB(139, 139, 139);
        pageControl.pageIndicatorTintColor = RGB(187, 187, 187);
        pageControl.frame = CGRectMake((faceScrollView.frame.size.width-100)/2.0, faceScrollView.frame.size.height+5, 100, 10);
        [self addSubview:pageControl];
        
        UIView *bottomBg = [UIView new];
        bottomBg.frame = CGRectMake(0, pageControl.frame.origin.y+pageControl.frame.size.height+5, self.frame.size.width, 30);
        [bottomBg setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:bottomBg];
        
        //添加
        UIImageView *faceAdd = [UIImageView new];
        [faceAdd setImage:[UIImage imageNamed:@"ChatFaceAdd"]];
        [faceAdd setBackgroundColor:RGB(246,246,246)];
        faceAdd.frame = CGRectMake(10, (bottomBg.frame.size.height-24)/2.0, 24, 24);
        [bottomBg addSubview:faceAdd];
        
        UIImageView *faceOne = [UIImageView new];
        [faceOne setImage:[UIImage imageNamed:@"1"]];
        [faceOne setBackgroundColor:RGB(246,246,246)];
        faceOne.frame = CGRectMake(faceAdd.frame.origin.x+faceAdd.frame.size.width+10, (bottomBg.frame.size.height-24)/2.0, 24, 24);
        [bottomBg addSubview:faceOne];
        
        //发送
        UIButton *sendBtn = [UIButton new];
        [sendBtn setTitle:FACE_SEND_BTN forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:[UIColor whiteColor]];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sendBtn.frame = CGRectMake(bottomBg.frame.size.width-50, 0, 50, bottomBg.frame.size.height);
        [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [bottomBg addSubview:sendBtn];
    }
    return self;
}

#pragma mark ------- 显示当前index
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    NSLog(@"当前页：%d",page);
    pageControl.currentPage = page;
}

-(void)clickFace:(UIGestureRecognizer*)ges{
    if (ges.view.tag != 10000) {
        if ([self.delegate respondsToSelector:@selector(selectFace:)]) {
            [self.delegate selectFace:(int)ges.view.tag];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(deleFace)]) {
            [self.delegate deleFace];
        }
    }
    
}

-(void)send{
    if ([self.delegate respondsToSelector:@selector(send)]) {
        [self.delegate send];
    }
}

@end
