Pod::Spec.new do |s|
  s.name         = 'FacebookImagePicker'
  s.version      = '1.0.2'
  s.license      = 'MIT'
  s.summary      = 'An image/photo picker for Facebook albums & photos modelled after UIImagePickerController'
  s.author       = { "Deon Botha" => "deon@oceanlabs.co" }
  s.social_media_url = 'https://twitter.com/dbotha'
  s.homepage     = 'https://github.com/OceanLabs/FacebookImagePicker-iOS'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source = {
    :git => 'https://github.com/OceanLabs/FacebookImagePicker-iOS.git',
    :tag => s.version.to_s
  }
  s.source_files = ['FacebookImagePicker/OL*.{h,m}', 'FacebookImagePicker/UIImageView+FacebookFadeIn.{h,m}']
  s.resources = ['FacebookImagePicker/FacebookImagePicker.xcassets', 'FacebookImagePicker/*.xib']
  s.dependency 'Facebook-iOS-SDK', '~> 3.23.2'
  s.dependency 'SDWebImage', '~> 3.7.2'
end
