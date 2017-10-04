# Pinnable
___
### NSLayoutConstraints simplified

#### Quickly setup constraints with just a few lines of code

```swift
let subview = UIView()
view.addSubview(subview)

let topPin = subview.pin(edge: .top, toView: view)
let bottomPin = subview.pin(edge: .bottom, toView: view)
let leadingPin = subview.pin(edge: .leading, toView: view)
let trailingPin = subview.pin(edge: .trailing, toView: view)
```

#### Easily configure percentage based constraints to allow relative positioning of UIView's

```swift
let subview = UIView()
view.addSubview(subview)

// pin the subviews width to 50% of the parent view and add a constraint for the aspect ratio
let widthPin = subview.pin(dimension: .width, to: 0.5, relativeTo: view, aspectRatio: 16.0/9.0)
    
// pin the bottom edge of the subview to the bottom edge of the view. The margin will be 15% of the 
// height of the view
let bottomPin = subview.pin(edge: .bottom, toView: view, toAnchor: .bottom, margin: 0.15, relative:true)
    
// pin the subview to be centered on the x axis of the view
let axisPin = subview.pin(toAxis: .x, inView: view, offset:0)
```

#### Using the `Pin` object you can update the properties of the constraint at any time, i.e disable/enable, update the constant, or even the multiplier

```swift
bottomPin.isActive = false
```
OR
```swift
axisPin.set(value:100)
```
OR
```swift
bottomPin.set(value: 0.5)
```
#### Written in Swift, enjoy ;-)
