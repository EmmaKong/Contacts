//
//  Contacts.m
//  Contacts
//
//  Created by emma on 15/6/18.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "Contacts.h"

@implementation Contacts

- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {
            self.name = [dic objectForKey:@"name"];
            self.headimage = [dic objectForKey:@"headimage"];
            self.address = [dic objectForKey:@"address"];
            self.detail = [dic objectForKey:@"detail"];
            
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"name : %@\n",self.name];
    result = [result stringByAppendingFormat:@"headimage : %@\n",self.headimage];
    result = [result stringByAppendingFormat:@"address : %@\n",self.address];
    result = [result stringByAppendingFormat:@"detail: %@\n",self.detail];
    return result;
}


@end
