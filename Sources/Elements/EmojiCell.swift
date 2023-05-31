//
//  EmojiCell.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import Foundation
import UIKit

class EmojiCell: UICollectionViewCell {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    var emoji: Emoji!
    weak var emojiPicker: ElegantEmojiPicker?
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPress))
        longPress.minimumPressDuration = 0.3
        self.addGestureRecognizer(longPress)
        
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label, anchors: LayoutAnchor.fullFrame)
    }
    
    func Setup(emoji: Emoji, _ emojiPicker: ElegantEmojiPicker) {
        self.emoji = emoji
        self.emojiPicker = emojiPicker
        
        label.text = emoji.emoji
    }
    
    @objc func LongPress (_ sender: UILongPressGestureRecognizer) {
        guard let emojiPicker = emojiPicker else { return }

        if !emojiPicker.config.supportsSkinTones || !emoji.supportsSkinTones { return }
        
        if sender.state == .began {
            emojiPicker.ShowSkinToneSelector(self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.font = .systemFont(ofSize: self.frame.width*0.7)
    }
}
