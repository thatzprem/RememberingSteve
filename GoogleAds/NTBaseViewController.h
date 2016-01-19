//
//  NTBaseViewController.h
//  HSLL
//
//  Created by Prem kumar on 21/01/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"
#import "DFPBannerView.h"

@class GADBannerView;
@class GADRequest;

@interface NTBaseViewController : UIViewController<GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;
-(void)requestBannerForAds;

@end
