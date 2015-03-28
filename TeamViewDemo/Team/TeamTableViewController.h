//
//  TeamTableViewController.h
//  TeamViewDemo
//
//  Created by Avikant Saini on 3/28/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableViewController : UITableViewController

@property (copy, nonatomic) UIImage *backgroundImage;

@property (strong, nonatomic) id teamData;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end
