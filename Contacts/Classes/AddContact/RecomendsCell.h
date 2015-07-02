//
//  RecomendsCell.h
//  Contacts
//
//  Created by emma on 15/6/19.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecomendsCellDelegate <NSObject>

@end

@interface RecomendsCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UIImage *headImage;


@property (assign, nonatomic) id<RecomendsCellDelegate> delegate;

@end
