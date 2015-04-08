//
//  CTCItem.h
//  iOSDiner
//
//  Created by Constance Li on 9/12/14.
//  Copyright (c) 2014 gwrabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCItem : NSObject <NSCopying>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString* pictureFile;

- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile;

+ (NSArray*)retrieveInventoryItems;

@end
