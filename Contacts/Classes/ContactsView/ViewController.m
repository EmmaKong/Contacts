//
//  ViewController.m
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "ContactsTableView.h"
#import "AddContactsViewController.h"
#import "ContactDetailViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "Contacts.h"
#import "ContactCell.h"
#import "PinYinForObjc.h"

@interface ViewController ()<ContactsTableViewDelegate>

@property (nonatomic, strong) ContactsTableView *contactTableView;
@property (nonatomic, strong) NSMutableArray *contactArraytemp; //从数据库读取的contacts数据
@property (nonatomic, strong) NSMutableArray *allArray;  // 包含空数据的contactsArray
@property (nonatomic, strong) NSMutableArray *dataSource;  // 核心数据
@property (nonatomic, strong) NSMutableArray *indexTitles;

@end

@implementation ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 创建tableView
- (void) createTableView {
    self.contactTableView = [[ContactsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.contactTableView.delegate = self;
    self.contactTableView.tableView.tableHeaderView = contactsSearchBar;
    [self.view addSubview:self.contactTableView];
}

- (void) reloadTableView {
    self.contactTableView = [[ContactsTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.contactTableView.delegate = self;
    self.contactTableView.tableView.tableHeaderView = contactsSearchBar;
    [self.view addSubview:self.contactTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人";
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.contactArraytemp = [[NSMutableArray alloc] init];
    self.allArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    
    contactsSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    contactsSearchBar.delegate = self;
    [contactsSearchBar setPlaceholder:@"搜索联系人"];
    contactsSearchBar.keyboardType = UIKeyboardTypeDefault;
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:contactsSearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;

    [self performSelector:@selector(loadLocalData)];
    
    [self createTableView];
    
    // 左侧 添加联系人按钮
    UIButton *addcontactsButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    addcontactsButton.frame = CGRectMake(0, 0, 30, 30);
   // addcontactsButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
   // addcontactsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addcontactsButton setTitle:@"添加" forState:UIControlStateNormal];
    [addcontactsButton addTarget:self action:@selector(addcontactsAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addcontactsItem = [[UIBarButtonItem alloc] initWithCustomView:addcontactsButton];
    self.navigationItem.rightBarButtonItem = addcontactsItem;
    
    // 添加通知中心, 添加联系人
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addnewcontact:) name:@"addcontactNotification" object:nil];
    

}

- (void)loadLocalData
{

    // json数据解析
    NSString *contactPath = [[NSBundle mainBundle] pathForResource:@"contacts1" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:contactPath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.contactArraytemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        Contacts *contact = [[Contacts alloc] initWithPropertiesDictionary:array[i]];
        [self.contactArraytemp addObject:contact];
    }
    
    
    // 对数据进行排序，并按首字母分类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (Contacts *contact in self.contactArraytemp) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:@selector(name)];
        contact.sectionNumber = sect;
        
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Contacts *contact in self.contactArraytemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    self.allArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [self.allArray addObject:sortedSection];
    }
    
    // 只取有数据的Array
    for (NSMutableArray *sectionArray0 in self.allArray) {
        if (sectionArray0.count) {
            [self.dataSource addObject:sectionArray0];
        }
    
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加联系人
- (void)addcontactsAction
{
     AddContactsViewController* addcontact = [[AddContactsViewController alloc] initWithNibName:@"AddContactsViewController" bundle:nil];

     [self.navigationController pushViewController:addcontact animated:YES];
    
}


- (void)addnewcontact:(NSNotification *)notification
{
    Contacts *newcontact = notification.object;
    NSString *name = newcontact.name;
    
    NSLog(@"添加联系人%@",name);
    [self.contactArraytemp addObject:newcontact];
    
    // 数据更新
    self.dataSource = [[NSMutableArray alloc] init];
    self.allArray = [[NSMutableArray alloc] init];
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (Contacts *contact in self.contactArraytemp) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:@selector(name)];
        contact.sectionNumber = sect;
        
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Contacts *contact in self.contactArraytemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    self.allArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [self.allArray addObject:sortedSection];
    }
    
    // 只取有数据的Array
    for (NSMutableArray *sectionArray0 in self.allArray) {
        if (sectionArray0.count) {
            [self.dataSource addObject:sectionArray0];
        }
        
    }
     [self reloadTableView];
    
}



//#pragma mark - UITableViewDataSource
// IndexTable
- (NSArray *) sectionIndexTitlesForABELTableView:(ContactsTableView *)tableView
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else{
        self.indexTitles = [NSMutableArray array];
        
        for (int i = 0; i < self.allArray.count; i++) {
            if ([[self.allArray objectAtIndex:i] count]) {
                [self.indexTitles addObject:[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:i]];
            }
        }
        
        return self.indexTitles;

    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else{
       
        return [self.indexTitles objectAtIndex:section];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    else{
        return self.dataSource.count;
        
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return searchResults.count;
    }
    else{
        return [[self.dataSource objectAtIndex:section] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] lastObject];
    }

    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        // 搜索结果显示
        Contacts *contact = searchResults[indexPath.row];
        
        NSString *nametext = [NSString stringWithFormat:@"%@",contact.name];
    
        cell.tag = indexPath.row;
        cell.delegate = self;
        
        cell.nameLabel.text = nametext;
        
    }
    else {
        
        Contacts *contact = (Contacts *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString *nametext = [NSString stringWithFormat:@"%@",contact.name];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.nameLabel.text = nametext;
    }
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// 选中某个cell，进入 detailcontact 联系人详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactDetailViewController *contactdetail = [[ContactDetailViewController alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contactdetail.contact = searchResults[indexPath.row];
    }
    else {
        
        contactdetail.contact = (Contacts *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    }
    
    [self.navigationController pushViewController:contactdetail animated:YES];
}

// 联系人搜索，可实现汉字搜索，汉语拼音搜索和拼音首字母搜索，
// 输入联系人名称，进行搜索， 返回搜索结果searchResults
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     searchResults = [[NSMutableArray alloc]init];
    if (contactsSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:contactsSearchBar.text]) {
        for (NSArray *section in self.dataSource) {
            for (Contacts *contact in section)
            {
                
                if ([ChineseInclude isIncludeChineseInString:contact.name]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:contact.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length>0) {
                        [searchResults addObject:contact];
                    }
                    else {
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0) {
                            [searchResults  addObject:contact];
                        }
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchResults  addObject:contact];
                    }
                }
                else {
                    NSRange titleResult=[contact.name rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults  addObject:contact];
                    }
                }
            }
        }
    } else if (contactsSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:contactsSearchBar.text]) {
        
        for (NSArray *section in self.dataSource) {
            for (Contacts *contact in section)
            {
                NSString *tempStr = contact.name;
                NSRange titleResult=[tempStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:contact];
                }
                
            }
        }
    }
    
}




// searchbar 点击上浮，完毕复原
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
    [UIView animateWithDuration:1.0 animations:^{
        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
    }];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜索结束后，恢复原状
    [UIView animateWithDuration:1.0 animations:^{
        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
    return YES;
}




@end
