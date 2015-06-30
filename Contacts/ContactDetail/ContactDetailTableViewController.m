//
//  ContactDetailTableViewController.m
//  Contacts
//
//  Created by emma on 15/6/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ContactDetailTableViewController.h"

@interface ContactDetailTableViewController ()

@end

@implementation ContactDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setting sections

- (void)setSections:(NSArray *)sections {
    _sections = sections;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContactDetailSection *contactSection = self.sections[section];
    return contactSection.headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ContactDetailSection *contactSection = self.sections[section];
    return contactSection.headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ContactDetailSection *contactSection = self.sections[section];
    return contactSection.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ContactDetailSection *contactSection = self.sections[section];
    return contactSection.footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    ContactDetailSection *contactSection = self.sections[section];
    return contactSection.footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ContactDetailSection *contactSection = self.sections[section];
    return contactSection.footerHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ContactDetailSection *contactSection = self.sections[section];
    return contactSection.reuseEnabled ? contactSection.reusedCellCount : contactSection.cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactDetailSection *contactSection = self.sections[indexPath.section];
    
    if (contactSection.reuseEnabled) {
        return contactSection.reusedCellHeight;
    }
    
    else {
        ContactDetailCell *cell = contactSection.cells[indexPath.row];
        return cell.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactDetailSection *contactSection = self.sections[indexPath.section];
    
    if (contactSection.reuseEnabled) {
        return contactSection.cellForRowBlock(tableView, indexPath.row);
    }
    
    else {
        return contactSection.cells[indexPath.row];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactDetailSection *contactSection = self.sections[indexPath.section];
    
    if (contactSection.reuseEnabled) {
        if (contactSection.reusedCellActionBlock) {
            contactSection.reusedCellActionBlock(indexPath.row);
        }
    }
    
    else {
        ContactDetailCell *cell = contactSection.cells[indexPath.row];
        
        if (cell.actionBlock) {
            cell.actionBlock();
        }
    }
}

@end
