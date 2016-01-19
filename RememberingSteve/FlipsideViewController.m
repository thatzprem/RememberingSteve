//
//  FlipsideViewController.m
//  RememberingSteve
//
//  Created by Prem kumar on 02/08/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "FlipsideViewController.h"
#import "AppDelegate.h"

@interface FlipsideViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *horizontalTransitionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *verticalTransitionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gravityTransitionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *normalTransitionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *randomTransitionSwitch;

@end

@implementation FlipsideViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self refreshSwitchButtonStates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshSwitchButtonStates{
    
    SettingsViewModel *settingsVM = [SettingsViewModel new];
    
    [self.randomTransitionSwitch setOn:settingsVM.isRandomSwitchOn];
    [self.horizontalTransitionSwitch setOn:settingsVM.isHorizontalSwitchOn];
    [self.verticalTransitionSwitch setOn:settingsVM.isVerticalSwitchOn];
    [self.normalTransitionSwitch setOn:settingsVM.isNormalSwitchOn];
    [self.gravityTransitionSwitch setOn:settingsVM.isGravitySwitchOn];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)valueChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.transitionType = aSwitch.tag;
    NSLog(@"Transition type: %d",appDelegate.transitionType);
    [self refreshSwitchButtonStates];
}

@end

@implementation SettingsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

        if (appDelegate.transitionType == 0) {
            self.isHorizontalSwitchOn = YES;
        }
        else if (appDelegate.transitionType == 1) {
            self.isVerticalSwitchOn   = YES;
        }
        else if (appDelegate.transitionType == 2) {
            self.isGravitySwitchOn     = YES;
        }
        else if (appDelegate.transitionType == 3) {
            self.isNormalSwitchOn      = YES;
        }
        else if (appDelegate.transitionType == 4) {
            self.isRandomSwitchOn      = YES;
        }
    }
    return self;
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
    
//    self.movableImageView.frame = CGRectMake(self.movableImageView.frame.origin.x,self.movableImageView.frame.origin.y +30, self.movableImageView.frame.size.width, self.movableImageView.frame.size.height -30);
}
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


@end
