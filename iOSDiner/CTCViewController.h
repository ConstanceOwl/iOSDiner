//
//  CTCViewController.h
//  iOSDiner
//
//  Created by Constance Li on 8/26/14.
//  Copyright (c) 2014 gwrabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTCOrder;

@interface CTCViewController : UIViewController
{
    int currentItemIndex;
}

@property (strong, nonatomic) NSMutableArray* inventory;
@property (strong, nonatomic) CTCOrder *order;

- (void)updateCurrentInventoryItem;
- (void)updateInventoryButtons;
- (void)updateOrderBoard;

@end
