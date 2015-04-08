//
//  CTCViewController.m
//  iOSDiner
//
//  Created by Constance Li on 8/26/14.
//  Copyright (c) 2014 gwrabbit. All rights reserved.
//

#import "CTCViewController.h"
#import "CTCItem.h"
#import "CTCOrder.h"

@interface CTCViewController ()

@property (weak, nonatomic) IBOutlet UIButton *ibRemoveItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibAddItemButton;

@property (weak, nonatomic) IBOutlet UIButton *ibPreviousItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibNextItemButton;

@property (weak, nonatomic) IBOutlet UIButton *ibTotalOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *ibChalkboardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ibCurrentItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *ibCurrentItemLabel;

- (IBAction)ibaRemoveItem:(id)sender;
- (IBAction)ibaAddItem:(id)sender;

- (IBAction)ibaLoadPreviousItem:(id)sender;
- (IBAction)ibaLoadNextItem:(id)sender;

- (IBAction)ibaCalculateTotal:(id)sender;

@end

@implementation CTCViewController

@synthesize inventory;
@synthesize order;

dispatch_queue_t queue;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    currentItemIndex = 0;
    self.order = [CTCOrder new];

    queue = dispatch_queue_create("com.adamburkepile.queue", nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    // 0 - Update buttons
    [self updateInventoryButtons];

    self.ibChalkboardLabel.text = @"Loading Inventory...";

    // 2 - Use queue to fetch inventory and then update UI
    dispatch_async(queue, ^{
        self.inventory = [[CTCItem retrieveInventoryItems] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateOrderBoard];
            [self updateCurrentInventoryItem];
            [self updateInventoryButtons];
            self.ibChalkboardLabel.text = @"Inventory Loaded\n\nHow can I help you?";
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
//    dispatch_release(queue);
}

- (IBAction)ibaRemoveItem:(id)sender {
    CTCItem *currentItem = [self.inventory objectAtIndex:currentItemIndex];
    [self.order removeItemFromOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];

    UILabel* removeItemDisplay = [[UILabel alloc] initWithFrame:self.ibCurrentItemImageView.frame];
    [removeItemDisplay setCenter:self.ibChalkboardLabel.center];
    [removeItemDisplay setText:@"-1"];
    [removeItemDisplay setTextAlignment:NSTextAlignmentCenter];
    [removeItemDisplay setTextColor:[UIColor redColor]];
    [removeItemDisplay setBackgroundColor:[UIColor clearColor]];
    [removeItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:removeItemDisplay];

    [UIView animateWithDuration:1.0
                     animations:^{
                         [removeItemDisplay setCenter:[self.ibCurrentItemImageView center]];
                         [removeItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [removeItemDisplay removeFromSuperview];
                     }];
}

- (IBAction)ibaAddItem:(id)sender {
    CTCItem *currentItem = [self.inventory objectAtIndex:currentItemIndex];
    [self.order addItemToOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];

    UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:self.ibCurrentItemImageView.frame];
    [addItemDisplay setText:@"+1"];
    [addItemDisplay setTextColor:[UIColor whiteColor]];
    [addItemDisplay setBackgroundColor:[UIColor clearColor]];
    [addItemDisplay setTextAlignment:NSTextAlignmentCenter];
    [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:addItemDisplay];

    [UIView animateWithDuration:1.0
                     animations:^{
                         [addItemDisplay setCenter:self.ibChalkboardLabel.center];
                         [addItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [addItemDisplay removeFromSuperview];
                     }];
}

- (IBAction)ibaLoadPreviousItem:(id)sender {
    currentItemIndex--;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaLoadNextItem:(id)sender {
    currentItemIndex++;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaCalculateTotal:(id)sender {
    float total = [order totalOrder];
    UIAlertView* totalAlert = [[UIAlertView alloc] initWithTitle:@"Total"
                                                         message:[NSString stringWithFormat:@"$%0.2f",total]
                                                        delegate:nil
                                               cancelButtonTitle:@"Close"
                                               otherButtonTitles:nil];
    [totalAlert show];
}

- (void)updateCurrentInventoryItem
{
    if (currentItemIndex >= 0 && currentItemIndex < [self.inventory count])
    {
        CTCItem* currentItem = [self.inventory objectAtIndex:currentItemIndex];
        self.ibCurrentItemLabel.text = currentItem.name;
        self.ibCurrentItemImageView.image = [UIImage imageNamed:[currentItem pictureFile]];
    }
}

- (void)updateInventoryButtons
{
    if (!self.inventory || [self.inventory count] == 0) {
        self.ibAddItemButton.enabled = NO;
        self.ibRemoveItemButton.enabled = NO;
        self.ibNextItemButton.enabled = NO;
        self.ibPreviousItemButton.enabled = NO;
        self.ibTotalOrderButton.enabled = NO;
    } else{
        if (currentItemIndex <= 0)
        {
            self.ibPreviousItemButton.enabled = NO;
        }else{
            self.ibPreviousItemButton.enabled = YES;
        }

        if (currentItemIndex >= [self.inventory count]-1) {
            self.ibNextItemButton.enabled = NO;
        } else {
            self.ibNextItemButton.enabled = YES;
        }

        CTCItem* currentItem = [self.inventory objectAtIndex:currentItemIndex];
        if (currentItem) {
            self.ibAddItemButton.enabled = YES;
        } else {
            self.ibAddItemButton.enabled = NO;
        }

        if (![self.order findKeyForOrderItem:currentItem]) {
            self.ibRemoveItemButton.enabled = NO;
        } else {
            self.ibRemoveItemButton.enabled = YES;
        }

        if ([order.orderItems count] == 0) {
            self.ibTotalOrderButton.enabled = NO;
        } else {
            self.ibTotalOrderButton.enabled = YES;
        }
    }
}

- (void)updateOrderBoard {
    if ([order.orderItems count] == 0) {
        self.ibChalkboardLabel.text = @"No Items. Please order something!";
    } else {
        self.ibChalkboardLabel.text = [order orderDescription];
    }
}

@end
