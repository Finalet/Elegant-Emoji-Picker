# Elegant Emoji Picker

Why is there no built in emoji picker in UIKit? Same reason as why there is no calculator app in iPadOS? Perhaps. But should we just eat up Craig's laziness? Not this time.
Behold: ~~UIEmojiPicker~~ Elegant Emoji Picker.

<sub>P.S: Apple, you have my contacts, reach out.</sub>

# About

Elegant Emoji Picker is a beautiful (subjectively) emoji picker for iOS, iPadOS, and MacCatalyst. 

### Features
- Includes latest Unicode 14.0 emojis
- Emoji search
- Supports skin-tones (one per emoji)
- Customizable: change displayed sections, buttons, options, and more with `ElegantConfiguration` struct
- Localizable: provide strings for all on screen labels via the `ElegantLocalization` struct

### Limitations
- Does not support two skin tones per emoji. For example:
  - [x] Supported: 🤝🏻  🤝🏿 
  - [ ] Not supported: 🫱🏿‍🫲🏻   🫱🏼‍🫲🏿 

# Installation

Elegant Emoji Picker is available via the [Swift Package Manager](https://www.swift.org/package-manager/).

With your Xcode project open, go to File → Add Packages, enter the address below into the search field and click "Add Package".
```
https://github.com/Finalet/Elegant-Emoji-Picker
```
