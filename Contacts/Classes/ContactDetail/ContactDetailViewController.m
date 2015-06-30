//
//  ContactDetailViewController.m
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactHeadCell.h"
#import "ContactPersonInfoCell.h"
#import "ContactSchoolInfoCell.h"

@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];  // grouped tableview
    if(!self){
        return nil;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详细资料";
    
        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ContactHeadCell *headCell = [[ContactHeadCell alloc] init: self.contact];
    ContactDetailSection *headSection = [ContactDetailSection sectionWithHeaderTitle:nil cells:@[headCell]];
    
    
    ContactPersonInfoCell *personinfoCell = [[ContactPersonInfoCell alloc] init: self.contact];
    // 编辑 按钮
    ContactDetailSection *personinfoSection = [ContactDetailSection sectionWithHeaderTitle:nil cells:@[personinfoCell]];
    
    
    ContactSchoolInfoCell *schoolinfoCell = [[ContactSchoolInfoCell alloc] init: self.contact];
    // 编辑 按钮
    ContactDetailSection *schoolinfoSection = [ContactDetailSection sectionWithHeaderTitle:nil cells:@[schoolinfoCell]];
    
    
   
    
    self.sections = @[headSection, personinfoSection, schoolinfoSection];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
