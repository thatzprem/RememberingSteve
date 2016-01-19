//
//  FlipsideViewController.h
//  RememberingSteve
//
//  Created by Prem kumar on 02/08/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTBaseViewController.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : NTBaseViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end

@interface SettingsViewModel : NSObject

@property (nonatomic,assign) BOOL isHorizontalSwitchOn;
@property (nonatomic,assign) BOOL isVerticalSwitchOn;
@property (nonatomic,assign) BOOL isGravitySwitchOn;
@property (nonatomic,assign) BOOL isNormalSwitchOn;
@property (nonatomic,assign) BOOL isRandomSwitchOn;

@end
