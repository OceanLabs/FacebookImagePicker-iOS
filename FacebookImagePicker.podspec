Pod::Spec.new do |s|
  s.name         = 'FacebookImagePicker'
  s.version      = '1.0.1'
  s.license      = 'MIT'
  s.summary      = 'Ocean Labs FacebookImagePicker'
  s.author       = { "Deon Botha" => "deon@oceanlabs.co" }
  s.social_media_url = 'https://twitter.com/dbotha'
  s.homepage     = 'https://github.com/OceanLabs/FacebookImagePicker-iOS'
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source = {
    :git => 'https://github.com/OceanLabs/FacebookImagePicker-iOS.git',
    :tag => '~> 1.0.1'
  }
  s.source_files = ['OL*.{h,m}', 'UIImageView+FacebookFadeIn.{h,m}']
  s.resources = ['FacebookImagePicker.xcassets', '*.xib']
  s.dependency 'Facebook-iOS-SDK', '~> 3.23.1'
  s.dependency 'SDWebImage', '~> 3.7.2'
end
