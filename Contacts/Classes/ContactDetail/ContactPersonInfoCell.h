//
//  ContactPersonInfoCell.h
//  Contacts
//
//  Created by emma on 15/6/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDetailCell.h"
#import "Contacts.h"

@interface ContactPersonInfoCell : ContactDetailCell

- (instancetype)init:(Contacts*)contact;
@end
