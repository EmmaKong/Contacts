//
//  AddContactsViewController.h
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts.h"
#import "RecomendsCell.h"
#import "AddressBookViewController.h"

@interface AddContactsViewController : UIViewController<RecomendsCellDelegate,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AddressBookViewControllerDelegate>
{
    NSMutableArray *newsearchResults;
    UISearchDisplayController *newsearchDisplayController;
    
    UISearchBar *newcontactsSearchBar;

}


@property (weak, nonatomic) IBOutlet UITableView *recomended;

@property (nonatomic, retain) NSMutableArray   *recomendsArray;


@end
