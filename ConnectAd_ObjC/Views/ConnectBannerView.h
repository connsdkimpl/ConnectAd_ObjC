//  ConnectBannerView.h

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ConnectAd.h"


NS_ASSUME_NONNULL_BEGIN

@interface ConnectBannerView: UIView<WKNavigationDelegate>

@property(strong, nonatomic)NSString * html;
@property (assign) id <ConnectAdBannerDelegate> delegate;
-(void)load:(NSString*)html;
@end

NS_ASSUME_NONNULL_END
