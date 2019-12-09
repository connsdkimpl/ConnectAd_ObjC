//
//  ConnectAdRewarded.h
//  Connect
//
//  Created by Rukmini KR on 07/08/19.
//  Copyright © 2019 Rukmini KR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConnectAd.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MoPub.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConnectAdRewarded: NSObject<GADRewardBasedVideoAdDelegate, MPRewardedVideoDelegate>

@property(strong,nonatomic)NSString *adMobConnectId;
@property(strong,nonatomic)NSString *moPubConnectId;
@property(strong,nonatomic)UIViewController *rootViewController;
@property (assign) id <ConnectAdRewardedDelegate> delegate;
@property(strong,nonatomic)NSMutableArray<AdId *> *adMobRewardeds;
@property(strong,nonatomic)NSMutableArray<AdId *> *moPubRewardeds;
@property(nonatomic, assign)AdType adType;
@property(strong,nonatomic)MPRewardedVideo *PRewardedVideo;
@property(strong,nonatomic)NSMutableArray *rewardedOrders;
-(id)init:(NSMutableArray*)adMobIDs :(NSMutableArray*)moPubIDs;
-(void)loadFrom: (UIViewController*)viewController;
@property(strong,nonatomic)NSMutableArray *adMobConnectIds;
@property(strong,nonatomic)NSMutableArray *moPubConnectIds;
@end

NS_ASSUME_NONNULL_END
