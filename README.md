![Elegant Emoji Picker Swift UIKit](https://github.com/Finalet/Elegant-Emoji-Picker/blob/main/Documentation/Github%20Hero.png)

# Elegant Emoji Picker
![Elegant Emoji Picker Unicode version](https://img.shields.io/badge/Unicode-14.0-blue)
![Elegant Emoji Picker iOS version](https://img.shields.io/badge/iOS-13.0%2B-blue)
![Elegant Emoji Picker MacCatalyst version](https://img.shields.io/badge/MacCatalyst-13.0%2B-blue)
![Elegant Emoji Picker UIKit](https://img.shields.io/badge/Framework-UIKit-red)
![Elengat Emoji Picker Swift](https://img.shields.io/badge/Language-Swift-orange)
![Elegant Emoji Picker MIT License](https://img.shields.io/github/license/finalet/elegant-emoji-picker)
![Elengat Emoji Picker Contact](https://img.shields.io/badge/Contact-%40GrantOgany-darkgray?link=https://twitter.com/GrantOgany)

Why is there no built in emoji picker in UIKit? Same reason as why there is no calculator app in iPadOS? Perhaps. But should we just eat up Craig's laziness? Not this time.
Behold: ~~UIEmojiPicker~~ Elegant Emoji Picker.

<sub>P.S: Apple, you have my contacts, reach out.</sub>

## 🤔 About

Elegant Emoji Picker is a beautiful (subjectively) emoji picker for iOS, iPadOS, and MacCatalyst. 

#### Features
- Includes latest Unicode 14.0 emojis
- Emoji search
- Emoji long press preview
- Skin-tones support (one per emoji)
- Emoji categories toolbar 
- Customizable: change displayed sections, buttons, options, and more with `ElegantConfiguration` struct
- Localizable: provide strings for all on screen labels via the `ElegantLocalization` struct
- Blindingly beautiful

#### Limitations
- Does not support two skin tones per emoji. For example:
  - [x] Supported: 🤝🏻  🤝🏿 
  - [ ] Not supported: 🫱🏿‍🫲🏻   🫱🏼‍🫲🏿 

## 💻 Installation

Elegant Emoji Picker is available via the [Swift Package Manager](https://www.swift.org/package-manager/).

With your Xcode project open, go to File → Add Packages, enter the address below into the search field and click "Add Package".

```
https://github.com/Finalet/Elegant-Emoji-Picker
```

## 👀 Usage

### Offering emoji selection

The main view controller class is `ElegantPickerView`, which interacts with you through a delegate protocol `ElegantEmojiPickerDelegate`. Conform to the protocol and present `ElegantPickerView` when you want to offer emoji selection like so:

```swift
func PresentEmojiPicker () {
    let picker = ElegantEmojiPicker(delegate: self)
    self.present(picker, animated: true)
}
```

### Getting the selected emoji

Implement the required delegate method `emojiPicker (_: didSelectEmoji :)` to recieve user's selection. This function is called as soon as the user picks an emoji and passes an optinal `emoji: Emoji?` variable. `emoji` is nil when the users "resets" selection, meaning they used to have an emoji which they now want to remove. 

```swift
func emojiPicker(_ picker: ElegantEmojiPicker, didSelectEmoji emoji: Emoji?) {
    guard let emoji = emoji else { return }
    
    uiLabel.text = emoji.emoji
}
```

## 🎨 Configuration

### Showing / hiding features

Pass the `ElegantConfiguration` struct to the `ElegantEmojiPicker` initializer to specify what elements are shown, which features are available, and what categories of emojis to include.

### Offering a custom set of emojis

If you want to select which exactly emojis are offered to users, implement the `emojiPicker (_: loadEmojiSections :)` delegate method and return `[EmojiSection]` - an array of sections containing emojis.

```
func emojiPicker (_ picker: ElegantEmojiPicker, loadEmojiSections withConfiguration: ElegantConfiguration) -> [EmojiSection] {
    
}
```

### Localization 

You can provide texts for all on screen labels by passing the `ElegantLocalization` struct to the `ElegantEmojiPicker` initializer.

## 📱 Sample Project

Explore the [Demo project](https://github.com/Finalet/Elegant-Emoji-Picker/tree/main/Demo) for reference on what Elegant Emoji Picker is capable of or how to implement it. That said, the library is comically simple, so you should not have any trouble yourself. 

If you want to see the picker live on the App Store, check out [Finale To Do](https://apps.apple.com/app/apple-store/id1622931101).
