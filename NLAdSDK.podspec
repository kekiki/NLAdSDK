#
# Be sure to run `pod lib lint NLAdSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NLAdSDK'
  s.version          = '0.1.5'
  s.summary          = '聚合广告SDK'

  s.description      = <<-DESC
                         NLAdSDK 是一个聚合广告SDK
                         * 支持Google原生和激励广告
                         * 支持Facebook原生和激励广告
                         DESC

  s.static_framework = true
  s.homepage         = 'https://github.com/kekiki/NLAdSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author           = { 'kekiki' => 'kekiki@126.com' }
  s.source           = { :git => 'https://github.com/kekiki/NLAdSDK.git', :tag => s.version }

  s.ios.deployment_target = '10.0'

  s.source_files = 'NLAdSDK/Classes/**/*'
  
  #s.resource_bundles = {
  #  'NLAdSDK' => ['NLAdSDK/Assets/*.png']
  #}

  s.public_header_files = 'NLAdSDK/Classes/AdManager/*.h'
  s.private_header_files = 'NLAdSDK/Classes/AdPlatform/*.h', 'NLAdSDK/Classes/Vender/*.h'
  
  s.requires_arc        = true
  s.frameworks          = 'UIKit', 'Foundation', 'CoreGraphics'
  
  s.dependency 'SDWebImage'
  s.dependency 'YYCategories'
  s.dependency 'Google-Mobile-Ads-SDK', '7.62.0'
  s.dependency 'GoogleMobileAdsMediationFacebook', '~> 5.10'
  s.dependency "VungleSDK-iOS", "6.8.0"
  s.dependency 'AppLovinSDK', "6.14.3"
  s.dependency 'ChartboostSDK', '8.3.1'
  s.dependency 'Bytedance-UnionAD', '~> 3.2.6.2'
  
end
