//
//  Face.h
//  MsgCell
//
//  Created by simple on 16/3/6.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface Face : NSObject
@property(nonatomic,assign)int sortID;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)UIImage *typeImage;
@end
