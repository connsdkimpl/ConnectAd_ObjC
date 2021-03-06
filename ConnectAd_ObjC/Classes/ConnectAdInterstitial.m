//  ConnectAdInterstitial.m

#import "ConnectAdInterstitial.h"

@implementation ConnectAdInterstitial
@synthesize moPubConnectId,adMobConnectId,interstitialOrders;

-(id)init:(NSMutableArray*)adMobIDs :(NSMutableArray*)moPubIDs {
    if ([adMobIDs count] !=0) {
        self.adMobConnectIds = adMobIDs;
    }
    if ([moPubIDs count] !=0) {
        self.moPubConnectIds = moPubIDs;
    }
    return self;
}

-(void)loadFrom: (UIViewController*)viewController{
    NSArray *orderArray = [[ConnectAd sharedInstance].ad.adOrder copy];
    self.interstitialOrders = [[NSMutableArray alloc]init];
    [self.interstitialOrders addObjectsFromArray:orderArray];
    self.rootViewController = viewController;
    if ([ConnectAd sharedInstance].ad != nil) {
        Ad *ad = [ConnectAd sharedInstance].ad;
        NSMutableArray *adUnitIds = ad.adUnitIds;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"adUnitName = %@", AdKeyToString[admob]];
        NSArray *filtered = [adUnitIds filteredArrayUsingPredicate:predicate];
        if (filtered != nil && [filtered count] != 0) {
            AdUnitID *adUnitID = filtered.firstObject;
            NSMutableArray * interstitialArray = adUnitID.interstitial;
            if(interstitialArray.count != 0) {
                self.adMobInterstitials = interstitialArray;
            }
        }

        NSPredicate *predicate_moPub = [NSPredicate predicateWithFormat:@"adUnitName = %@", AdKeyToString[mopub]];
        NSArray *filtered_moPub = [adUnitIds filteredArrayUsingPredicate:predicate_moPub];
        if (filtered_moPub != nil && [filtered_moPub count] != 0) {
            AdUnitID *adUnitID_moPub = filtered_moPub.firstObject;
            NSMutableArray * interstitial_moPub = adUnitID_moPub.interstitial;
            if(interstitial_moPub.count != 0) {
                self.moPubInterstitials = interstitial_moPub;
            }
        }
        if (ad.connectedAdUnit != nil && [ad.connectedAdUnit.interstitial count] != 0) {
            self.ConnectAdInterstitials = [[NSMutableArray alloc] initWithArray:ad.connectedAdUnit.interstitial copyItems:YES];
        }
    }
    [self loadNewAds];
}
-(void)loadNewAds{
    if(![self.interstitialOrders firstObject]) {
        NSLog(@"No Interstitial found");
        if (self.delegate != nil &&  [(NSObject*)self.delegate respondsToSelector:@selector(onInterstitialNoAdAvailable)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate onInterstitialNoAdAvailable]; 
            });
        }
    } else {
        NSInteger interstitialOrder = [self.interstitialOrders.firstObject integerValue];
        switch (interstitialOrder) {
            case MoPubOrder:
                self.adType = MOPUB;
                [self setMoPubInterstitial];
                break;
            case AdMobOrder:
                self.adType = ADMOB;
                [self setAdMobInterstitial];
                break;
            case ConnectOrder:
                self.adType = CONNECT;
                [self setConnectAd];
            default:
                break;
        }
    }
}

-(void)setMoPubInterstitial{
    self.moPubConnectId = self.moPubConnectIds.firstObject;
    NSString *interstitialAdUnitId = @"";
    if (self.moPubConnectId != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connectedId = %@", moPubConnectId];
        AdId *interstitialAd = [self.moPubInterstitials filteredArrayUsingPredicate:predicate].firstObject;
        if (interstitialAd.adUnitId != nil) {
            interstitialAdUnitId = interstitialAd.adUnitId;
        }
    }
    self.moPubInterstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:interstitialAdUnitId];
    self.moPubInterstitial.delegate = self;
    [self.moPubInterstitial loadAd];
}

-(void)setAdMobInterstitial{
    self.adMobConnectId = self.adMobConnectIds.firstObject;
    NSString *interstitialAdUnitId = @"";
    if(self.adMobConnectId != nil){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connectedId = %@", adMobConnectId];
        AdId *interstitialAd_Admob = [self.adMobInterstitials filteredArrayUsingPredicate:predicate].firstObject;
        if (interstitialAd_Admob.adUnitId != nil) {
            interstitialAdUnitId = interstitialAd_Admob.adUnitId;
        }

    }
    GADRequest *request = [GADRequest request];
    self.adMobInterstitial = [[GADInterstitial alloc]initWithAdUnitID:interstitialAdUnitId];
    self.adMobInterstitial.delegate = self;
    [self.adMobInterstitial loadRequest:request];
}

#pragma mark - ConnectAd
-(void)setConnectAd{
    NSString *interstitialAdUnitUrl = @"";
    if([self.ConnectAdInterstitials count] != 0){
        interstitialAdUnitUrl = self.ConnectAdInterstitials.firstObject;
        NSURL *url = [[NSURL alloc]initWithString:interstitialAdUnitUrl];
        // NSURL *url = [[NSURL alloc]initWithString:@""];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 10;
        sessionConfiguration.timeoutIntervalForResource = 10;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
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
                        [self showConnectInterstitial:htmlString];
                    } else {
                        NSError *htlmlError = [NSError errorWithDomain:@"ConnctedAd" code:201 userInfo:@{NSLocalizedDescriptionKey:@"html data not found"}];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate onInterstitialFailed:self.adType withError:htlmlError];
                        });
                        [self checkExistingConnectedAds];
                    }

                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate onInterstitialFailed:self.adType withError:parseError];
                    });

                    [self checkExistingConnectedAds];
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate onInterstitialFailed:self.adType withError:error];    
                });

                [self checkExistingConnectedAds];
            }
        }];
        [dataTask resume];
    }
}

-(void)checkExistingConnectedAds {
    if([self.ConnectAdInterstitials count] != 0) {
        [self.ConnectAdInterstitials removeObjectAtIndex:0];
        if ([self.ConnectAdInterstitials count] !=  0) {
            [self setConnectAd];
        } else {
            if ([self.interstitialOrders count] != 0) {
                [self.interstitialOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.interstitialOrders count] != 0) {
            [self.interstitialOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

-(void)showConnectInterstitial:(NSString*)htmlString {
    dispatch_async(dispatch_get_main_queue(), ^{
       NSString *replacedHtmlString = [htmlString stringByReplacingOccurrencesOfString:@"'//" withString:@"'https://"];
        [self.rootViewController presentViewController: [ConnectInterstitialView createInstance:replacedHtmlString withDelegate:self.delegate] animated:true completion:nil];
    });
}

#pragma mark: Admob
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    if ([self.adMobInterstitial isReady]) {
        [self.adMobInterstitial presentFromRootViewController:_rootViewController];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    [self.delegate onInterstitialFailed:self.adType withError:error];
    if([self.adMobConnectIds count] != 0) {
        [self.adMobConnectIds removeObjectAtIndex:0];
        if ([self.adMobConnectIds count] !=  0) {
            [self setAdMobInterstitial];
        } else {
            if ([self.interstitialOrders count] != 0) {
                [self.interstitialOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.interstitialOrders count] != 0) {
            [self.interstitialOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [self.delegate onInterstitialDone:self.adType];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    [self.delegate onInterstitialClosed:self.adType];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    [self.delegate onInterstitialClicked:self.adType];

}



#pragma mark: Mopub
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial{
    if ([self.moPubInterstitial ready]) {
        [self.moPubInterstitial showFromViewController:self.rootViewController];
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial{
    NSError *error = [NSError errorWithDomain:@"Error" code:201 userInfo:@{NSLocalizedDescriptionKey:@"Issue unknown.."}];
    [self.delegate onInterstitialFailed:self.adType withError:error];
    [MPInterstitialAdController removeSharedInterstitialAdController:interstitial];
    if([self.moPubConnectIds count] != 0) {
        [self.moPubConnectIds removeObjectAtIndex:0];
        if ([self.moPubConnectIds count] !=  0) {
            [self setMoPubInterstitial];
        } else {
            if ([self.interstitialOrders count] != 0) {
                [self.interstitialOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.interstitialOrders count] != 0) {
            [self.interstitialOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error{
    [self.delegate onInterstitialFailed:self.adType withError:error];
    [MPInterstitialAdController removeSharedInterstitialAdController:interstitial];
    if ([self.moPubConnectIds count] != 0) {
        [self.moPubConnectIds removeObjectAtIndex:0];
        if ([self.moPubConnectIds count] !=  0) {
            [self setMoPubInterstitial];
        } else {
            if ([self.interstitialOrders count] != 0) {
                [self.interstitialOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.interstitialOrders count] != 0) {
            [self.interstitialOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial{
    [self.delegate onInterstitialDone:self.adType];

}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial{
    [self.delegate onInterstitialClosed:self.adType];
}

-(void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial{
    [self.delegate onInterstitialClicked:self.adType];
}

@end
