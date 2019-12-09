//  ConnectAdBanner.m

#import "ConnectAdBanner.h"

@implementation ConnectAdBanner
@synthesize delegate;

- (id)initWithFrame:(CGRect)theFrame {
    self = [super initWithFrame:theFrame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]) {
    }
    return self;
}

-(void)loadAds {
    NSArray *orderArray = [[ConnectAd sharedInstance].ad.adOrder copy];
    self.bannerOrders = [[NSMutableArray alloc]init];
    [self.bannerOrders addObjectsFromArray:orderArray];
    if ([ConnectAd sharedInstance].ad != nil) {
        Ad *ad = [ConnectAd sharedInstance].ad;
        NSMutableArray *adUnitIds = ad.adUnitIds;
        if ([adUnitIds count] != 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"adUnitName = %@", AdKeyToString[admob]];
            NSArray *filtered = [adUnitIds filteredArrayUsingPredicate:predicate];
            if (filtered != nil && [filtered count] != 0) {
                AdUnitID *adUnitID = filtered.firstObject;
                NSMutableArray * bannerArray = adUnitID.banner;
                if(bannerArray.count != 0) {
                    self.adMobBanners = bannerArray;
                }
            }

            NSPredicate *predicate_moPub = [NSPredicate predicateWithFormat:@"adUnitName = %@", AdKeyToString[mopub]];
            NSArray *filtered_moPub = [adUnitIds filteredArrayUsingPredicate:predicate_moPub];
            if (filtered_moPub != nil && [filtered_moPub count] != 0) {
                AdUnitID *adUnitID_moPub = filtered_moPub.firstObject;
                NSMutableArray * bannerArray_moPub = adUnitID_moPub.banner;
                if(bannerArray_moPub.count != 0) {
                    self.moPubBanners = bannerArray_moPub;
                }
            }
        }
        if (ad.connectedAdUnit != nil) {
            if ([ad.connectedAdUnit.banner count] != 0) {
                self.connectAdBanners = ad.connectedAdUnit.banner;

            }
        }

    }
    [self loadNewAds];
}

-(void)loadNewAds {
    if(![self.bannerOrders firstObject]) {
        NSLog(@"No banner found");
    } else {
        NSInteger bannerOrder = [self.bannerOrders.firstObject integerValue];
        switch (bannerOrder) {
            case AdMobOrder:
                self.adType = ADMOB;
                [self setAdMobBanner];
                break;
            case MoPubOrder:
                self.adType = MOPUB;
                [self setMoPubBanner];
                break;
            case ConnectOrder:
                self.adType = CONNECT;
                [self setConnectAd];
                break;
            default:
                break;
        }
    }
}

-(void)setAdMobBanner {
    self.adMobConnectId = self.adMobConnectIds.firstObject;
    self.adMobBannerView = [[GADBannerView alloc]
                            initWithAdSize:kGADAdSizeBanner];

    [self addBannerView:self.adMobBannerView];
    NSString *bannerAdUnitId = @"";
    if (self.adMobConnectId != nil) {
        if ([self.adMobBanners count] != 0) {
            for (int i = 0; i< self.adMobBanners.count; i++) {
                AdId *adId = [self.adMobBanners objectAtIndex:i];
                if ([adId.connectedId isEqualToString:self.adMobConnectId]) {
                    bannerAdUnitId = adId.adUnitId;
                }
            }
        }
    }
    GADRequest *request = [GADRequest request];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =  @[ @"eaf8e70bb9a7864dd6151678d225a768"];
    self.adMobBannerView.adUnitID = bannerAdUnitId;
    self.adMobBannerView.delegate = self;
    self.adMobBannerView.rootViewController = self.rootViewController;
    [self.adMobBannerView loadRequest:request];
}
-(void)setMoPubBanner{
    self.moPubConnectId = self.moPubConnectIds.firstObject;
    NSString *bannerAdUnitId = @"";
    if (self.moPubConnectId != nil) {
        if ([self.moPubBanners count] != 0) {
            for (int i = 0; i< self.moPubBanners.count; i++) {
                AdId *adId = [self.moPubBanners objectAtIndex:i];
                if ([adId.connectedId isEqualToString:self.moPubConnectId]) {
                    bannerAdUnitId = adId.adUnitId;
                }
            }
        }
    }
    self.moPubBannerView = [[MPAdView alloc]initWithAdUnitId:bannerAdUnitId];
    self.moPubBannerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.moPubBannerView.delegate = self;
    [self addBannerView:self.moPubBannerView];
    [self.moPubBannerView loadAdWithMaxAdSize:kMPPresetMaxAdSizeMatchFrame];
}

-(void)setConnectAd{
    NSString *bannerAdUnitUrl = @"";
    if([self.connectAdBanners count] != 0){
        bannerAdUnitUrl = self.connectAdBanners.firstObject;
        NSURL *url = [[NSURL alloc]initWithString:bannerAdUnitUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200)
            {
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                if ([[responseDictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                    NSDictionary *componentDict = [responseDictionary valueForKey:@"components"];
                    if ([componentDict valueForKey:@"html"] != nil) {
                        NSString *htmlString = [componentDict valueForKey:@"html"];
                        [self showConnectBanner:htmlString];
                    } else {
                        NSError *htlmlError = [NSError errorWithDomain:@"ConnctedAd" code:201 userInfo:@{NSLocalizedDescriptionKey:@"html data not found"}];
                        [self.delegate onBannerFailed:self.adType withError:htlmlError];

                    }

                } else {
                    [self.delegate onBannerFailed:self.adType withError:parseError];

                }
            } else {
                NSLog(@"Error");
                [self.delegate onBannerFailed:self.adType withError:error];

            }
        }];
        [dataTask resume];
    }
}
-(void)showConnectBanner:(NSString *)htmlString {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.connectBannerView = [[ConnectBannerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.connectBannerView.delegate = self.delegate;
        [self.connectBannerView load:htmlString];
        [self addBannerView:self.connectBannerView];
    });
}

-(void)addBannerView:(UIView*)bannerView {
    [self addSubview:bannerView];
}
-(void)removeBannerView:(UIView*)bannerView {
    [bannerView removeFromSuperview];
}

//Delegate - GAD
- (void)adViewDidReceiveAd:(nonnull GADBannerView *)bannerView{
    NSLog(@"adViewDidReceiveAd");
    bannerView.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        bannerView.alpha = 1;
    }];
    [self.delegate onBannerDone:self.adType];
}

- (void)adView:(nonnull GADBannerView *)bannerView
didFailToReceiveAdWithError:(nonnull GADRequestError *)error{
    NSLog(@"adView:didFailToReceiveAdWithError: %@",[error localizedDescription]);
    [self removeBannerView:self.adMobBannerView];
    self.adMobBannerView = [[GADBannerView alloc]init];
    self.adMobBannerView .hidden = YES;
    [self.delegate onBannerFailed:self.adType withError:error];
    if ([self.adMobConnectIds count] != 0) {
        [self.adMobConnectIds removeObjectAtIndex:0];
        if (self.adMobConnectIds.count != 0) {
            [self setAdMobBanner];
        } else {
            if ([self.bannerOrders count] != 0) {
                [self.bannerOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.bannerOrders count] != 0) {
            [self.bannerOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

- (void)adViewWillPresentScreen:(nonnull GADBannerView *)bannerView {
    NSLog(@"adViewWillPresentScreen");
    [self.delegate onBannerExpanded:self.adType];
    [self.delegate onBannerClicked:self.adType];

}

//- (void)adViewWillDismissScreen:(nonnull GADBannerView *)bannerView {
//  NSLog(@"adViewWillDismissScreen");
//  [self.delegate connectedAdViewWillDismissScreen:self.adType];
//
//}

- (void)adViewDidDismissScreen:(nonnull GADBannerView *)bannerView{
    NSLog(@"adViewDidDismissScreen");
    [self.delegate onBannerCollapsed:self.adType];

}

//onclick of banner - Admob
- (void)adViewWillLeaveApplication:(nonnull GADBannerView *)bannerView{
    NSLog(@"Sent when the user has tapped on the banner.");
    NSLog(@"adViewWillLeaveApplication");
    [self.delegate onBannerClicked:self.adType];

}
//MAP
- (UIViewController *)viewControllerForPresentingModalView {
    return self.rootViewController;
}
- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize{
    NSLog(@"adViewDidLoadAd");
    [self.delegate onBannerDone:self.adType];
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error{
    NSLog(@"adViewDidFail %@",[error localizedDescription]);
    [self.delegate onBannerFailed:self.adType withError:error];
    [view stopAutomaticallyRefreshingContents];
    [self removeBannerView:self.moPubBannerView];
    if([self.adMobConnectIds count] != 0) {
        [self.moPubConnectIds removeObjectAtIndex:0];
        if ([self.moPubConnectIds count] != 0) {
            [self setMoPubBanner];
        } else {
            if (self.bannerOrders.count != 0) {
                [self.bannerOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if (self.bannerOrders.count != 0) {
            [self.bannerOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

- (void)willPresentModalViewForAd:(MPAdView *)view{
    NSLog(@"willPresentModalView");
    [self.delegate onBannerClicked:self.adType];
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view{
    NSLog(@"willLeaveApplication");
    [self.delegate onBannerClicked:self.adType];
}

@end