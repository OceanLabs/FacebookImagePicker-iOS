# iOS Facebook Image Picker

A Facebook image picker providing a simple UI for a user to pick photos from a users Facebook account. It provides an image picker interface that matches the iOS SDK's UIImagePickerController. 

It takes care of all authentication with Facebook as and when necessary. It will automatically renew auth tokens or prompt the user to re-authorize the app if needed. 

## Requirements

* Xcode 6 and iOS SDK 7
* iOS 7.0+ target deployment

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

### Sample Apps
The project is bundled with a Sample App to highlight the libraries usage. Alternatively you can see the library in action in the following iOS apps:

* [HuggleUp](https://itunes.apple.com/gb/app/huggleup-photo-printing-personalised/id977579943?mt=8)
* Get in touch to list your app here

## License
This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
