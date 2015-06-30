//
//  ContactHeadCell.m
//  Contacts
//
//  Created by emma on 15/6/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ContactHeadCell.h"

@implementation ContactHeadCell
{
    Contacts *_contact;
}

- (instancetype)init:(Contacts *)contact
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _contact = contact;
    
    [self generateHeadCell];
    
    return self;
}

-(void)generateHeadCell{
    
    CGFloat padding = 20;
    
    UIImageView *headbgimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    headbgimageview.image = [UIImage imageNamed:@"note_bg.png"];
    headbgimageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:headbgimageview];
    
    UIImageView *headimageview = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-105)/2, 98, 108, 105)];
    headimageview.image = [UIImage imageNamed:@"touxiang2.png"];
    headimageview.contentMode = UIViewContentModeScaleAspectFill;
    headimageview.layer.masksToBounds = YES;
    headimageview.layer.cornerRadius = 50;
    [self.contentView addSubview:headimageview];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-120)/2, CGRectGetMaxY(headimageview.frame)+ 15, 120, 20)];
    NSString *name = _contact.name;
    titleLabel.text = name;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:titleLabel];
    
    self.height = CGRectGetMaxY(titleLabel.frame) + padding/2;

    
}



@end
