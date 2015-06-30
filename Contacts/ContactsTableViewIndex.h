//
//  ContactsTableViewIndex.h
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsTableViewIndexDelegate;


@interface ContactsTableViewIndex : UIView

@property (nonatomic, strong) NSArray *indexes;
@property (nonatomic, weak) id <ContactsTableViewIndexDelegate> tableViewIndexDelegate;

@end

@protocol ContactsTableViewIndexDelegate <NSObject>

/**
 *  触摸到索引时触发
 *
 *  @param tableViewIndex 触发didSelectSectionAtIndex对象
 *  @param index          索引下标
 *  @param title          索引文字
 */
- (void)tableViewIndex:(ContactsTableViewIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title;

/**
 *  开始触摸索引
 *
 *  @param tableViewIndex 触发tableViewIndexTouchesBegan对象
 */
- (void)tableViewIndexTouchesBegan:(ContactsTableViewIndex *)tableViewIndex;
/**
 *  触摸索引结束
 *
 *  @param tableViewIndex
 */
- (void)tableViewIndexTouchesEnd:(ContactsTableViewIndex *)tableViewIndex;

/**
 *  TableView中右边右边索引title
 *
 *  @param tableViewIndex 触发tableViewIndexTitle对象
 *
 *  @return 索引title数组
 */
- (NSArray *)tableViewIndexTitle:(ContactsTableViewIndex *)tableViewIndex;

@end