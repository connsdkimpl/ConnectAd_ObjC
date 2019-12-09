//  ConnectInterstitialView.m

#import "ConnectInterstitialView.h"

@interface ConnectInterstitialView ()

@end

@implementation ConnectInterstitialView
@synthesize html,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)loadView
{
    [super loadView];
    [self setupWeb];
}

-(void)setupWeb
{
    if(self.html != nil) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            // use weakSelf here
            WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
            WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) configuration:theConfiguration];
            webView.navigationDelegate = self;
            [webView loadHTMLString:self.html baseURL: NSBundle.mainBundle.bundleURL];
            [weakSelf.view addSubview:webView];
            [weakSelf setupSubViews];
        });
    }
}
-(void)setupSubViews
{
    CGFloat buttonSize = 40;
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - buttonSize - buttonSize/2, 20, buttonSize, buttonSize)];
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"ConnectAd_ObjC.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    UIImage *podImage = [UIImage imageNamed:@"exit" inBundle:resourceBundle compatibleWithTraitCollection:nil];
    [closeButton setImage:podImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    [self.view bringSubviewToFront:closeButton];
}
-(void)closePressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
+(UIViewController*)createInstance:(NSString*)html withDelegate: (id)delegate
{
    ConnectInterstitialView *vc = [[ConnectInterstitialView alloc]init];
    vc.html = html;
    vc.delegate = delegate;
    return vc;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.delegate onInterstitialDone: CONNECT];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"ConnectBannerView didFail");
    [self.delegate onInterstitialFailed: CONNECT withError:error];

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"ConnectBannerView didFailProvisionalNavigation");
    [self.delegate onInterstitialFailed: CONNECT withError:error];

}
- (void)webViewDidClose:(WKWebView *)webView{
    NSLog(@"ConnectBannerView didclose");
    [self.delegate onInterstitialClosed: CONNECT];
}

@end
