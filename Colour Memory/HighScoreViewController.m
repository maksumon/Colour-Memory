//
//  HighScoreViewController.m
//  Memory Game
//
//  Created by Mohammad Ashraful Kabir on 1/23/15.
//  Copyright (c) 2015 Mohammad Ashraful Kabir. All rights reserved.
//

#import "HighScoreViewController.h"
#import "HighScoreCell.h"
#import "Utilities.h"

@interface HighScoreViewController ()

@end

@implementation HighScoreViewController

#pragma mark - Button Action

-(IBAction)onClose:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.highScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HighScoreCell *cell = (HighScoreCell *)[tableView dequeueReusableCellWithIdentifier:@"HighScoreCell"];
    
    [[cell lblRank] setText:[NSString stringWithFormat:@"%d", (int)indexPath.row + 1]];
    [[cell lblName] setText:[[self.highScores objectAtIndex:indexPath.row] valueForKey:@"name"]];
    [[cell lblScore] setText:[NSString stringWithFormat:@"%d", (int)[[[self.highScores objectAtIndex:indexPath.row] valueForKey:@"score"] integerValue]]];
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
