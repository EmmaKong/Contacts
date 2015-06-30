//
//  ContactDetailCell.h
//  Contacts
//
//  Created by emma on 15/6/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetailCell : UITableViewCell

@property (nonatomic) CGFloat height;
@property (nonatomic, copy) dispatch_block_t actionBlock;

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style height:(CGFloat)height actionBlock:(dispatch_block_t)actionBlock;

@end
