//
//  Contacts.h
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Contacts : NSObject

@property (nonatomic, copy) NSString     *name;
@property (nonatomic, copy) UIImage    *headimage;
@property (nonatomic, copy) NSString     *address;
@property (nonatomic, copy) NSString     *detail;
@property NSInteger sectionNumber;  // Index


- (id)initWithPropertiesDictionary:(NSDictionary *)dic;


@end
