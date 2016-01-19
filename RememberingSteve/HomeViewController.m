//
//  HomeViewController.m
//  RememberingSteve
//
//  Created by Prem kumar on 03/08/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "HomeViewController.h"
#import "ZBFallenBricksAnimator.h"
#import "HUTransitionAnimator.h"
#import "NSJSONSerialization+Additions.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"


@interface HomeViewController ()<UINavigationControllerDelegate>
{
    TransitionType type;
}

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL hasAlertOnScreen;
@property (nonatomic,strong) GADBannerView *adView;

@end

@implementation HomeViewController

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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.hasAlertOnScreen = NO;
    
    type = TransitionTypeNormal;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fetchNewData) userInfo:nil repeats:YES];
   [self.timer fire];

    self.navigationController.delegate = self;
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
        {
        NSLog(@"Notification Says Reachable");
        }
    else
        {
        NSLog(@"Notification Says Un Reachable");
        
        }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)fetchNewData {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *generateRandomMessageURL = [self generateRandomMessageURL];

        NSString *urlString = generateRandomMessageURL;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *jsonString = [NSJSONSerialization convertNSDataToJsonString:data];
            NSDictionary *jsonDictionary = [NSJSONSerialization convertJsonStringToDictionary:jsonString];
            
            dispatch_async (dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                
                if(appDelegate.transitionType == TransitionTypeRandom){
                    [self pushRandomViewController:jsonDictionary];
                }
                else{
                    [self pushViewController:jsonDictionary :appDelegate.transitionType];
                }
            });        
        }];
        
        [postDataTask resume];
    });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.hasAlertOnScreen == NO) {
            self.hasAlertOnScreen = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    });
    };
    
    [reach startNotifier];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.hasAlertOnScreen == YES) {
        self.hasAlertOnScreen = NO;
    }
}

- (NSString *)generateRandomMessageURL{
    NSString *urlString = [NSString stringWithFormat:@"http://www.apple.com/media/us/stevejobs/messages/%d.json?25978580",arc4random() % 10000];
    NSLog(@"URL %@",urlString);
    return urlString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushRandomViewController:(NSDictionary *)detailsDictionary {
    
    int r = arc4random() % 3;
    switch (r) {
        case 0:
            type = TransitionTypeVerticalLines;
            break;
            
        case 1:
            type = TransitionTypeHorizontalLines;
            break;
            
        case 2:
            type = TransitionTypeGravity;
            break;
    }
    
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    vc.detailsDictionary = detailsDictionary;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushViewController:(NSDictionary *)detailsDictionary :(TransitionType)transitionType{
    
    switch (transitionType) {
        case 0:
            type = TransitionTypeHorizontalLines;
            break;
        case 1:
            type = TransitionTypeVerticalLines;
            break;
            
        case 2:
            type = TransitionTypeGravity;
            break;
            
        case 3:
            type = TransitionTypeNormal;
            break;
        case 4:
            type = TransitionTypeRandom;
            break;
    }
    
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    vc.detailsDictionary = detailsDictionary;
    [self.navigationController pushViewController:vc animated:YES];
}

// =============================================================================
#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    NSObject <UIViewControllerAnimatedTransitioning> *animator;
    
    switch (type) {
        case TransitionTypeVerticalLines:
            animator = [[HUTransitionVerticalLinesAnimator alloc] init];
            [(HUTransitionAnimator *)animator setPresenting:NO];
            break;
        case TransitionTypeHorizontalLines:
            animator = [[HUTransitionHorizontalLinesAnimator alloc] init];
            [(HUTransitionAnimator *)animator setPresenting:NO];
            break;
        case TransitionTypeGravity:
            animator = [[ZBFallenBricksAnimator alloc] init];
            break;
        default:
            animator = nil;
    }
  return animator;
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
        //        CGPoint origin = CGPointMake(0.0,self.view.frame.size.height - 50);
        
        CGRect newaAdview = self.adView.frame;
        newaAdview.origin.y = self.view.frame.size.height - 50;
        newaAdview.size.width = self.view.frame.size.width;
        
        self.adView.frame = newaAdview;
    }
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        //        CGPoint origin = CGPointMake(0.0,self.view.frame.size.height - 50);
        
        CGRect newaAdview = self.adView.frame;
        newaAdview.origin.y = self.view.frame.size.height - 50;
        newaAdview.size.width = self.view.frame.size.width;
        self.adView.frame = newaAdview;
    }
    
}

@end
