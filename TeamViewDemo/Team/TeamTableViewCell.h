//
//  TeamTableViewCell.h
//  TeamViewDemo
//
//  Created by Avikant Saini on 3/28/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personProfessionLabel;
@property (weak, nonatomic) IBOutlet UILabel *personDetailLabel;



@end
