//
//  CTCOrder.h
//  iOSDiner
//
//  Created by Constance Li on 9/12/14.
//  Copyright (c) 2014 gwrabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTCItem;

@interface CTCOrder : NSObject

@property (nonatomic, strong) NSMutableDictionary* orderItems;

- (NSMutableDictionary *)orderItems;
- (CTCItem* )findKeyForOrderItem:(CTCItem*)searchItem;
- (NSString*)orderDescription;

- (void)addItemToOrder:(CTCItem *)inItem;
- (void)removeItemFromOrder:(CTCItem*)inItem;

- (float)totalOrder;

@end
