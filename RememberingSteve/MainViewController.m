//
//  MainViewController.m
//  RememberingSteve
//
//  Created by Prem kumar on 02/08/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "MainViewController.h"

#define kDownloadURL @"http://www.apple.com/media/us/stevejobs/messages/10000.json?25978580"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,strong) NSMutableArray *fontNamesArray;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *Header;
@property (nonatomic,strong) GADBannerView *adView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setUpFontNamesArray];
    [self fillRandomBackgroundColor];
//    [self pickRandomFont];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    
    NSString *mainText = [self.detailsDictionary objectForKey:@"mainText"];
    mainText = [mainText stringByReplacingOccurrencesOfString: @"&nbsp;" withString:@""];

    NSString *location = [self.detailsDictionary objectForKey:@"location"];
    NSString *author = [self.detailsDictionary objectForKey:@"author"];
    author = [author stringByReplacingOccurrencesOfString: @"&nbsp;" withString:@""];
    
    if (location != nil && (![location isEqualToString:@""])) {
        author = [author stringByAppendingString:[NSString stringWithFormat:@" ,%@",location]];
    }

    NSString *header = [self.detailsDictionary objectForKey:@"header"];
    
    if (header == nil || [header isEqualToString:@""]) {
        header = @"Remembering Steve!";
    }
    header = [header stringByReplacingOccurrencesOfString: @"&nbsp;" withString:@""];

    self.descriptionLabel.text = mainText;
    self.author.text = author;
    self.Header.text = [header uppercaseString];

}

- (void)setUpFontNamesArray {
    self.fontNamesArray = [NSMutableArray array];
    NSArray *familyNames = [UIFont familyNames];
    for (NSString *fontName in familyNames)
        [self.fontNamesArray addObject:fontName];
}

- (void)fillRandomBackgroundColor {
    
    CGFloat redLevel    = rand() / (float) RAND_MAX;
    CGFloat greenLevel  = rand() / (float) RAND_MAX;
    CGFloat blueLevel   = rand() / (float) RAND_MAX;
    
    self.backgroundView.backgroundColor= [UIColor colorWithRed:redLevel green:greenLevel blue:blueLevel alpha:1.0];
}

- (void)pickRandomFont {
    NSUInteger randomIndex = arc4random() % [self.fontNamesArray count];
    self.descriptionLabel.font = self.Header.font = self.author.font = [UIFont fontWithName:self.fontNamesArray[randomIndex] size:28.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {

    self.adView = adView;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        //        CGPoint origin = CGPointMake(0.0,self.view.frame.size.height - 50);
        
        CGRect newaAdview = adView.frame;
        newaAdview.origin.y = self.view.frame.size.height - 50;
        newaAdview.size.width = self.view.frame.size.width;

        adView.frame = newaAdview;
    }
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        //        CGPoint origin = CGPointMake(0.0,self.view.frame.size.height - 50);
        
        CGRect newaAdview = adView.frame;
        newaAdview.origin.y = self.view.frame.size.height - 50;
        newaAdview.size.width = self.view.frame.size.width;
        adView.frame = newaAdview;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {

        CGRect newaAdview = self.adView.frame;
        newaAdview.origin.y = self.view.frame.size.height - 50;
        newaAdview.size.width = self.view.frame.size.width;
        
        self.adView.frame = newaAdview;
    }
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        
        CGRect newaAdview = self.adView.frame;
        newaAdview.origin.y = self.view.frame.size.height - 50;
        newaAdview.size.width = self.view.frame.size.width;
        self.adView.frame = newaAdview;
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
//        [[segue destinationViewController] setDelegate:self];
//        
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
//            self.flipsidePopoverController = popoverController;
//            popoverController.delegate = self;
//        }
//    }
}

//- (IBAction)togglePopover:(id)sender
//{
//    if (self.flipsidePopoverController) {
//        [self.flipsidePopoverController dismissPopoverAnimated:YES];
//        self.flipsidePopoverController = nil;
//    } else {
//        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
//    }
//}

@end
