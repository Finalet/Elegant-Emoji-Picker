//
//  ElegantEmojiPickerDelegate.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import Foundation
import UIKit

/// Methods for interacting with and configuring ElegantEmojiPicker.
///
/// Use methods of this protocol to:
/// * Respond to emoji selection
/// * Receive callbacks when the emoji picker was loaded
/// * Configure the emoji picker dismiss behavior
public protocol ElegantEmojiPickerDelegate {
    
    /// Tells the delegate that an emoji was selected, or that the user reset their selection.
    /// - Parameters:
    ///   - picker: The emoji picker view informing the delegate.
    ///   - emoji: The selected emoji. Returns nil if user resets emoji.
    func emojiPicker (_ picker: ElegantEmojiPicker, didSelectEmoji emoji: Emoji?)
    
    /// Tells the delegate that the focused emoji category was changed, which happens when the user scrolls through emojis.
    ///
    /// You can use this method to update the UI of your custom toolbar.
    /// - Parameters:
    ///   - picker: The emoji picker view informing the delegate.
    ///   - to: New focused category.  
    ///   - from: Previously focused category.
    func emojiPicker (_ picker: ElegantEmojiPicker, focusedCategoryChanged to: EmojiCategory, from: EmojiCategory)
    
    /// Asks the delegate to provide search results for a specific prompt.
    ///
    /// You can use this method to override the default search algorithm. This search happens on the background thread.
    /// - Parameters:
    ///   - picker: The emoji picker view informing the delegate.
    ///   - prompt: The prompt that was used for search.
    ///   - fromAvailable: All available emoji, arranged by sections, taking into account the the emoji picker view configuration.
    /// - Returns: Return an array of emojis that the user should see from the current prompt.
    func emojiPicker (_ picker: ElegantEmojiPicker, searchResultFor prompt: String, fromAvailable: [EmojiSection]) -> [Emoji]
    
    /// Tells the delegate that user just started typing in the search bar.
    ///
    /// You can use this method to hide your custom toolbar, adjust your UI, or whatever else you want. I can't stop you.
    /// - Parameter picker: The emoji picker view informing the delegate.
    func emojiPickerDidStartSearching (_ picker: ElegantEmojiPicker)
    
    /// Tells the delegate that user just ended and exited search.
    ///
    /// You can use this method to show your custom toolbar, adjust your UI, or whatever else your want. Even here, I cannot stop you.
    /// - Parameter picker: The emoji picker view informing the delegate.
    func emojiPickerDidEndSearching (_ picker: ElegantEmojiPicker)
    
    /// Asks the delegate, if the picker view should be dismissed as soon as selection was made.
    /// - Parameter picker: The emoji picker view informing the delegate.
    /// - Returns: true (default) to allow the emoji picker view to automatically dismiss after the user makes a selection, or false to prevent the view from dismissing after user makes a selection.
    func emojiPickerShouldDismissAfterSelection (_ picker: ElegantEmojiPicker) -> Bool
    
    /// Asks the delegate for an array of emojis to offer users, organized by sections.
    ///
    /// Use this method if you are unsatisfied with the provided emojis and want to supply your own. You are welcome, but, also, fuck you.
    /// - Parameters:
    ///   - picker: The emoji picker view informing the delegate.
    ///   - withConfiguration: The emoji picker configuration used to setup this emoji picker.
    /// - Returns: Return an array of Emoji Sections that you would like the emoji picker to offer users.
    func emojiPicker (_ picker: ElegantEmojiPicker, loadEmojiSections withConfiguration: ElegantConfiguration) -> [EmojiSection]
}

extension ElegantEmojiPickerDelegate {
    
    public func emojiPicker (_ picker: ElegantEmojiPicker, focusedCategoryChanged to: EmojiCategory, from: EmojiCategory) {}
    
    public  func emojiPicker (_ picker: ElegantEmojiPicker, searchResultFor prompt: String, fromAvailable: [EmojiSection]) -> [Emoji] {
        return ElegantEmojiPicker.getSearchResults(prompt, fromAvailable: fromAvailable)
    }
    
    public func emojiPickerDidStartSearching (_ picker: ElegantEmojiPicker) {}
    
    public func emojiPickerDidEndSearching (_ picker: ElegantEmojiPicker) {}
    
    public func emojiPickerDidLoad (_ picker: ElegantEmojiPicker) {}
    
    public func emojiPickerShouldDismissAfterSelection (_ picker: ElegantEmojiPicker) -> Bool { return true }
    
    public func emojiPicker (_ picker: ElegantEmojiPicker, loadEmojiSections withConfiguration: ElegantConfiguration) -> [EmojiSection] {
        return ElegantEmojiPicker.setupEmojiSections(config: withConfiguration)
    }
    
}

