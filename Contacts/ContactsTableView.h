//
//  ContactsTableView.h
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsTableViewDelegate;



@interface ContactsTableView : UIView

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) id<ContactsTableViewDelegate> delegate;
- (void)reloadData;


@end

@protocol ContactsTableViewDelegate <UITableViewDataSource,UITableViewDelegate>

- (NSArray *)sectionIndexTitlesForABELTableView:(ContactsTableView *)tableView;


@end