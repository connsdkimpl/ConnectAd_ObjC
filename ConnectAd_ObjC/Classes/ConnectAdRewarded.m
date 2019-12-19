//  ConnectAdRewarded.m

#import "ConnectAdRewarded.h"

@implementation ConnectAdRewarded
@synthesize moPubConnectId,adMobConnectId,rootViewController;


-(id)init:(NSMutableArray*)adMobIDs :(NSMutableArray*)moPubIDs {
    if ([adMobIDs count] != 0) {
        self.adMobConnectIds = adMobIDs;
    }
    if ([moPubIDs count] != 0) {
        self.moPubConnectIds = moPubIDs;
    }
    return self;

}

-(void)loadFrom: (UIViewController*)viewController{
    NSArray *orderArray = [[ConnectAd sharedInstance].ad.adOrder copy];
    self.rewardedOrders = [[NSMutableArray alloc]init];
    [self.rewardedOrders addObjectsFromArray:orderArray];
    self.rootViewController = viewController;
    if ([ConnectAd sharedInstance].ad != nil) {
        Ad *ad = [ConnectAd sharedInstance].ad;
        NSMutableArray *adUnitIds = ad.adUnitIds;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"adUnitName = %@", AdKeyToString[admob]];
        NSArray *filtered = [adUnitIds filteredArrayUsingPredicate:predicate];
        if (filtered != nil && [filtered count] != 0) {
            AdUnitID *adUnitID = filtered.firstObject;
            NSMutableArray * rewardsArray = adUnitID.rewardedVideo;
            if(rewardsArray.count != 0) {
                self.adMobRewardeds = rewardsArray;
            }

        }

        NSPredicate *predicate_moPub = [NSPredicate predicateWithFormat:@"adUnitName = %@", AdKeyToString[mopub]];
        NSArray *filtered_moPub = [adUnitIds filteredArrayUsingPredicate:predicate_moPub];
        if (filtered_moPub != nil && [filtered_moPub count] != 0) {
            AdUnitID *adUnitID_moPub = filtered_moPub.firstObject;
            NSMutableArray * rewardsArray_moPub = adUnitID_moPub.rewardedVideo;
            if(rewardsArray_moPub.count != 0) {
                self.moPubRewardeds = rewardsArray_moPub;
            }
        }
    }
    [self loadNewAds];
}
-(void)loadNewAds {
    if(![self.rewardedOrders firstObject]) {
        NSLog(@"No reward found");
        [self.delegate onRewardNotFound];
    } else {
        NSInteger rewardedOrder = [self.rewardedOrders.firstObject integerValue];
        switch (rewardedOrder) {
            case MoPubOrder:
                self.adType = MOPUB;
                [self setMoPubRewarded];
                break;
            case AdMobOrder:
                self.adType = ADMOB;
                [self setAdMobRewarded];
                break;
            default:
                [self.rewardedOrders removeObjectAtIndex:0];
                [self loadNewAds];
                break;
        }
    }

}
-(void)setAdMobRewarded {
    self.adMobConnectId = self.adMobConnectIds.firstObject;
    NSString *rewardedAdUnitId = @"";
    if (self.adMobConnectId != nil) {
        for (int i = 0; i< self.adMobRewardeds.count; i++) {
            AdId *adId = [self.adMobRewardeds objectAtIndex:i];
            if ([adId.connectedId isEqualToString:self.adMobConnectId]) {
                AdId *rewardedAd = [self.adMobRewardeds objectAtIndex:i];
                if(rewardedAd.adUnitId != nil) {
                    NSString *adUnitId = rewardedAd.adUnitId;
                    rewardedAdUnitId = adUnitId;
                }
                break;
            }
        }
    }
    GADRequest *request = [GADRequest request];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:rewardedAdUnitId];

}
-(void)setMoPubRewarded {
    self.moPubConnectId = self.moPubConnectIds.firstObject;
    NSString *rewardedAdUnitId = @"";
    if (self.moPubConnectId != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connectedId = %@", self.moPubConnectId];
        AdId *rewardedAd = [self.moPubRewardeds filteredArrayUsingPredicate:predicate].firstObject;
        if (rewardedAd.adUnitId != nil) {
            rewardedAdUnitId = rewardedAd.adUnitId;
        }
    }
    [MPRewardedVideo setDelegate:self forAdUnitId:rewardedAdUnitId];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:rewardedAdUnitId withMediationSettings:nil];
}
#pragma mark: Admob
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    AdReward *rewardVideoReward = [[AdReward alloc]init];
    rewardVideoReward.currencyType = reward.type;
    rewardVideoReward.rewardAmount = [reward.amount intValue];
    [self.delegate onRewardedVideoCompleted:self.adType withReward:rewardVideoReward];
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    if ([[GADRewardBasedVideoAd sharedInstance] isReady] == true) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:rootViewController];
    }
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self.delegate onRewardVideoStarted:self.adType];
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self.delegate onRewardVideoClosed:self.adType];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    [self.delegate onRewardFail:self.adType withError:error];
    if ([self.adMobConnectIds count] != 0) {
        [self.adMobConnectIds removeObjectAtIndex:0];
        if ([self.adMobConnectIds count] != 0) {
            [self setAdMobRewarded];
        } else {
            if ([self.rewardedOrders count] != 0) {
                [self.rewardedOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.rewardedOrders count] != 0) {
            [self.rewardedOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

-(void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self.delegate onRewardVideoClicked:self.adType];
}

#pragma mark: Mopub

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    // Called when the video for the given adUnitId has loaded. At this point you should be able to call presentRewardedVideoAdForAdUnitID to show the video.
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:adUnitID]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:adUnitID fromViewController:rootViewController withReward:nil];
    }

}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error{
    // Called when a video fails to load for the given adUnitId. The provided error code will provide more insight into the reason for the failure to load.
    [self.delegate onRewardFail:self.adType withError:error];
    if ([self.moPubConnectIds count] != 0) {
        [self.moPubConnectIds removeObjectAtIndex:0];
        if ([self.moPubConnectIds count] != 0) {
            [self setMoPubRewarded];
        } else {
            if ([self.rewardedOrders count] != 0) {
                [self.rewardedOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.rewardedOrders count] != 0) {
            [self.rewardedOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    //  Called when there is an error during video playback.
    [self.delegate onRewardFail:self.adType withError:error];
    if ([self.moPubConnectIds count] != 0) {
        [self.moPubConnectIds removeObjectAtIndex:0];
        if ([self.moPubConnectIds count] != 0) {
            [self setMoPubRewarded];
        } else {
            if ([self.rewardedOrders count] != 0) {
                [self.rewardedOrders removeObjectAtIndex:0];
                [self loadNewAds];
            }
        }
    } else {
        if ([self.rewardedOrders count] != 0) {
            [self.rewardedOrders removeObjectAtIndex:0];
            [self loadNewAds];
        }
    }
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID{
    // Called when a rewarded video starts playing.
    [self.delegate onRewardVideoStarted:self.adType];
}


- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID{
    // Called when a rewarded video is closed. At this point your application should resume.
    [self.delegate onRewardVideoClosed:self.adType];
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward{
    // Called when a rewarded video is completed and the user should be rewarded.
    AdReward *rewardVideoReward = [[AdReward alloc]init];
    rewardVideoReward.currencyType = reward.currencyType;
    rewardVideoReward.rewardAmount = [reward.amount intValue];
    [self.delegate onRewardedVideoCompleted:self.adType withReward:rewardVideoReward];
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID{
    [self.delegate onRewardVideoClicked:self.adType];
}

@end


