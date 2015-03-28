//
//  TeamTableViewCell.m
//  TeamViewDemo
//
//  Created by Avikant Saini on 3/28/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "TeamTableViewCell.h"

@implementation TeamTableViewCell

- (void)awakeFromNib {
	CALayer *layer = [_personImageView layer];
	[layer setMasksToBounds:YES];
	[layer setCornerRadius:_personImageView.frame.size.width/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
