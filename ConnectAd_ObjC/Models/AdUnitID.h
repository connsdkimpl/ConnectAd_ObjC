//  AdOrder.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdUnitID: NSObject

@property(strong,nonatomic)NSString *appId;
@property(strong,nonatomic)NSString *adUnitName;
@property(strong,nonatomic)NSMutableArray *rewardedVideo;
@property(strong,nonatomic)NSMutableArray *banner;
@property(strong,nonatomic)NSMutableArray *interstitial;

@end

NS_ASSUME_NONNULL_END
