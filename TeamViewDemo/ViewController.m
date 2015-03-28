//
//  ViewController.m
//  TeamViewDemo
//
//  Created by Avikant Saini on 3/28/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "ViewController.h"
#import "TeamTableViewController.h"

#define SWidth self.view.frame.size.width
#define SHeight self.view.frame.size.height

#define DefColor [UIColor colorWithRed:240/255.f green:240/255.f blue:32/255.f alpha:1.0]
#define TextColor [UIColor colorWithRed:10/255.f green:10/255.f blue:90/255.f alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
	[self.navigationItem setBackBarButtonItem:backButton];
	
	self.navigationController.navigationBar.tintColor = TextColor;
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : TextColor, NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0f]};
	self.navigationController.navigationBar.tintColor = TextColor;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	[self.navigationController.navigationBar setBarTintColor:DefColor];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	
	self.navigationItem.title = @"Main View";
	
//	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//	UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//	visualEffectView.frame = CGRectMake(0, SHeight - 120, SWidth, 120);
//	UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//	vibrancyView.frame = CGRectMake(0, 0, SWidth, 120);
//	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SWidth, 120)];
//	label.text = @"Team View";
//	label.textAlignment = NSTextAlignmentCenter;
//	label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0f];
//	[vibrancyView.contentView addSubview:label];
//	[visualEffectView.contentView addSubview:vibrancyView];
//	[self.view addSubview:visualEffectView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)teamViewAction:(id)sender {
}

@end
