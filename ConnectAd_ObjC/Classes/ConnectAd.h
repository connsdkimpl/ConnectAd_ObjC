//  ConnectAd.h

#import <Foundation/Foundation.h>
#import "Ad.h"
#import "AdUnitID.h"
#import "VASTAdUnit.h"
#import "AdId.h"
#import "ConnectedAdUnit.h"
#import "AdReward.h"

typedef NS_ENUM(NSInteger, AdType) {
    // Vertical
    ADMOB,
    MOPUB,
    CONNECT
};

typedef enum AdKey {
    admob,
    mopub,
} FormatType;

extern NSString * _Nullable const AdKeyToString[];

typedef enum: int {
    AdMobOrder = 1 ,
    MoPubOrder = 2 ,
    ConnectOrder = 3
}AdOrder;

@protocol ConnectAdBannerDelegate

#pragma mark: Banner
-(void)onBannerDone:(AdType)adType;
-(void)onBannerFailed:(AdType)adType withError:(NSError*_Nullable)error;
-(void)onBannerExpanded:(AdType)adType;
-(void)onBannerCollapsed:(AdType)adType;
-(void)onBannerClicked:(AdType)adType;

 @end

@protocol ConnectAdRewardedDelegate

#pragma mark: RewardedVideo
-(void)onRewardVideoClosed:(AdType)adType;
-(void)onRewardFail:(AdType)adType withError:(NSError*_Nullable)error;
-(void)onRewardVideoStarted:(AdType)adType;
-(void)onRewardedVideoCompleted:(AdType)adType withReward:(AdReward*_Nullable) rewardItem;
-(void)onRewardVideoClicked:(AdType)adType;

@end

@protocol ConnectAdInterstitialDelegate

#pragma mark: Interstitial
-(void)onInterstitialClicked:(AdType)adType;
-(void)onInterstitialClosed:(AdType)adType;
-(void)onInterstitialDone:(AdType)adType;
-(void)onInterstitialFailed:(AdType)adType withError:(NSError*_Nullable)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ConnectAd: NSObject

+(void)connectAdInit:(NSString*)appId completion:(void (^ __nullable)(NSMutableDictionary *response, NSError *error))completion;
@property(strong,nonatomic)Ad *ad;
//@property (assign) id <ConnectAdDelegate> delegate;
+(ConnectAd*)sharedInstance;
@property (nonatomic, assign) AdType adType;

@end

NS_ASSUME_NONNULL_END
