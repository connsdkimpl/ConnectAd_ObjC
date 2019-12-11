//  ConnectInterstitialView.h

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ConnectAd.h"


NS_ASSUME_NONNULL_BEGIN

@interface ConnectInterstitialView: UIViewController<WKNavigationDelegate>

@property(strong, nonatomic)NSString *html;
@property (assign) id <ConnectAdInterstitialDelegate> delegate;
@property(nonatomic, assign)AdType adType;
+(UIViewController*)createInstance:(NSString*)html withDelegate: (id)delegate;

@end

NS_ASSUME_NONNULL_END
