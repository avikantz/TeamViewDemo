//
//  TeamTableViewController.m
//  TeamViewDemo
//
//  Created by Avikant Saini on 3/28/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "TeamTableViewController.h"
#import "TeamTableViewCell.h"

#define TextColor [UIColor whiteColor]

#define SWidth self.view.frame.size.width
#define SHeight self.view.frame.size.height

@interface TeamTableViewController ()

@end

@implementation TeamTableViewController {
	UIButton *facebookButton;
	UIButton *twitterButton;
	UIButton *githubButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Minions behind this App";
	
	// Background Image
	if (_backgroundImage)
		self.tableView.backgroundView = [[UIImageView alloc] initWithImage:_backgroundImage];
	else
		self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TeamBG.jpg"]];
	self.tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
	self.tableView.backgroundView.clipsToBounds = YES;
	
	_teamData = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TeamList" ofType:@"dat"]]] options:kNilOptions error:nil];
	
	UIBlurEffect *blurEffect;
	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	UIVibrancyEffect *vibrancyEffect;
	vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
	self.tableView.separatorEffect = vibrancyEffect;
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		[self.tableView reloadData];
	}];
}

#pragma mark - Table view data source and delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_teamData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TeamTableViewCell *cell = nil;
	// Tapped a cell - load the large cell
	if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
		if (indexPath.row%2 == 0)
			cell = (TeamTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TeamLargeLeftCell" forIndexPath:indexPath];
		else
			cell = (TeamTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TeamLargeRightCell" forIndexPath:indexPath];
	}
	// else load the normal sized cell
	else {
		if (indexPath.row%2 == 0)
			cell = (TeamTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TeamSmallLeftCell" forIndexPath:indexPath];
		else
			cell = (TeamTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TeamSmallRightCell" forIndexPath:indexPath];
	}
	
	if (cell == nil)
		cell = (TeamTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TeamLargeLeftCell" forIndexPath:indexPath];
	
	// Initialize and add action to the social buttons
	facebookButton = (UIButton *)[cell.contentView viewWithTag:1];
	[facebookButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
	
	twitterButton = (UIButton *)[cell.contentView viewWithTag:2];
	[twitterButton addTarget:self action:@selector(twitterAction:) forControlEvents:UIControlEventTouchUpInside];
	
	githubButton = (UIButton *)[cell.contentView viewWithTag:3];
	[githubButton addTarget:self action:@selector(githubAction:) forControlEvents:UIControlEventTouchUpInside];
	
	// Fill up the gorram cell
	NSDictionary *person = [_teamData objectAtIndex:indexPath.row];
	cell.personNameLabel.text = [person objectForKey:@"Name"];
	cell.personProfessionLabel.text = [person objectForKey:@"Profession"];
	cell.personImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [person objectForKey:@"Image"]]];
	cell.personDetailLabel.text = [person objectForKey:@"Detail"];
	
	cell.personNameLabel.textColor = TextColor;
	cell.personProfessionLabel.textColor = TextColor;
	cell.personDetailLabel.textColor = TextColor;
	
	cell.backgroundView.backgroundColor = [UIColor clearColor];
	cell.backgroundColor = [UIColor clearColor];
	
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	// Animations
	UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:9];
	detailLabel.alpha = 0.0;
	detailLabel.layer.transform = CATransform3DMakeScale(0.96, 0.96, 0.96);
	UIButton *fbutton = (UIButton *)[cell.contentView viewWithTag:1];
	UIButton *tbutton = (UIButton *)[cell.contentView viewWithTag:2];
	UIButton *gbutton = (UIButton *)[cell.contentView viewWithTag:3];
	CGFloat translation = (indexPath.row%2 == 0)?44.f:-44.f;
	fbutton.layer.transform = CATransform3DMakeTranslation(translation, 0, 0);
	tbutton.layer.transform = CATransform3DMakeTranslation(translation, 0, 0);
	gbutton.layer.transform = CATransform3DMakeTranslation(translation, 0, 0);
	[UIView animateWithDuration:0.8 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
		detailLabel.alpha = 1.0;
		detailLabel.layer.transform = CATransform3DIdentity;
	} completion:nil];
	[UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
		fbutton.layer.transform = CATransform3DIdentity;
	} completion:nil];
	[UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
		tbutton.layer.transform = CATransform3DIdentity;
	} completion:nil];
	[UIView animateWithDuration:0.5 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
		gbutton.layer.transform = CATransform3DIdentity;
	} completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView beginUpdates];
	if (![indexPath compare:_selectedIndexPath] == NSOrderedSame)
		_selectedIndexPath = indexPath;
	else
		_selectedIndexPath = nil;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tableView.isDragging) {
		[tableView beginUpdates];
		[tableView reloadData];
		[tableView endUpdates];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath compare:_selectedIndexPath] == NSOrderedSame)
		return 160.f;
	return 80.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWidth, 44.f)];
	return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 44.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWidth, 96)];
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
	UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	visualEffectView.frame = CGRectMake(0, 46, SWidth, 50);
	UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
	vibrancyView.frame = CGRectMake(0, 0, SWidth, 50);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SWidth, 50)];
	label.text = @"Thank You!";
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32.0f];
	[vibrancyView.contentView addSubview:label];
	[visualEffectView.contentView addSubview:vibrancyView];
	[footer addSubview:visualEffectView];
	return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 96.f;
}

#pragma mark - Social sharing methods

-(void)facebookAction:(id)sender {
	CGPoint pointOfOrigin = [sender convertPoint:CGPointZero toView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointOfOrigin];
	NSString *userID = [[_teamData objectAtIndex:indexPath.row] objectForKey:@"Facebook"];
	if (![userID isEqualToString:@""]) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", userID]];
		if (![[UIApplication sharedApplication] canOpenURL:url])
		url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@", userID]];
			[[UIApplication sharedApplication] openURL:url];
	}
}

-(void)twitterAction:(id)sender {
	CGPoint pointOfOrigin = [sender convertPoint:CGPointZero toView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointOfOrigin];
	NSString *userID = [[_teamData objectAtIndex:indexPath.row] objectForKey:@"Twitter"];
	if (![userID isEqualToString:@""]) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?id=%@", userID]];
		if (![[UIApplication sharedApplication] canOpenURL:url])
			url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", userID]];
		[[UIApplication sharedApplication] openURL:url];
	}
}

-(void)githubAction:(id)sender {
	CGPoint pointOfOrigin = [sender convertPoint:CGPointZero toView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointOfOrigin];
	NSString *userID = [[_teamData objectAtIndex:indexPath.row] objectForKey:@"Github"];
	if (![userID isEqualToString:@""]) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://github.com/%@", userID]];
		[[UIApplication sharedApplication] openURL:url];
	}
}

@end
