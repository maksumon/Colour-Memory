//
//  HighScoreCell.h
//  Memory Game
//
//  Created by Mohammad Ashraful Kabir on 1/23/15.
//  Copyright (c) 2015 Mohammad Ashraful Kabir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblRank;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblScore;

@end
