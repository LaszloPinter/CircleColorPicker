# Circle Color Picker

![Version](https://img.shields.io/cocoapods/v/CircleColorPicker.svg?style=flat)
![License](https://img.shields.io/cocoapods/l/CircleColorPicker.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/CircleColorPicker.svg?style=flat)


This is a highly customizable color picker view written in Swift. 

This is a working product but still an ongoing project with enhancement and refactor ideas. You can find a list at the bottom of this page. Please feel free to contribute or star the project if you like it. 

## Screenshots

<img src="https://raw.githubusercontent.com/LaszloPinter/CircleColorPicker/master/screenshots/screenshot1.png" alt="" width="256" />

<img src="https://raw.githubusercontent.com/LaszloPinter/CircleColorPicker/master/screenshots/screenshot2.png" alt="" width="256" />

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```


To integrate CircleColorPicker into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '11.0'

use_frameworks!

target 'WiledMoods' do
    pod 'CircleColorPicker', '~> 1.0.0'

end
```

Then, run the following command:

```bash
$ pod install
```

## How to use

Add a UIView to one of your ViewControllers on interface builder and set it's class to *CircleColorPickerView*. Alternatively you can instantiate and add it programmatically.

### IBDesignable properties


- *Rainbow Width* is the width of the color ring. Default value is 8.0.
- *Bubble Radius* is the radius of the color bubble on the ring. (18 by default)
- *Center Diameter* is the diameter of the color sample at the center of the picker. (80 by default)
- *Center Ring Width* is the width translucent edge of the color sample view. (8 by default)

### Public properties

These values have both getters and setters:

- color: *(CGColor)* is the current color of the picker
- hue: *(CGFloat)* is the current hue value of the selected color
- animation time: *(Double)* is the duration of the animation when user selects a new color.
- delegate : *(weak CircleColorPickerViewDelegate?)* is the delegate of your picker.
- saturationPickerView: *(weak SaturationPickerView?)* is an optional saturation picker that works with the
color circle. Enables saturation selection.
- saturation: *(CGFloat)* is the current saturation value of the selected color. (Only works if saturationPickerView is assigned otherwise always returns 1.)

This means that you can make animations faster or slower as you prefer.

You can also change the images of the bubbles using:
 
 ```swift
colorPickerView.setupMaskImages(image: bubbleImage)
 ```
 
 where bubbleImage should be the UIImage of your choice.
 
 
 
 
### Delegation of color change


To get notified when the user selects a new color on the picker implement the:

 ```swift
func onColorChanged(newColor: CGColor)
 ```
function of the `CircleColorPickerViewDelegate` interface and set the delegate of your CircleColorPickerView.


## Whats next?


### TODOs
- Carthage support
- Swift package manager support
- More detailed description
- Tests

### Ideas
- Should be a function the set the color of the picker with animation (just as when user picks a color)

## Apps using this library
Thanks for using **CircleColorPicker**. If you have an app that is using this library and want it listed here just drop a message. 
