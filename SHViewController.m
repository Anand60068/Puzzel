//
//  SHViewController.m
//  Puzzel
//
//  Created by Anand on 28/06/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//


/*
 
 Write a program that accepts input as a string pattern of 0s, 1s and ?s (wild cards) and it will generate all combination strings 0 - 1 that match the given pattern. (There can be any number of ?s in the input)
 
 For example if the input is 11?000?1.. the output will be
 11000001
 11100001
 11000011
 11100011
 */


#import "SHViewController.h"

@interface SHViewController (){
    
}

@end

@implementation SHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    dispatch_queue_t  queue = dispatch_queue_create("com.dispatch.puzzel", NULL);
    
    dispatch_async(queue, ^{
        [self getTheInputString:@"111?1011?1?1???????1?11??"];
    });
    
}

- (void)getTheInputString:(NSString *)string
{
    NSMutableArray *mArray = [NSMutableArray array];
    NSMutableArray *storeIndexOfQuestion = [NSMutableArray array];
    
    for (int index = 0; index < [string length]; index++) {
        unichar value = [string characterAtIndex:index];
        NSString *mString = [NSString stringWithFormat:@"%c", value];
        
        if ([mString isEqualToString:@"?"]) {
            [storeIndexOfQuestion addObject:[NSString stringWithFormat:@"%i", index]];
        }
        
        [mArray addObject:[NSString stringWithFormat:@"%c", value]];
        
    }
    
    
    NSInteger count = [storeIndexOfQuestion count];
    
    NSMutableArray *tArray = [[NSMutableArray alloc] init];

    
    if (count > 1) {
        [tArray addObject:[NSString stringWithFormat:@"%i", 1]];
        [tArray addObject:[NSString stringWithFormat:@"%i", 0]];
    }
    
    NSInteger newCount = count == 1?2:count;
    
    
    
    dispatch_queue_t  queue = dispatch_queue_create("com.dispatch.main", NULL);
    
    dispatch_async(queue, ^{
        NSArray *valuesArray = [[self permutationsWithRepetitionFromElements:tArray taking:newCount] allObjects];
      
        NSMutableArray *fArray = [NSMutableArray array];
        for (int index = 0; index < [valuesArray count]; index++)
        {
            for (int index2 = 0 ; index2 < count; index2++)
            {
                
                NSString *replaceObject = [storeIndexOfQuestion objectAtIndex:index2];
                id object = [[valuesArray objectAtIndex:index] objectAtIndex:index2];
                [mArray replaceObjectAtIndex:[replaceObject intValue] withObject:object];
                
            }
            NSArray *offArray = [mArray mutableCopy];
            
            [fArray addObject:offArray];
            
        }
        
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (int index = 0; index < [fArray count]; index++) {
            
            NSString *nString = [[NSString alloc] init];
            NSInteger count = [[fArray objectAtIndex:index] count];
            for (int j = 0; j < count ; j++) {
                nString = [nString stringByAppendingFormat:@"%@", [[fArray objectAtIndex:index] objectAtIndex:j]];
            }
            [tempArray addObject:nString];
        }
        
        NSLog(@"%@", tempArray);
    });
    
}




- (NSSet *)permutationsWithRepetitionFromElements:(NSArray *)elements taking:(int)number
{
    return [NSSet setWithArray:[self permWithRepFrom:elements taking:number]];
}

- (NSArray *)permWithRepFrom:(NSArray *)elements taking:(int)number
{
    NSMutableArray *container = [NSMutableArray new];
    
    if (number == 1 && [elements count] > 0) {
        
        container = [self addArraysWithElements:elements toContainer:container];
        
    } else if (number > 1 && [elements count] > 0) {
        
        for (id element in elements) {
            for (NSArray *array in [self permWithRepFrom:elements taking:number - 1]) {
                container = [self addArrayByJoiningElement:element andArray:array toContainer:container];
            }
        }
        
    }
    
    return container;
}


- (NSMutableArray *)arrayWithArray:(NSArray *)array fromIndex:(int)index
{
    return [[array objectsAtIndexes:
             [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, [array count] - index)]]
            mutableCopy];
}

- (NSMutableArray *)addArraysWithElements:(NSArray *)elements toContainer:(NSMutableArray *)container
{
    for (id elem in elements) {
        [container addObject:@[elem]];
    }
    return container;
}

- (NSMutableArray *)addArrayByJoiningElement:(id)element andArray:(NSArray *)array toContainer:(NSMutableArray *)container
{
    NSMutableArray *new = [array mutableCopy];
    [new insertObject:element atIndex:0];
    [container addObject:new];
    return container;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
