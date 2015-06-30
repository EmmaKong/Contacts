//
//  ViewController.h
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCell.h"

@interface ViewController : UIViewController<ContactCellDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    
    NSMutableArray *searchResults;
    UISearchBar *contactsSearchBar;
    UISearchDisplayController *searchDisplayController;

}


@end

