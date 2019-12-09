//  ConnectAdInterstitial.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConnectAd.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MoPub.h"
#import "ConnectInterstitialView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConnectAdInterstitial: NSObject<MPInterstitialAdControllerDelegate, GADInterstitialDelegate>


@property(nonatomic, assign)AdType adType;
@property(strong,nonatomic)UIViewController *rootViewController;
@property(strong,nonatomic)NSString *adMobConnectId;
@property(strong,nonatomic)NSString *moPubConnectId;
@property(strong,nonatomic)NSMutableArray<AdId *> *adMobInterstitials;
@property(strong,nonatomic)NSMutableArray<AdId *> *moPubInterstitials;
@property(strong,nonatomic)NSMutableArray *ConnectAdInterstitials;
@property(strong,nonatomic)GADInterstitial *adMobInterstitial;
@property(strong,nonatomic)MPInterstitialAdController *moPubInterstitial;
@property(strong,nonatomic)NSMutableArray *interstitialOrders;
@property(strong,nonatomic)NSMutableArray *adMobConnectIds;
@property(strong,nonatomic)NSMutableArray *moPubConnectIds;
@property (assign) id <ConnectAdInterstitialDelegate> delegate;
-(id)init:(NSMutableArray*)adMobIDs :(NSMutableArray*)moPubIDs;
-(void)loadFrom: (UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
