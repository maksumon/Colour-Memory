//
//  Utilities.m
//  Memory Game
//
//  Created by Mohammad Ashraful Kabir on 1/23/15.
//  Copyright (c) 2015 Mohammad Ashraful Kabir. All rights reserved.
//

#import "Utilities.h"
#import "AppDelegate.h"

@implementation Utilities

+(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+(BOOL)saveScoreWithName:(NSString *)name andScore:(int)score{

    BOOL success = NO;
    
    NSManagedObjectContext *context = [Utilities managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newScore = [NSEntityDescription insertNewObjectForEntityForName:@"Score"
                                                                inManagedObjectContext:context];
    
    [newScore setValue:name forKey:@"name"];
    [newScore setValue:[NSNumber numberWithInt:score] forKey:@"score"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        
        success = NO;
        
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    } else {
        
        success = YES;
    }
    
    return success;
}

+(int)fetchHighestScore{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Score"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"score==max(score)"];

    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        NSLog(@"%@", result);
    }
    
    if ([result count] == 0) {
        return 0;
    }
    
    return (int)[[[result objectAtIndex:0] valueForKey:@"score"] integerValue];
}

+(NSArray *)fetchScores{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Score"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        NSLog(@"%@", result);
    }
    
    return result;
}

@end
