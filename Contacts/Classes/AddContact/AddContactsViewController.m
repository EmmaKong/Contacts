//
//  AddContactsViewController.m
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "AddContactsViewController.h"
#import "Contacts.h"
#import "RecomendsCell.h"
#import "ContactDetailViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"


@implementation AddContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加联系人";
    
    [self _initLayout];
    
    [self performSelector:@selector(loadrecomendsDatas) withObject:nil afterDelay:0.5];
    
}

- (void)_initLayout
{
    newcontactsSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];

    newcontactsSearchBar.delegate = self;
    [newcontactsSearchBar setPlaceholder:@"搜索"];
    newcontactsSearchBar.keyboardType = UIKeyboardTypeDefault;
   // [self.view addSubview:newcontactsSearchBar];

    newsearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:newcontactsSearchBar contentsController:self];
    newsearchDisplayController.active = NO;
    newsearchDisplayController.searchResultsDataSource = self;
    newsearchDisplayController.searchResultsDelegate = self;
    
    
    //self.recomended = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.recomended.delegate = self;
    self.recomended.dataSource = self;
    self.recomended.tableHeaderView = newcontactsSearchBar;
    [self.view addSubview:self.recomended];
    
}

- (void)loadrecomendsDatas
{
    // json数据解析
    NSString *recomendsPath = [[NSBundle mainBundle] pathForResource:@"recomends" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:recomendsPath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _recomendsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        Contacts *recontact = [[Contacts alloc] initWithPropertiesDictionary:array[i]];
        [_recomendsArray addObject:recontact];
    }
    [self.recomended  reloadData];
   
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == newsearchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else if(section == 0){
        return nil;
    }
    else{
        return  @"可能认识的人";
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == newsearchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    else return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return newsearchResults.count;
    }
    else if(section == 0){
        return 2;
    }
    else{
        return _recomendsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"RecomendsCell";
        RecomendsCell *cell = (RecomendsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecomendsCell" owner:self options:nil] lastObject];
        }
        // 搜索结果显示
        Contacts *contact = newsearchResults[indexPath.row];
        
        NSString *nametext = [NSString stringWithFormat:@"%@",contact.name];
        NSString *addresstext = [NSString stringWithFormat:@"%@",contact.address];
        cell.tag = indexPath.row;
        cell.delegate = self;
        
        cell.nameLabel.text = nametext;
        cell.addressLabel.text = addresstext;
        UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addbutton setFrame:CGRectMake(30.0, 0.0, 50, 28)];
        addbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        addbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [addbutton setTitle:@"添加" forState:UIControlStateNormal];
        addbutton.tag = indexPath.row;
        [addbutton addTarget:self action:@selector(searchAddbtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = addbutton;
        return cell;
        
    }
    else if(indexPath.section == 0){
        NSArray * titleArray= [[NSArray alloc] initWithObjects:@"添加手机联系人", @"添加微信好友",nil];
        
        static NSString *CellIdentifier = @"CellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
        NSUInteger row = [indexPath row];
        cell.textLabel.text = [titleArray objectAtIndex:row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
        
    }
    else{
        
        static NSString *CellIdentifier = @"RecomendsCell";
        RecomendsCell *cell = (RecomendsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecomendsCell" owner:self options:nil] lastObject];
        }
        Contacts *contact = _recomendsArray[indexPath.row];
        NSString *nametext = [NSString stringWithFormat:@"%@",contact.name];
        NSString *addresstext = [NSString stringWithFormat:@"%@",contact.address];
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.nameLabel.text = nametext;
        cell.addressLabel.text = addresstext;
        UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addbutton setFrame:CGRectMake(30.0, 0.0, 50, 28)];
        addbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        addbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [addbutton setTitle:@"添加" forState:UIControlStateNormal];
        addbutton.tag = indexPath.row;
        [addbutton addTarget:self action:@selector(normalAddbtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = addbutton;
        return cell;
    }
       
}

// cell上的 添加课程按钮, 响应事件,  搜索结果中的cell
- (void)searchAddbtnClick:(id *)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.searchDisplayController.searchResultsTableView];
    NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        Contacts *newcontact = [newsearchResults objectAtIndex:indexPath.row];
        
        //第一步注册通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addcontactNotification" object:newcontact];
        
       // [self tableView:self.recomended accessoryButtonTappedForRowWithIndexPath:indexPath];
        UITableViewCell *cell =[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
        UIButton *button = (UIButton *)cell.accessoryView;
        [button setTitle:@"已添加" forState:UIControlStateNormal];
    }
    
}

// 添加课程按钮, 响应事件， table中的cell上的button
- (void)normalAddbtnClick:(id *)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.recomended];
    NSIndexPath *indexPath = [self.recomended indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        Contacts *newcontact = [_recomendsArray objectAtIndex:indexPath.row];
        
        //第一步注册通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addcontactNotification" object:newcontact];
        
        UITableViewCell *cell =[self.recomended cellForRowAtIndexPath:indexPath];
        UIButton *button = (UIButton *)cell.accessoryView;
        [button setTitle:@"已添加" forState:UIControlStateNormal];
        
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return 44;
        
    }
    else if(indexPath.section == 0){
        
        return 38;
        
    }
    else{
        
        return 44;
    }

}

//设置标题尾的宽度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// 选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactDetailViewController *contactdetail = [[ContactDetailViewController alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contactdetail.contact = newsearchResults[indexPath.row];
        
        [self.navigationController pushViewController:contactdetail animated:YES];
    }
    else if(indexPath.section == 0){
         if(indexPath.row == 0){
             
             AddressBookViewController *ABviewcontroller = [[AddressBookViewController alloc] initWithNibName:@"AddressBookViewController" bundle:nil];
             ABviewcontroller.delegate = self;
             [self.navigationController pushViewController:ABviewcontroller animated:YES];
             
        }
        if (indexPath.row == 1){
            NSLog(@"weichat");
            
            
        }
    }
    else {
        contactdetail.contact = _recomendsArray[indexPath.row];
        
        [self.navigationController pushViewController:contactdetail animated:YES];
    }
    
}


#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   
    newsearchResults = [[NSMutableArray alloc]init];
    
    if (newcontactsSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:newcontactsSearchBar.text]) {
        for (int i=0; i< _recomendsArray.count; i++) {
            
            Contacts *recomend = _recomendsArray[i];
            if ([ChineseInclude isIncludeChineseInString:recomend.name]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:recomend.name];
                NSRange titleResult=[tempPinYinStr rangeOfString:newcontactsSearchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [newsearchResults addObject:recomend];
                }
                else {
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:recomend.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:newcontactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [newsearchResults addObject:recomend];
                    }
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:recomend.name];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:newcontactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [newsearchResults addObject:recomend];
                }
            }
            else {
                NSRange titleResult=[recomend.name rangeOfString:newcontactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [newsearchResults addObject:recomend]; // 搜索结果
                }
            }
        }
    } else if (newcontactsSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:newcontactsSearchBar.text]) {
        
        for (int i=0; i< _recomendsArray.count; i++) {
            
            Contacts *recomend = _recomendsArray[i];
            NSString *tempStr = recomend.name;
            NSRange titleResult=[tempStr rangeOfString:newcontactsSearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [newsearchResults addObject:recomend];
            }
            
        }
    }
    
}



@end
