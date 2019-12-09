# ConnectAd SDK for iOS (Objective-C)

## Requirements

1. XCode 10 - (XCode 11 support is under development)

## Setup
### Setup with CocoaPods
[CocoaPods](https://cocoapods.org/) is a dependency manager for Swift and Objective-C Cocoa projects, which automates and simplifies the process of using 3rd-party libraries like the Connect AD SDK in your projects. You can install it with the following command:
```
$ sudo gem install cocoapods
```

To integrate ConnectSDK into your Xcode project using CocoaPods, specify it in your Podfile:
```
pod 'ConnectAd_ObjC', :git => 'https://github.com/connsdkimpl/ConnectAd_ObjC.git'
```

Then, run the following command:
```
$ pod install
```
**Note: Make sure *ConnectAd_ObjC* is public.**

## Initialize Connect AD SDK

In your app’s *AppDelegate.m* file, in *application didFinishLaunchingWithOptions:* method, use the following code:
```
[ConnectAd connectAdInit:@"YOUR_APP_ID" completion:^(NSMutableDictionary *response, NSError * _Nonnull error) {
   if (error != nil) {
     NSLog(@"%@", error.localizedDescription);
   } else {
     NSLog(@"response: %@", response);
   }
 }];
```
In *Info.plist* file, add the following key to include the *GADApplicationIdentifier* from AdMob:
```
<key>GADApplicationIdentifier</key><string>YOUR_GADAPPLICATIONIDENTIFIER</string>
```

### Banner Ads

You need to have <i>connect mediation banner ids</i> obtained from web UI  before proceeding; each connect mediation banner id corresponds to your AdMob and MoPub banner ad unit ids.

In your view controller’s header file, import the *ConnectAdBanner.h* header file and declare an *connectAdBanner* property:

```
// MyViewController.h

#import "ConnectAdBanner.h"

@interface MyViewController : UIViewController
{
  @property (nonatomic) ConnectAdBanner *connectAdBanner;
}

@end
```

Initialise the following properties to your *ConnectAdBanner*:

```
self.connectAdBanner = [[ConnectAdBanner alloc]initWithFrame:BANNER_FRAME];

self.connectAdBanner.adMobConnectIds = [[NSMutableArray alloc]initWithObjects:@"ADMOB_BANNER_CONNECT_ID_1",@"ADMOB_BANNER_CONNECT_ID_2", nil];
self.connectAdBanner.moPubConnectIds = [[NSMutableArray alloc]initWithObjects:@"MOPUB_BANNER_CONNECT_ID_1",@"MOPUB_BANNER_CONNECT_ID_2", nil];
self.connectAdBanner.rootViewController = self;
self.connectAdBanner.delegate = self;
[self.view addSubview:connectAdBanner];
```
Whenever you need to present your banner, call *loadAds* of your *ConnectAdBanner* to load and display the ad:
```
[self.connectAdBanner loadAds];
```
**Note: If you don't have any of the connect Ids, then there is no need to set values to corresponding properties.**

### Interstitial Ads

You need to have *connect mediation interstitial ids* obtained from web UI before proceeding, each connect mediation banner id corresponds to your AdMob and MoPub interstitial ad unit ids.

In your view controller’s header file, import the *ConnectAdInterstitial.h* header file and declare aa *connectAdInterstitial* property:

```
// MyViewController.h

#import "ConnectAdInterstitial.h"

@interface MyViewController : UIViewController
{
    @property (nonatomic) ConnectAdInterstitial *connectAdInterstitial;
}

@end
```

Initialise the *ConnectAdInterstitial* object created:
```

self.connectAdInterstitial = [[ConnectAdInterstitial alloc] init:[[NSMutableArray alloc]initWithObjects:@"ADMOB_INTERSTITIAL_CONNECT_ID_1",@"ADMOB_INTERSTITIAL_CONNECT_ID_2", nil] :[[NSMutableArray alloc]initWithObjects:@"MOPUB_INTERSTITIAL_CONNECT_ID_1",@"MOPUB_INTERSTITIAL_CONNECT_ID_2", nil]];
self.connectAdInterstitial.delegate = self;
```
Whenever you need to show your interstitial ad, call *loadFrom* of your *ConnectAdInterstitial* to load and display the same:
```
[self.connectInterstitial loadFrom:self];
```
**Note: If you don't have any of the ConnectIds, then please set an empty array for the corresponding item. For example, if your app does not have MoPub integrated, then create a *ConnectAdInterstitial* instance like this:**

```
self.connectAdInterstitial = [[ConnectAdInterstitial alloc] init:[[NSMutableArray alloc]initWithObjects:@"ADMOB_INTERSTITIAL_CONNECT_ID_1",@"ADMOB_INTERSTITIAL_CONNECT_ID_2", nil] :[[NSMutableArray alloc]init]];

```

### Rewarded Video Ads

You need to have *connect mediation rewarded video ad ids* obtained from web UI before proceeding, each connect mediation banner id corresponds to your AdMob and MoPub reward video ad unit ids.

In your view controller’s header file, import the *ConnectAdRewarded.h* header file and declare an *connectAdRewarded* property:

```
// MyViewController.h

#import "ConnectAdRewarded.h"

@interface MyViewController : UIViewController
{
    @property (nonatomic) ConnectAdRewarded *connectAdRewarded;
}

@end
```

Initialise the *ConnectAdRewarded* object created:
```
self.connectAdRewarded = [[ConnectAdRewarded alloc] init:[[NSMutableArray alloc]initWithObjects:@"ADMOB_REWARDED_CONNECT_ID_1", @"ADMOB_REWARDED_CONNECT_ID_2", nil] :[[NSMutableArray alloc]initWithObjects:@"MOPUB_REWARDED_CONNECT_ID_1", @"MOPUB_REWARDED_CONNECT_ID_2", nil ]];
self.connectAdRewarded.delegate = self;
```
Whenever you need to show your interstitial ad, call *loadFrom* of your *ConnectAdRewarded* to load and display the same:
```
[self.connectAdRewarded loadFrom:self];
```
**Note: If you don't have any of the ConnectIds, then please set an empty array for the corresponding item. For example, if your app does not have MoPub integrated, then create a *ConnectAdRewarded* instance like this:**

```
self.connectAdRewarded = [[ConnectAdRewarded alloc] init:[[NSMutableArray alloc]initWithObjects:@"ADMOB_REWARDED_CONNECT_ID_1",@"ADMOB_REWARDED_CONNECT_ID_2", nil] :[[NSMutableArray alloc]init]];
```
### Implementing Delegates
Conform your ViewController to *ConnectAdBannerDelegate* protocol:
```
// MyViewController.h
@interface MyViewController : UIViewController <ConnectAdBannerDelegate>

@end
```

Implement all the methods:
```
- (void)onBannerFailed:(AdType)adType withError:(NSError * _Nullable)error {
    NSLog(@"Banner failed to retrieve ad: %ld, error: %@", (long)adType, error.localizedDescription);
}

- (void)onBannerDone:(AdType)adType {
    NSLog(@"Banner successfully retrieved ad: %ld", (long)adType);
}
-(void)onBannerExpanded:(AdType)adType{
    NSLog(@"Banner presented: %ld", (long)adType);
}

-(void)onBannerCollapsed:(AdType)adType{
    NSLog(@"Banner dismissed: %ld", (long)adType);
}

-(void)onBannerClicked:(AdType)adType{
    NSLog(@"Banner clicked: %ld", (long)adType);
}
```
Conform your ViewController to *ConnectAdRewardedDelegate* protocol:
```
// MyViewController.h
@interface MyViewController : UIViewController <ConnectAdRewardedDelegate>

@end
```

Implement all the methods:
```
-(void)onRewardVideoClosed:(AdType)adType{
    NSLog(@"RewardedAd closed: %ld", (long)adType);
}

-(void)onRewardFail:(AdType)adType withError:(NSError*_Nullable)error{
    NSLog(@"RewardedAd failed to load: %ld, error: %@", (long)adType, error.localizedDescription);

}
-(void)onRewardVideoStarted:(AdType)adType{
    NSLog(@"RewardedAd started playing: %ld", (long)adType);

}

- (void)onRewardedVideoCompleted:(AdType)adType {
  NSLog(@"RewardedAd completed playing: %ld", (long)adType);

}
-(void)onRewarded:(AdType)adType withReward:(AdReward*_Nullable) rewardItem{
    NSLog(@"Rewarded ad retrieved: %ld, %@, %ld", (long)adType, rewardItem.currencyType,(long)rewardItem.rewardAmount);
}

-(void)onRewardVideoClicked:(AdType)adType{
    NSLog(@"RewardedAd clicked: %ld", (long)adType);

}
```

Conform your ViewController to *ConnectAdInterstitialDelegate* protocol:
```
// MyViewController.h
@interface MyViewController : UIViewController <ConnectAdInterstitialDelegate>

@end
```

Implement all the methods:
```
-(void)onInterstitialClicked:(AdType)adType{
  NSLog(@"Interstitial ad clicked: %ld", (long)adType);
}

-(void)onInterstitialClosed:(AdType)adType{
  NSLog(@"Interstitial ad closed: %ld", (long)adType);

}
-(void)onInterstitialDone:(AdType)adType{
  NSLog(@"Interstitial ad presented: %ld", (long)adType);

}
-(void)onInterstitialFailed:(AdType)adType withError:(NSError*_Nullable)error{
  NSLog(@"Interstitial ad failed: %ld, error: %@", (long)adType, error.localizedDescription);
}

```
## License
MIT License

Copyright (c) 2019 connsdkimpl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
