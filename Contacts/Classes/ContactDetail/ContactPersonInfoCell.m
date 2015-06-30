//
//  ContactPersonInfoCell.m
//  Contacts
//
//  Created by emma on 15/6/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ContactPersonInfoCell.h"

@implementation ContactPersonInfoCell
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
    
    [self generatePersonInfoCell];
    
    return self;
}

-(void)generatePersonInfoCell{
    
    CGFloat padding = 20;
    
    UILabel *nametitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding/2, 100, 20)];
    nametitleLabel.text = @"昵        称:";
    nametitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nametitleLabel];
    
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, padding/2, 200, 20)];
    NSString *nickname = _contact.name;
    nicknameLabel.text = nickname;
    nicknameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nicknameLabel];
    
    UILabel *truenametitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(nicknameLabel.frame) + 6, 100, 20)];
    truenametitleLabel.text = @"真实姓名:";
    truenametitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:truenametitleLabel];
    
    UILabel *truenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(nicknameLabel.frame) + 6, 200, 20)];
    NSString *truename = nil;
    truenameLabel.text = truename;
    truenameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:truenameLabel];
    
    
    UILabel *birthdaytitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(truenameLabel.frame) + 6, 100, 20)];
    birthdaytitleLabel.text = @"出生日期:";
    birthdaytitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:birthdaytitleLabel];
    
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(truenameLabel.frame) + 6, 200, 20)];
    NSString *birthday = nil;
    birthdayLabel.text = birthday;
    birthdayLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:birthdayLabel];
    
    UILabel *signaturetitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(birthdayLabel.frame) + 6, 100, 20)];
    signaturetitleLabel.text = @"个性签名:";
    signaturetitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:signaturetitleLabel];
    
    UILabel *signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(birthdayLabel.frame) + 6, 200, 20)];
    NSString *signature = @"啥都没有呢！！！！";
    signatureLabel.text = signature;
    signatureLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:signatureLabel];
    
    
    self.height = CGRectGetMaxY(signatureLabel.frame) + padding/2;
    
    
}


@end
