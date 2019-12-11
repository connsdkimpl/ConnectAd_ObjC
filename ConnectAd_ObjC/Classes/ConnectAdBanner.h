//  ConnectAdBanner.h

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MoPub.h"
#import "ConnectAd.h"
#import "ConnectBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConnectAdBanner: UIView<GADBannerViewDelegate, MPAdViewDelegate>

@property(strong,nonatomic)UIViewController *rootViewController;
@property(strong,nonatomic)GADBannerView *adMobBannerView;
@property(strong,nonatomic)MPAdView *moPubBannerView;
@property(strong,nonatomic)ConnectBannerView *connectBannerView;
@property(strong,nonatomic)NSMutableArray<AdId *> *adMobBanners;
@property(strong,nonatomic)NSMutableArray<AdId *> *moPubBanners;
@property(nonatomic, assign)AdType adType;
@property(strong,nonatomic)NSString *adMobConnectId;
@property(strong,nonatomic)NSString *moPubConnectId;
@property(strong,nonatomic)NSMutableArray *connectAdBanners;
@property (assign) id <ConnectAdBannerDelegate> delegate;
-(void)loadAds;
@property(strong,nonatomic)NSMutableArray *bannerOrders;
@property(strong,nonatomic)NSMutableArray *adMobConnectIds;
@property(strong,nonatomic)NSMutableArray *moPubConnectIds;

- (id)initWithAdPosition:(int)position parentView:(UIView*)parentView;

@end

NS_ASSUME_NONNULL_END
