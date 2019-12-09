//  VASTAdUnit.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VASTAdUnit: NSObject

@property(strong,nonatomic)NSString *vastUrl;
@property(readwrite)float price;

@end

NS_ASSUME_NONNULL_END
