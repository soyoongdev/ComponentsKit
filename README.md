# ComponentsKit

## Installation

Add ComponentsKit to an Xcode project as a package dependency:

1. From the **File** menu, select **Add Package Dependencies...**.
2. Enter `https://github.com/componentskit/ComponentsKit` into the package repository URL text field.
3. Add **componentskit** to your application.

## Basic Usage

### Components

All components in the library have `view models` that should be used to configure their *appearance*. These models are shared between **SwiftUI** and **UIKit** components. For example, an input field can be configured as follows:

```swift
let inputFieldVM = InputFieldVM {
  $0.title = "Email"
  $0.placeholder = "Enter your email"
  $0.isRequired = true
}
```

> [!Note] 
> All `view models` in **ComponentsKit** do not have memberwise initializers. Instead, they conform to the `ComponentVM` protocol, which defines an initializer that modifies default values:
> ```swift
> /// Initializes a new instance by applying a transformation closure to the default values.
> ///
> /// - Parameter transform: A closure that defines the transformation.
> init(_ transform: (_ value: inout Self) -> Void)
> ```
> This approach has two main benefits:
> 1. It allows you to set parameters in any order, making the initializers easier to use.
> 2. Future changes can be made without breaking your code, as it simplifies deprecation.

To control the *behavior* in **SwiftUI**, you should use bindings:

```swift
@State var email: String
@FocusState var isEmailFieldFocused: Bool

SUInputField(
  text: $email,
  isFocused: $isEmailFieldFocused,
  model: inputFieldVM
)

// Track changes in the inputted text
.onChange(of: self.email) { oldValue, newValue in
  ...
}

// Control the focus (e.g., hide the keyboard)
isEmailFieldFocused = false
```

To control the behavior in **UIKit**, you should use the components' public variables:

```swift
let inputField = UKInputField(model: inputFieldVM)

// Access the text
var inputtedText = inputField.text

// Assign a new closure to handle text changes
inputField.onValueChange = { newText in
  inputtedText = newText
}

// Control the focus (e.g., hide the keyboard)
inputField.resignFirstResponder()
```

### Styling

**Config**

The library comes with predefined fonts, sizes and colors, but you can change these values to customize the appearance of your app. To do this, alter the config:

```swift
ComponentsKitConfig.shared.update {
  // Update colors
  $0.colors.primary = ...
  
  // Update layout
  $0.layout.componentRadius.medium = ...
}
```

> [!Note] 
> The best place to set up the initial config is in the `func application(_:, didFinishLaunchingWithOptions:) -> Bool` method in your `AppDelegate` or a similar method in `SceneDelegate`.

By altering the config, you can also create *custom themes* for your app. To do this, first create a new instance of a config:

```swift
let halloweenTheme = ComponentsKitConfig {
  $0.colors.background = .themed(
    light: .hex("#e38f36"),
    dark: .hex("#ba5421")
  )
  ...
}
```

When the user switches the theme, apply it by assigning it to the `shared` instance: 

```swift
ComponentsKitConfig.shared = halloweenTheme
```

**Extend Colors**

All colors from the config can be used within the app. For example:

```swift
// in UIKit
view.backgroundColor = UniversalColor.background.uiColor

// in SwiftUI
UniversalColor.background.color
```

If you want to use additional colors that are not included in the config, you can extend `UniversalColor`:

```swift
extension UniversalColor {
  static var special: UniversalColor {
    if selectedTheme == .halloween {
      return ...
    } else {
      return ...
    }
  }
}

// Then in your class
let view = UIView()
view.backgroundColor = UniversalColor.special.uiColor
```

**Extend Fonts**

If you want to use additional fonts that are not included in the config, you can extend `UniversalFont`:

```swift
extension UniversalFont {
  static let title: UniversalFont = .system(size: 16, weight: .regular)
}

// Then in your view
Text("Hello, World")
  .font(UniversalFont.title.font)
```

You can also extend `UniversalFont` for easier access to custom fonts:

```swift
extension UniversalFont {
  static func myFont(ofSize size: CGFloat, weight: Weight) -> UniversalFont {
    switch weight {
    case .regular:
      return ...
    }
  }
}

// Then in your view
Text("Hello, World")
  .font(UniversalFont.myFont(ofSize: 14, weight: .regular).font)
```
