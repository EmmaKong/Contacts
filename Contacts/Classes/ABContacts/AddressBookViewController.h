//
//  AddressBookViewController.h
//  Contacts
//
//  Created by emma on 15/6/25.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <malloc/malloc.h>
#import "ABAddressBook.h"

@class ABAddressBook, AddressBookViewController;
@protocol AddressBookViewControllerDelegate <NSObject>
@required


@end


@interface AddressBookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    id _delegate;
    
    NSUInteger _selectedCount;
    NSMutableArray *_listContent;  //   本地通讯录数据
    NSMutableArray *_filteredListContent;  // search result 数据
    UISearchBar *ABsearchBar;
    UISearchDisplayController *ABsearchDisplayController;

}

@property (nonatomic, retain) id<AddressBookViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;


@end
