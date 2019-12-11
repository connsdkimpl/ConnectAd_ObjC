//  AdReward.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdReward: NSObject

@property(strong,nonatomic)NSString *currencyType;
@property(readwrite)NSInteger rewardAmount;

@end

NS_ASSUME_NONNULL_END
