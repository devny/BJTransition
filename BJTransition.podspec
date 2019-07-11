#
# Be sure to run `pod lib lint BJTransition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BJTransition'
  s.version          = '0.1.0'
  s.summary          = 'BJTranstion can use Pop Gesture Transition and Down Gesture Transition with only one navigation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'BJTranstion can use Pop Gesture Transition and Down Gesture Transition with only one navigation. You only need to use navigation as a BJTranstionController without any special setting. Very easy.'

  s.homepage         = 'https://github.com/devny/BJTransition'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'devny' => 'podo303@hanmail.net' }
  s.source           = { :git => 'https://github.com/devny/BJTransition.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '4.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'BJTransition/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BJTransition' => ['BJTransition/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
