//
//  HighScoreViewController.h
//  Memory Game
//
//  Created by Mohammad Ashraful Kabir on 1/23/15.
//  Copyright (c) 2015 Mohammad Ashraful Kabir. All rights reserved.
//

#import "GameViewController.h"

@interface HighScoreViewController : UIViewController<UITableViewDataSource>{
    
    IBOutlet UITableView *tblHighScore;
}

@property (nonatomic, strong) NSMutableArray *highScores;

@end
