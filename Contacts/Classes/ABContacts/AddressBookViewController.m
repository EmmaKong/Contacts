//
//  AddressBookViewController.m
//  Contacts
//
//  Created by emma on 15/6/25.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "AddressBookViewController.h"
#import "NSString+TKUtilities.h"
#import "UIImage+TKUtilities.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "Contacts.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
@synthesize savedSearchTerm = _savedSearchTerm;
@synthesize savedScopeButtonIndex = _savedScopeButtonIndex;
@synthesize searchWasActive = _searchWasActive;
//@synthesize ABsearchBar = _ABsearchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _listContent = [NSMutableArray new];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录朋友";
    
    
    ABsearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    ABsearchBar.delegate = self;
    [ABsearchBar setPlaceholder:@"搜索"];
    ABsearchBar.keyboardType = UIKeyboardTypeDefault;
    
    ABsearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:ABsearchBar contentsController:self];
    ABsearchDisplayController.active = NO;
    ABsearchDisplayController.searchResultsDataSource = self;
    ABsearchDisplayController.searchResultsDelegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = ABsearchBar;
    
    [self.view addSubview:self.tableView];

    
    // Create addressbook data model
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, &error);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    

    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        ABAddressBook *addressBook = [[ABAddressBook alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        addressBook.rowSelected = NO;   // addressbook 某一行是否被选中
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,  // 电话
            kABPersonEmailProperty   // 邮件
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = [(__bridge NSString*)value initTelephoneWithReformat];
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        [addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    CFRelease(allPeople);
    CFRelease(addressBooks);
    
    // 对数据进行排序，并按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (ABAddressBook *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
        
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (ABAddressBook *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [_listContent addObject:sortedSection];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

//  首字母 索引，title
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return nil;
//    } else {
//        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
//                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [_listContent count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredListContent count];
    } else {
        return [[_listContent objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"ControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ABAddressBook *addressBook = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        addressBook = (ABAddressBook *)[_filteredListContent objectAtIndex:indexPath.row];
    else
        addressBook = (ABAddressBook *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[addressBook.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.textLabel.text = addressBook.name;
    } else {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:cell.textLabel.font.pointSize];
        cell.textLabel.text = @"No Name";
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(30.0, 0.0, 40, 28)];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.tag = indexPath.row;
    [button setTitle:@"添加" forState:UIControlStateNormal];

    [button addTarget:self action:@selector(AddButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = button;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self tableView:self.searchDisplayController.searchResultsTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    
    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ABAddressBook *addressBook = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        addressBook = (ABAddressBook*)[_filteredListContent objectAtIndex:indexPath.row];
    else
        addressBook = (ABAddressBook*)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    BOOL checked = !addressBook.rowSelected;
    addressBook.rowSelected = checked;
    
    
    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    [button setSelected:checked];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)AddButtonTapped:(UIButton *)Btn event:(id)event
{
    
    ABAddressBook *addressbook = _listContent[Btn.tag];
    //第一步注册通知
    Contacts *newcontact = [[Contacts alloc] init];
    
    newcontact.name = addressbook.name;
    newcontact.sectionNumber = addressbook.sectionNumber;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addcontactNotification" object:newcontact];
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

#pragma mark -
#pragma mark Save action

//- (IBAction)saveAction:(id)sender
//{
//    NSMutableArray *objects = [NSMutableArray new];
//    for (NSArray *section in _listContent) {
//        for (AddressBook *addressBook in section)
//        {
//            if (addressBook.rowSelected)
//                [objects addObject:addressBook];
//        }
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(contactsMultiPickerController:didFinishPickingDataWithInfo:)])
//        [self.delegate contactsMultiPickerController:self didFinishPickingDataWithInfo:objects];
//    
//}
//
//- (IBAction)dismissAction:(id)sender
//{
//    if ([self.delegate respondsToSelector:@selector(contactsMultiPickerControllerDidCancel:)])
//        [self.delegate contactsMultiPickerControllerDidCancel:self];
//    else
//        [self dismissViewControllerAnimated:YES completion:nil];
//}

//#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _filteredListContent = [[NSMutableArray alloc]init];

    if (ABsearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:ABsearchBar.text]) {
        for (NSArray *section in _listContent) {
            for (ABAddressBook *addressBook in section)
            {

                if ([ChineseInclude isIncludeChineseInString:addressBook.name]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:addressBook.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:ABsearchBar.text options:NSCaseInsensitiveSearch];
                
                    if (titleResult.length>0) {
                        [_filteredListContent  addObject:addressBook];
                    }
                    else {
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:addressBook.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:ABsearchBar.text options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0) {
                            [_filteredListContent  addObject:addressBook];
                        }
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:addressBook.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:ABsearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [_filteredListContent  addObject:addressBook];
                    }
                }
                else {
                    NSRange titleResult=[addressBook.name rangeOfString:ABsearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_filteredListContent  addObject:addressBook];
                    }
                }
            }
        }
    } else if (ABsearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:ABsearchBar.text]) {
        
        for (NSArray *section in _listContent) {
            for (ABAddressBook *addressBook in section)
            {
        
                NSString *tempStr = addressBook.name;
                NSRange titleResult=[tempStr rangeOfString:ABsearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_filteredListContent addObject:addressBook];
                }
            
            }
        }
    }
    
}



@end
