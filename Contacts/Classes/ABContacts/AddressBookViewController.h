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

//- (void)contactsMultiPickerController:(AddressBookViewController*)picker didFinishPickingDataWithInfo:(NSArray*)data;
//- (void)contactsMultiPickerControllerDidCancel:(AddressBookViewController*)picker;
@end


@interface AddressBookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSUInteger _selectedCount;
    NSMutableArray *_listContent;
    NSMutableArray *_filteredListContent;
   // UISearchBar *ABSearchBar;
    UISearchDisplayController *ABsearchDisplayController;

}

@property (nonatomic, retain) id<AddressBookViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *ABsearchBar;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;


@end
