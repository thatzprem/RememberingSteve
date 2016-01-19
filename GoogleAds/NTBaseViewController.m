//
//  NTBaseViewController.m
//  HSLL
//
//  Created by Prem kumar on 21/01/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "NTBaseViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "SampleConstants.h"
#import "AppDelegate.h"
#import "GADInterstitial.h"
#define interstitialAdsRollOverCount 8

@interface NTBaseViewController ()<GADInterstitialDelegate>
@property (nonatomic,strong) GADInterstitial *interstitial;

@end

@implementation NTBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self requestBannerForAds];

}
-(void)requestBannerForAds{
    CGPoint origin = CGPointMake(0.0,self.view.frame.size.height - 50);
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
    self.adBanner.adUnitID = kBannerAdUnitID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[GADRequest request]];
}

- (void)showInterstitial:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%d",appDelegate.countToPresentInterstitialAd);
        
    if (appDelegate.countToPresentInterstitialAd >= interstitialAdsRollOverCount) {
        appDelegate.countToPresentInterstitialAd = 0;
        self.interstitial = [[GADInterstitial alloc] init];
        self.interstitial.delegate = self;
        self.interstitial.adUnitID = kInterstialAdUnitID;
        [self.interstitial loadRequest: [self createRequest]];
    }
    else{
        appDelegate.countToPresentInterstitialAd++;
    }
}

// Here we're creating a simple GADRequest and whitelisting the application
// for test ads. You should request test ads during development to avoid
// generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
//    request.testDevices =
//    [NSArray arrayWithObjects:@"a9baa1ece25019bd10c76d767e66688a", nil];
    request.testDevices =
    [NSArray arrayWithObjects:
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
     nil];
    return request;
}


- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [self.view bringSubviewToFront:self.adBanner];
    NSLog(@"Received ad successfully");
    
}
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    // Alert the error.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"GADRequestError"
                          message:[error localizedDescription]
                          delegate:nil cancelButtonTitle:@"Drat"
                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showInterstitial:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
