//
//  Utilities.h
//  Memory Game
//
//  Created by Mohammad Ashraful Kabir on 1/23/15.
//  Copyright (c) 2015 Mohammad Ashraful Kabir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Utilities : NSObject

+(NSManagedObjectContext *)managedObjectContext;
+(BOOL)saveScoreWithName:(NSString *)name andScore:(int)score;
+(int)fetchHighestScore;
+(NSArray *)fetchScores;

@end
