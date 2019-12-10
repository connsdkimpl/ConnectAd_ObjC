Pod::Spec.new do |s|
 s.name             = 'ConnectAd_ObjC'
 s.version          = '1.0.1'
 s.summary          = 'ConnectAd_ObjC for iOS.'
 s.description      = 'This pod is used for integrating ConnectAd_ObjC in Objective-C iOS projects.'

 s.homepage         = 'https://github.com/connsdkimpl/ConnectAd_ObjC'
 s.license          = { :type => 'MIT', :file => 'LICENSE' }
 s.author           = { 'connsdkimpl' => 'sdkimpl@gmail.com' }
 s.source           = { :git => 'https://github.com/connsdkimpl/ConnectAd_ObjC.git', :tag => s.version.to_s }

 s.ios.deployment_target = '8.0'

 s.source_files = 'ConnectAd_ObjC/**/*.{h,m}'
 s.exclude_files = 'ConnectAd_ObjC/**/*.plist'
 s.resource_bundles = {
   'ConnectAd_ObjC' => ['ConnectAd_ObjC/Assets/*.png']
 }

 s.static_framework = true
 s.dependencies = { "mopub-ios-sdk/Core": ">= 5.3.0", "Google-Mobile-Ads-SDK": ">= 7.14.0" }
end