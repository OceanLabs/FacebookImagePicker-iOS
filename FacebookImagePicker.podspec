Pod::Spec.new do |s|
  s.name         = 'FacebookImagePicker'
  s.version      = '2.0.11'
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
  s.dependency 'FBSDKCoreKit'
  s.dependency 'FBSDKLoginKit'
end
