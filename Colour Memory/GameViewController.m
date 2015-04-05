//
//  GameViewController.m
//  Memory Game
//
//  Created by Mohammad Ashraful Kabir on 1/23/15.
//  Copyright (c) 2015 Mohammad Ashraful Kabir. All rights reserved.
//

#import "GameViewController.h"
#import "HighScoreViewController.h"
#import "Utilities.h"

@interface GameViewController ()<UIAlertViewDelegate>{
    NSMutableArray *cards;
    UIView *selectedView;
    int pairCount, score;
}

@end

@implementation GameViewController

#pragma mark - Custom Actions

- (void)createCards
{
    cards = [[NSMutableArray alloc] init];
    
    // images
    UIImage *colour1 = [UIImage imageNamed:@"colour1"];
    UIImage *colour2 = [UIImage imageNamed:@"colour2"];
    UIImage *colour3 = [UIImage imageNamed:@"colour3"];
    UIImage *colour4 = [UIImage imageNamed:@"colour4"];
    
    NSMutableArray *imageNames = [@[colour1, colour1, colour1, colour1, colour2, colour2, colour2, colour2, colour3, colour3, colour3, colour3, colour4, colour4, colour4, colour4] mutableCopy];
    
    for (int i=0; i<16; i++) {
        float x = (i % 4) * 80 + 5;
        float y = (i / 4) * 100 + 5;
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 70, 85)];
        cardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"card_bg"]];
        [boardView addSubview:cardView];
        
        int imageNo = arc4random() % [imageNames count];
        UIImage *image = [imageNames objectAtIndex:imageNo];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, 70, 85);
        imageView.center = CGPointMake(cardView.bounds.size.width/2.0, cardView.bounds.size.height/2.0);
        [cardView addSubview:imageView];
        
        // remove used image
        [imageNames removeObjectAtIndex:imageNo];
        
        // to array
        [cards addObject:cardView];
    }
}

- (void)shuffle
{
    // hide all cards
    for (UIView *cardView in cards) {
        [self flipCard:cardView withCheck:NO];
    }
    
    // shuffle array
    NSMutableArray *tempCards = [[NSMutableArray alloc] init];
    int count = (int)[cards count];
    for (int i=0; i<count; i++) {
        int newIndex = arc4random() % [cards count];
        [tempCards addObject:[cards objectAtIndex:newIndex]];
        [cards removeObjectAtIndex:newIndex];
    }
    
    cards = tempCards;

    //new position
    for (int i=0; i<16; i++) {
        float x = (i % 4) * 80 + 5;
        float y = (i / 4) * 100 + 5;
        UIView *cardView = [cards objectAtIndex:i];
        [UIView animateWithDuration:0.2 animations:^{
            cardView.frame = CGRectMake(x, y, 70, 85);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip:)];
        [cardView addGestureRecognizer:tap];
    }
    
    score = 0;
    pairCount = 0;
    
    [lblScore setText:[NSString stringWithFormat:@"0"]];
}

- (void)flip:(UITapGestureRecognizer*)gestureRecognizer
{
    if (selectedView != gestureRecognizer.view) {
        [self flipCard:gestureRecognizer.view withCheck:YES];
    }
}

- (void)flipCard:(UIView*)cardView withCheck:(BOOL)check
{
    [UIView animateWithDuration:0.3 animations:^{
        cardView.layer.transform = CATransform3DRotate(cardView.layer.transform, M_PI/2.0, 0, 1, 0);
    } completion:^(BOOL finished) {
        
        // hide or show image
        UIImageView *imageView = [cardView.subviews objectAtIndex:0];
        imageView.alpha = imageView.alpha * (-1);
        [UIView animateWithDuration:0.3 animations:^{
            cardView.layer.transform = CATransform3DRotate(cardView.layer.transform, M_PI/2.0, 0, 1, 0);
            
        } completion:^(BOOL finished) {
            if (check) {
                // Compare Image
                [self compareImage:cardView];
            }
        }];
    }];
}

- (void)compareImage:(UIView*)view
{
    if (!selectedView) {
        selectedView = view;
        return;
    }
    
    UIImage *selectedImg = ((UIImageView*)[selectedView.subviews objectAtIndex:0]).image;
    UIImage *vImage = ((UIImageView*)[view.subviews objectAtIndex:0]).image;
    
    if (selectedImg == vImage) {
        // OK
        selectedView = nil;
        for (UIGestureRecognizer *gestureRecognizer in selectedView.gestureRecognizers) {
            [selectedView removeGestureRecognizer:gestureRecognizer];
        }
        for (UIGestureRecognizer *gestureRecognizer in selectedView.gestureRecognizers) {
            [selectedView removeGestureRecognizer:gestureRecognizer];
        }
        
        pairCount++;
        score += 2;
        
        [lblScore setText:[NSString stringWithFormat:@"%d",score]];
        
        if (pairCount == 8) {
            
            UIAlertView *alertViewPlayerName=[[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                                        message:@"Submit Your Name"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"Submit", nil];
            alertViewPlayerName.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertViewPlayerName show];
            
            // clear
            pairCount = 0;
        }
        
        return;
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self flipCard:selectedView withCheck:NO];
            [self flipCard:view withCheck:NO];
            selectedView = nil;
            
            score --;
            
            [lblScore setText:[NSString stringWithFormat:@"%d",score]];
        });
    }
}

#pragma mark - Button Action

-(IBAction)onHighScore:(id)sender{
    
    [self performSegueWithIdentifier:@"segueHighScore" sender:self];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSString *name = [[alertView textFieldAtIndex:0] text];
        
        if ([name isEqualToString:@""] || [name length] == 0) {
            
            UIAlertView *alertViewPlayerName=[[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"Name is Required"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"Submit", nil];
            alertViewPlayerName.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertViewPlayerName show];
            
        } else {
            NSLog(@"Player Name: %@", name);

            if (score > [Utilities fetchHighestScore]) {
                if ([Utilities saveScoreWithName:name andScore:score]) {
                    [self shuffle];
                }
            } else {
                [self shuffle];
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"segueHighScore"])
    {
        NSMutableArray *highScores = [[Utilities fetchScores] mutableCopy];
        
        for (NSDictionary *scorer in highScores) {
            NSLog(@"Name: %@\nScore: %d", [scorer valueForKey:@"name"], (int)[[scorer valueForKey:@"score"] integerValue]);
        }
        
        HighScoreViewController *viewController = (HighScoreViewController *) [segue destinationViewController];
        viewController.highScores = highScores;
    }
}

#pragma mark - ViewController Method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    pairCount = 0;
    score = 0;
    
    boardView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    
    [self createCards];
    
    [self shuffle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
