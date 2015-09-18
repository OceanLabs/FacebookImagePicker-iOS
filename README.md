# iOS Facebook Image Picker

A Facebook image picker providing a simple UI for a user to pick photos from a users Facebook account. It provides an image picker interface that matches the iOS SDK's UIImagePickerController.

It takes care of all authentication with Facebook as and when necessary. It will automatically renew auth tokens or prompt the user to re-authorize the app if needed.

## Video Preview

[![Preview](https://github.com/OceanLabs/FacebookImagePicker-iOS/raw/master/preview.png)](https://vimeo.com/135687088)

## Requirements

* Xcode 6 and iOS SDK 7
* iOS 7.0+ target deployment
* FBSDKCoreKit, FBSDKLoginKit (>= 4.0)

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like the Kite Print SDK in your projects. If you're using it just add the following to your Podfile:

```ruby
pod "FacebookImagePicker"
```

## Usage

You need to have set up your application correctly to work with Facebook as per https://developers.facebook.com/docs/ios/getting-started

To launch the Facebook Image Picker:

```objective-c
#import <OLFacebookImagePickerController.h>

OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
picker.delegate = self;
[self presentViewController:picker animated:YES completion:nil];
```

Implement the `OLFacebookImagePickerControllerDelegate` protocol:

```objective-c
- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray/*<OLFacebookImage>*/ *)images {
    [self dismissViewControllerAnimated:YES completion:nil];
    // do something with the OLFacebookImage image objects
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    // do something with the error such as display an alert to the user
}

```

## App Transport Security
Xcode 7 and iOS 9 includes some new security features. In order to connect to Facebook you will need to add some more exceptions to your project's info plist file (in addition to the ones that your project might require).
We need to add forward secrecy exceptions for Facebooks's CDNs. The following is what you need to copy your app's info plist, which includes anything that is needed by Kite as well:
```
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>akamaihd.net</key>
			<dict>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>facebook.com</key>
			<dict>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>fbcdn.net</key>
			<dict>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
		</dict>
	</dict>
```

**Set maximum number of selections**

Limit the number of assets to be picked.
```` objective-c
- (BOOL)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker shouldSelectImage:(OLFacebookImage *)image
{
    // Allow 10 assets to be picked
    return (imagePicker.selected.count < 10);
}
````


### Sample Apps
The project is bundled with a Sample App to highlight the libraries usage. Alternatively you can see the library in action in the following iOS apps:

* [HuggleUp](https://itunes.apple.com/gb/app/huggleup-photo-printing-personalised/id977579943?mt=8)
* Get in touch to list your app here

## License
This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
