//
//  CTCItem.m
//  iOSDiner
//
//  Created by Constance Li on 9/12/14.
//  Copyright (c) 2014 gwrabbit. All rights reserved.
//

#import "CTCItem.h"

#define kInventoryAddress @"http://adamburkepile.com/inventory/"

@implementation CTCItem

@synthesize name;
@synthesize price;
@synthesize pictureFile;

- (id)copyWithZone:(NSZone *)zone
{
    CTCItem* newItem = [CTCItem new];
    [newItem setName:[self name]];
    [newItem setPrice:[self price]];
    [newItem setPictureFile:[self pictureFile]];

    return newItem;
}

- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile
{
    if (self = [self init])
    {
        [self setName:inName];
        [self setPrice:inPrice];
        [self setPictureFile:inPictureFile];
    }

    return self;
}

+ (NSArray*)retrieveInventoryItems
{
    // 1 - Create variables
    NSMutableArray* inventory = [NSMutableArray new];
    NSError* err = nil;
    // 2 - Get inventory data
    NSArray* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kInventoryAddress]]
                                                             options:kNilOptions
                                                               error:&err];
    // 3 - Enumerate inventory objects
    [jsonInventory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [inventory addObject:[[CTCItem alloc] initWithName:[item objectForKey:@"Name"]
                                                  andPrice:[[item objectForKey:@"Price"] floatValue]
                                            andPictureFile:[item objectForKey:@"Image"]]];
    }];
    // 4 - Return a copy of the inventory data
    return [inventory copy];
}

@end
