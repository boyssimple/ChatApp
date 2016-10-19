//
//  FaceView.h
//  MsgCell
//
//  Created by simple on 16/3/6.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceDelegate <NSObject>

@optional
-(void)selectFace:(int)faceTag;
-(void)send;
-(void)deleFace;
@end

@interface FaceView : UIView<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
}
@property(nonatomic,assign)id<FaceDelegate>delegate;
@end
