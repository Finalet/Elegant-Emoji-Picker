![Elegant Emoji Picker Swift UIKit](https://raw.githubusercontent.com/Finalet/Elegant-Emoji-Picker/main/Documentation/Github%20Hero.png)

# Elegant Emoji Picker
![Elegant Emoji Picker Unicode version](https://img.shields.io/badge/Unicode-16.0-blue)
![Elegant Emoji Picker iOS version](https://img.shields.io/badge/iOS-13.0%2B-blue)
![Elegant Emoji Picker MacCatalyst version](https://img.shields.io/badge/MacCatalyst-13.0%2B-blue)
![Elegant Emoji Picker UIKit](https://img.shields.io/badge/Framework-UIKit-red)
![Elengat Emoji Picker Swift](https://img.shields.io/badge/Language-Swift-orange)
![Elegant Emoji Picker MIT License](https://img.shields.io/github/license/finalet/elegant-emoji-picker)
![Elengat Emoji Picker Contact](https://img.shields.io/badge/Contact-%40GrantOgany-darkgray?link=https://twitter.com/GrantOgany)

Why is there no built in emoji picker in UIKit? Same reason as why there is no calculator app in iPadOS? Perhaps. But should we just eat up Craig's laziness? Not this time.
Behold: ~~UIEmojiPicker~~ Elegant Emoji Picker.

<sub>P.S: Apple, you have my contacts, reach out.</sub>

https://user-images.githubusercontent.com/10033440/226136503-79eb27fb-1254-45da-a7c1-5528c1ec160e.MP4

## 🤔 About

Elegant Emoji Picker is a configurable, simple to use, even more simple to impement, and beautiful (subjectively) emoji picker for iOS, iPadOS, and MacCatalyst ([iOS preview](https://github.com/Finalet/Elegant-Emoji-Picker/blob/dev/Documentation/iOS%20preview.MP4), [MacCatalyst preview](https://github.com/Finalet/Elegant-Emoji-Picker/blob/dev/Documentation/MacCatalyst%20preview.mov)).

#### Features
- Search
- Long press preview
- Skin tones support (one per emoji)
- Categories toolbar 
- Configurable: change displayed sections, buttons, options, and more
- Localizable: provide text for all on screen labels
- Latest Unicode 14.0 emojis
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

Afterwards, import `ElegantEmojiPicker` module where you want to use it.

```swift
import ElegantEmojiPicker
```

## 👀 Usage

### Offering emoji selection

`ElegantPickerView` is the main view controller, which interacts with you through a delegate protocol `ElegantEmojiPickerDelegate`. Conform to the protocol and present `ElegantPickerView` when you want to offer emoji selection like so:

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

It is that easy. If simply offering emojis is all your soul desires, we are done. But if you are a more intricate type of coder and want more control, keep on readin'.

## 🎨 Configuration

### Showing or hiding features

Pass the `ElegantConfiguration` struct to the `ElegantEmojiPicker` initializer to configure the UI and behaviour of the emoji picker.

```swift
let config = ElegantConfiguration(showRandom: false, showReset: false, defaultSkinTone: .Light)
let picker = ElegantEmojiPicker(delegate: self, configuration: config)
viewController.present(picker, animated: true)
```

- `showSearch` Show or hide search bar
- `showRandom` Show or hide "Random" button
- `showReset` Show or hide "Reset" button
- `showClose` Show or hide "Close" button
- `showToolbar` Show or hide built-in categories toolbar
- `supportsPreview` Allow or disallow previewing emojis with long-press
- `categories` Which default emoji categories to offer users
- `supportsSkinTones` Allow or disallow selecting emojis skin tone with long-press
- `persistSkinTones` Save or forget user's skin tone selection for each emoji between sessions.
- `defaultSkinTone` Optional skin tone to use as default. Default value is `nil`, meaning standard yellow emojis will be used.

### Offering a custom set of emojis

If you want to provide your own list of emojis to users, implement the `emojiPicker(_: loadEmojiSections : withConfiguration : withLocalization)` delegate method and return an array of sections containing emojis `[EmojiSection]`. You can use a static method `ElegantEmojiPicker.getAllEmoji()` to retrieve all existing emojis or `ElegantEmojiPicker.getDefaultEmojiSections()` to get all emojis categorized by default sections.

`EmojiSection` one section containing emojis, like "Smileys & Emotion" or "People & Body".
- `title` Displayed section title
- `icon` Displayed section icon (used in the built-in toolbar). Optional.
- `emojis` Emojis contained in this section

```swift
func emojiPicker(_ picker: ElegantEmojiPicker, loadEmojiSections withConfiguration: ElegantConfiguration, _ withLocalization: ElegantLocalization) -> [EmojiSection] {
    let allEmojis = ElegantEmojiPicker.getAllEmoji()
    
    let politeEmojis = allEmojis.filter({
        $0.emoji == "🖕" ||
        $0.emoji == "👊" ||
        $0.emoji == "🤬"
    })
    
    return [EmojiSection(title: "Politeness", icon: UIImage(systemName: "heart"), emojis: politeEmojis)]
}
```

- `picker` Picker view that is asking the delegate for emojis.
- `withConfiguration` Configuration used to for this emoji picker. Default method uses it to process skin tones, sections, and more.
- `withLocalization` The localization used for this emoji picker. Default method uses it to provide localized section titles.

### Localization 

You can provide texts for all on screen labels by passing the `ElegantLocalization` struct to the `ElegantEmojiPicker` initializer.

```swift
let localization = ElegantLocalization(searchFieldPlaceholder: "Че надо", randomButtonTitle: "Хз го рандом")
let picker = ElegantEmojiPicker(delegate: self, localization: localization)
viewController.present(picker, animated: true)
```

- `searchFieldPlaceholder` Placeholder text for the search bar
- `searchResultsTitle` Title text shown when presenting users with emoji search results
- `searchResultsEmptyTitle` Title text shown when search results are empty
- `randomButtonTitle` Title for the button that selects a random emoji
- `emojiCategoryTitles` Dictionary of titles for default emoji categories, like "Smileys & Emotion", "People & Body", and so on.

## 📱 Sample Project

Explore the [Demo project](https://github.com/Finalet/Elegant-Emoji-Picker/tree/main/Demo) for reference on what Elegant Emoji Picker is capable of or how to implement it. That said, the library is comically simple, so you should not have any trouble yourself. 

If you want to see the picker live on the App Store, check out [Finale To Do](https://apps.apple.com/app/apple-store/id1622931101). This sentence was sponsored by #shamelessplug.

## 🤷🏻‍♂️ Contribution guide

I have no idea what I am doing. Send help. How do git contributions work? The fuck if I know. Just don't do anything stupid and we will figure this out.
