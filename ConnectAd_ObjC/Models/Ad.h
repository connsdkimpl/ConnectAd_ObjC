//  Ad.h

#import <Foundation/Foundation.h>
#import "AdUnitID.h"
#import "VASTAdUnit.h"
#import "ConnectedAdUnit.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ad: NSObject

@property(strong,nonatomic)NSString *status;
@property(strong,nonatomic)NSString *id;
@property(strong,nonatomic)NSMutableArray *adOrder;
@property(strong,nonatomic)NSMutableArray<AdUnitID *> *adUnitIds;
@property(strong,nonatomic)NSMutableArray *vastAdUnits;
@property(strong,nonatomic)ConnectedAdUnit *connectedAdUnit;
- (instancetype)initWithJSONString:(NSDictionary *)JSONDictionary;
@end

NS_ASSUME_NONNULL_END
