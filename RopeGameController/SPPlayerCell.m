//
//  SPPlayerCell.m
//  RopeGameController
//
//  Created by Valerio Mazzeo on 19/09/13.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import "SPPlayerCell.h"
#import "NSString+Utils.h"
#import "UIImageView+WebCache.h"

@implementation SPPlayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithPlayer:(SPPlayer *)player
{
    self.textLabel.text = player.name;
    self.detailTextLabel.text = player.email;
    [self.imageView setImageWithURL:[player.email gravatarURLWithSize:48]];
}

@end
