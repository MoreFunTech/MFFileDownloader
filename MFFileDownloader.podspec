#
# Be sure to run `pod lib lint MFFileDownloader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFFileDownloader'
  s.version          = '0.1.3'
  s.summary          = 'A File Downloader Manager'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A File Downloader To Manager Download Actions;
                       DESC

  s.homepage         = 'https://github.com/MoreFunTech/MFFileDownloader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NealWills' => 'NealWills93@gmail.com' }
  s.source           = { :git => 'https://github.com/MoreFunTech/MFFileDownloader.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MFFileDownloader/Classes/**/*'
  
#   s.resource_bundles = {
#     Media.xcassets
#     'MFFileDownloader' => ['MFFileDownloader/Assets/*.png']
#     'MFFileDownloader' => ['MFFileDownloader/Assets/*.xcassets']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
   s.dependency 'AFNetworking', '~> 4.0'
   s.dependency 'FMDB', '~> 2.7'
   
end
