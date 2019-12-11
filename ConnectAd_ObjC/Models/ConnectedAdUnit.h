//  ConnectedAdUnit.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectedAdUnit: NSObject

@property(strong,nonatomic)NSMutableArray *banner;
@property(strong,nonatomic)NSMutableArray *interstitial;

@end

NS_ASSUME_NONNULL_END
