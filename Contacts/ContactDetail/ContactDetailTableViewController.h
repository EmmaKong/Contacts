//
//  ContactDetailTableViewController.h
//  Contacts
//
//  Created by emma on 15/6/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDetailSection.h"
#import "ContactDetailCell.h"


@interface ContactDetailTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *sections;

@end
