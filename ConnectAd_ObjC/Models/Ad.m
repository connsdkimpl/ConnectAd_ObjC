//  Ad.m

#import "Ad.h"

@implementation Ad
@synthesize id,status,adOrder,adUnitIds,vastAdUnits;

- (instancetype)init
{
  self = [super init];
  if (self) {
  }
  return self;
}
- (instancetype)initWithJSONString:(NSDictionary *)JSONDictionary
{
  self = [super init];
  if (self) {
    NSError *error = nil;
    if (!error && JSONDictionary) {
      //Loop method
      for (NSString* key in JSONDictionary) {
        [self setValue:[JSONDictionary valueForKey:key] forKey:key];
      }
    }
  }
  return self;
}

@end
