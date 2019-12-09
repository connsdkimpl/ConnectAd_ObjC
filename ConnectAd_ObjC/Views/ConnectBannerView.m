//  ConnectBannerView.m

#import "ConnectBannerView.h"
#import <WebKit/WebKit.h>

@implementation ConnectBannerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)theFrame {
    self = [super initWithFrame:theFrame];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.alpha = 0;
}
- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]) {
    }
    return self;
}
-(void)load:(NSString*)html{
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.frame configuration:theConfiguration];
    webView.opaque = NO;
    webView.navigationDelegate = self;
    [webView loadHTMLString:html baseURL: NSBundle.mainBundle.bundleURL];
    [self addSubview:webView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        //code with animation
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self.delegate onBannerDone: CONNECT];
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Connect BannerView didFail");
    [self.delegate onBannerFailed:CONNECT withError:error];

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"ConnectBannerView didFailProvisionalNavigation");
    [self.delegate onBannerFailed:CONNECT withError:error];

}

@end
