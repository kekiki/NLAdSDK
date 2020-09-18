#
# Be sure to run `pod lib lint NLAdSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NLAdSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NLAdSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.static_framework = true
  s.homepage         = 'https://github.com/Ke Jie/NLAdSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ke Jie' => 'kekiki@126.com' }
  s.source           = { :git => 'https://github.com/Ke Jie/NLAdSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NLAdSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NLAdSDK' => ['NLAdSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'YYCategories'
  s.dependency 'Google-Mobile-Ads-SDK', '7.62.0'
  s.dependency 'GoogleMobileAdsMediationFacebook', '~> 5.10'
#  s.dependency 'FBSDKCoreKit', '~> 7.0.1'
end
