//
//  ContactSchoolInfoCell.m
//  Contacts
//
//  Created by emma on 15/6/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ContactSchoolInfoCell.h"

@implementation ContactSchoolInfoCell
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
    
    [self generateSchoolInfoCell];
    
    return self;
}

-(void)generateSchoolInfoCell{
    
    CGFloat padding = 20;
    
    UILabel *schooltitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding/2, 100, 20)];
    schooltitleLabel.text = @"学        校:";
    schooltitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:schooltitleLabel];
    
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, padding/2, 150, 20)];
    NSString *school = nil;
    schoolLabel.text = school;
    schoolLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:schoolLabel];
    
    UILabel *departtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(schoolLabel.frame) + 6, 100, 20)];
    departtitleLabel.text = @"院        系:";
    departtitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:departtitleLabel];
    
    UILabel *departLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(schoolLabel.frame) + 6, 150, 20)];
    NSString *depart = nil;
    departLabel.text = depart;
    departLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:departLabel];
    
    
    UILabel *timegotoschooltitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(departLabel.frame) + 6, 100, 20)];
    timegotoschooltitleLabel.text = @"入学年份:";
    timegotoschooltitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:timegotoschooltitleLabel];
    
    UILabel *timegotoschoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(departLabel.frame) + 6, 150, 20)];
    NSString *timegotoschool = nil;
    timegotoschoolLabel.text = timegotoschool;
    timegotoschoolLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:timegotoschoolLabel];
    
    UILabel *dormtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(timegotoschoolLabel.frame) + 6, 100, 20)];
    dormtitleLabel.text = @"宿        舍:";
    dormtitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:dormtitleLabel];
    
    UILabel *dormLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(timegotoschoolLabel.frame) + 6, 150, 20)];
    NSString *dorm = nil;
    dormLabel.text = dorm;
    dormLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:dormLabel];
    
    
    self.height = CGRectGetMaxY(dormLabel.frame) + padding/2;
    
    
}


@end
