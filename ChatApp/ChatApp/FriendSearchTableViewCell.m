//
//  FriendSearchTableViewCell.m
//  ChatApp
//
//  Created by zhouMR on 16/3/3.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "FriendSearchTableViewCell.h"

@implementation FriendSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITextField *searchText = [UITextField new];
        [searchText setBackgroundColor:RGB(244, 244, 244)];
        searchText.placeholder = @"搜索";
        searchText.font = FONT(FONTSIZE);
        searchText.textAlignment = NSTextAlignmentCenter;
        searchText.layer.cornerRadius = RoundValue;
        [self addSubview:searchText];
        
        searchText.sd_layout
        .leftSpaceToView(self,5)
        .rightSpaceToView(self,5)
        .topSpaceToView(self,5)
        .bottomSpaceToView(self,5);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
