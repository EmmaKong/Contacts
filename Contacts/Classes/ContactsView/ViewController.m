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
@property (nonatomic, strong) NSMutableArray * dataSource;  // 设为可变是为了方便添加和删除数据



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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人";
    
    self.dataSource = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    
    contactsSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    contactsSearchBar.delegate = self;
    [contactsSearchBar setPlaceholder:@"搜索"];
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

    NSString *contactsPath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:contactsPath];
    //解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.dataSource = [dict objectForKey:@"data"];
    
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
    
    NSString *tempPinYinname = [PinYinForObjc chineseConvertToPinYin:newcontact.name];
    NSLog(@"%@",[[tempPinYinname capitalizedString] substringToIndex:1]);

    NSMutableArray *source = self.dataSource;
   // "#" 的ascii 码：35
    
    // 首字母在section中 已存在
    for (int i = 0; i < self.dataSource.count; i++) {
        
        // 首字母在A～Z范围内
        if ( [[[tempPinYinname capitalizedString] substringToIndex:1] compare:@"A"] == 1 && [[[tempPinYinname capitalizedString] substringToIndex:1] compare:@"Z"] == -1){
             //首字母已存在
            if([[tempPinYinname capitalizedString] hasPrefix:self.dataSource[i][@"indexTitle"]]) {
            
                NSMutableArray *sectioncontacts = self.dataSource[i][@"data"];
                NSMutableArray *temparray = [[NSMutableArray alloc] init];
                [temparray addObjectsFromArray:sectioncontacts];
            
                // NSDictionary *dic = @{@"name":newcontact.name};
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:newcontact.name,@"name",nil];
                [temparray addObject:dic];
               // self.dataSource[i][@"data"] = temparray;
                source[i][@"data"] = temparray;
            
            
            }else if([self.dataSource[self.dataSource.count-1][@"indexTitle"] isEqualToString:@"#"] &&  i < self.dataSource.count-1 && ([ self.dataSource[i][@"indexTitle"] compare:[[tempPinYinname capitalizedString] substringToIndex:1]] == -1) && ([self.dataSource[i+1][@"indexTitle"] compare:[[tempPinYinname capitalizedString] substringToIndex:1]] == 1))
            {
            
//                //self.dataSource[i+1] = nil;
//                for(int j = self.dataSource.count; j < i+1; j--){
//             
//                    self.dataSource[j] = self.dataSource[j-1];
//                }
//                // 插入一个section
               
                NSMutableArray *temparray0 = [[NSMutableArray alloc] init];
                NSMutableDictionary *dic0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:newcontact.name,@"name",nil];
                [temparray0 addObject:dic0];
                
               // NSMutableArray *temparraydata = [[NSMutableArray alloc] init];
                NSMutableDictionary *dicdata = [NSMutableDictionary dictionaryWithObjectsAndKeys:temparray0,@"data",nil];
               // [temparraydata addObject:dicdata];
                
                NSMutableArray *temparray = [[NSMutableArray alloc] init];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[tempPinYinname capitalizedString] substringToIndex:1],@"Index",nil];
                [temparray addObject:dicdata];
                [temparray addObject:dic];
                
                [self.dataSource insertObject:temparray atIndex:i];  //????
               
    
            
            }
            else if( ![self.dataSource[self.dataSource.count-1][@"indexTitle"] isEqualToString:@"#"]  && ([ self.dataSource[i][@"indexTitle"] compare:[[tempPinYinname capitalizedString] substringToIndex:1]] == -1)
                    && ([self.dataSource[i+1][@"indexTitle"] compare:[[tempPinYinname capitalizedString] substringToIndex:1]] == 1))
            {
                
                
                
            
            }
            else if(![self.dataSource[self.dataSource.count-1][@"indexTitle"] isEqualToString:@"#"] &&  ([self.dataSource[self.dataSource.count-1][@"indexTitle"] compare:[[tempPinYinname capitalizedString] substringToIndex:1]] == -1))
            {
                
                
                
            }
        
        }else if( [self.dataSource[self.dataSource.count-1][@"indexTitle"] isEqualToString:@"#"] ){  // 首字母为特殊字符, 且原数据中存在特殊字符, 插入
            
            NSMutableArray *sectioncontacts = self.dataSource[self.dataSource.count-1][@"data"];
            NSMutableArray *temparray = [[NSMutableArray alloc] init];
            [temparray addObjectsFromArray:sectioncontacts];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:newcontact.name,@"name",nil];
            [temparray addObject:dic];
            
            self.dataSource[self.dataSource.count-1] = temparray;
            
            
        }
        else{  // 首字母为特殊字符, 且原数据中m没有特殊字符
            
            NSMutableArray *temparray = [[NSMutableArray alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:newcontact.name,@"name",nil];
            [temparray addObject:dic];
            
            
            
        }
    }
    
    
    
    
}



#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(ContactsTableView *)tableView
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else{
        NSMutableArray * indexTitles = [NSMutableArray array];
        for (NSDictionary * sectionDictionary in self.dataSource) {
            [indexTitles addObject:sectionDictionary[@"indexTitle"]];
        }
        return indexTitles;
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else{
        return self.dataSource[section][@"indexTitle"];
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
        return [self.dataSource[section][@"data"] count];
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
        
        NSDictionary *Dict = self.dataSource[indexPath.section];
        NSArray *sectioncontacts = [Dict objectForKey:@"data"];
        NSMutableDictionary *contacts = [NSMutableDictionary dictionaryWithDictionary:sectioncontacts[indexPath.row]];
        Contacts *contact = [[Contacts alloc] initWithPropertiesDictionary:contacts];
        
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
        NSDictionary *Dict = self.dataSource[indexPath.section];
        NSArray *sectioncontacts = [Dict objectForKey:@"data"];
        NSMutableDictionary *contacts = [NSMutableDictionary dictionaryWithDictionary:sectioncontacts[indexPath.row]];
        contactdetail.contact = [[Contacts alloc] initWithPropertiesDictionary:contacts];
        
        
    }
    
    [self.navigationController pushViewController:contactdetail animated:YES];
}

// 联系人搜索，可实现汉字搜索，汉语拼音搜索和拼音首字母搜索，
// 输入联系人名称，进行搜索， 返回搜索结果searchResults
#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    searchResults = [[NSMutableArray alloc]init];
    if (contactsSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:contactsSearchBar.text])
    {
        for (int i = 0; i< self.dataSource.count; i++)
        {  // i —— indexpath.section
            NSDictionary *initialDict = self.dataSource[i];
            NSArray *initialcontacts = [initialDict objectForKey:@"data"];
          //  NSString *index = [initialDict objectForKey:@"indexTitle"];   // A B C D ...
            for(int j = 0; j < initialcontacts.count; j++)
            {  // j ——— indexpath.row
                NSMutableDictionary *tempcontact = [NSMutableDictionary dictionaryWithDictionary:initialcontacts[j]];
              //  [tempcontact setObject:index forKey:@"indexTitle"];
                Contacts *contact = [[Contacts alloc] initWithPropertiesDictionary:tempcontact];
                if ([ChineseInclude isIncludeChineseInString:contact.name])
                {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:contact.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                
                    if (titleResult.length>0)
                    {
                    [searchResults addObject:contact];
                    }
                    else
                    {
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0)
                        {
                        [searchResults addObject:contact];
                        }
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                    [searchResults addObject:contact];
                    }
                }
                else {
                    NSRange titleResult=[contact.name rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0)
                    {
                    [searchResults addObject:contact]; // 搜索结果
                    }
                }
            }
        }
    }
    else if (contactsSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:contactsSearchBar.text])  // 有中文输入
    {
        
        for (int i = 0; i< self.dataSource.count; i++)
        {  // i —— indexpath.section
            NSDictionary *initialDict = self.dataSource[i];
            NSArray *initialcontacts = [initialDict objectForKey:@"data"];
            for(int j = 0; j < initialcontacts.count; j++)
            {  // j ——— indexpath.row
                NSMutableDictionary *tempcontact = [NSMutableDictionary dictionaryWithDictionary:initialcontacts[j]];
                Contacts *contact = [[Contacts alloc] initWithPropertiesDictionary:tempcontact];
                
                NSString *tempStr = contact.name;
                NSRange titleResult=[tempStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0){
                     [searchResults addObject:contact]; // 搜索结果
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
