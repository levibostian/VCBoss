#
# Be sure to run `pod lib lint VCBoss.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VCBoss'
  s.version          = '0.2.0'
  s.summary          = 'Present UIViewControllers modally in an easy and safe way.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Present UIViewControllers modally in an easy and safe way. No more `Fatal Exception: NSInvalidArgumentException Application tried to present modally an active controller ...` errors. Easily present, dismiss, replace, and swap UIViewControllers presented modally in a parent UIViewController.
                       DESC

  s.homepage         = 'https://github.com/levibostian/VCBoss'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Levi Bostian' => 'levi.bostian@gmail.com' }
  s.source           = { :git => 'https://github.com/levibostian/VCBoss.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/levibostian'

  s.ios.deployment_target = '8.0'

  s.source_files = 'VCBoss/Classes/**/*'

  # s.resource_bundles = {
  #   'VCBoss' => ['VCBoss/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
