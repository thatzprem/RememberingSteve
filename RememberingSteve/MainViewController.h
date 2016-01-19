//
//  MainViewController.h
//  RememberingSteve
//
//  Created by Prem kumar on 02/08/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "FlipsideViewController.h"
#import "NTBaseViewController.h"

@interface MainViewController : NTBaseViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSDictionary *detailsDictionary;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
