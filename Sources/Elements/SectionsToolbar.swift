//
//  CategoriesToolbar.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import Foundation
import UIKit

class SectionsToolbar: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    weak var emojiPicker: ElegantEmojiPicker?
    let padding = 8.0
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    let selectionBlur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    var selectionConstraint: NSLayoutConstraint?
    
    var categoryButtons = [SectionButton]()
    
    init (sections: [EmojiSection], emojiPicker: ElegantEmojiPicker) {
        self.emojiPicker = emojiPicker
        super.init(frame: .zero)
        
        self.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        
        self.PopupShadow()
        
        blur.clipsToBounds = true
        self.addSubview(blur, anchors: LayoutAnchor.fullFrame)
        
        selectionBlur.clipsToBounds = true
        selectionBlur.backgroundColor = .label.withAlphaComponent(0.3)
        self.addSubview(selectionBlur, anchors: [.centerY(0)])
        
        selectionConstraint = selectionBlur.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        selectionConstraint?.isActive = true
        
        for i in 0..<sections.count {
            let button = SectionButton(i, icon: sections[i].icon, emojiPicker: emojiPicker)
            
            let prevButton: UIView? = categoryButtons.last
            
            self.addSubview(button, anchors: [.top(padding), .bottom(padding)])
            categoryButtons.append(button)

            button.leadingAnchor.constraint(equalTo: prevButton?.trailingAnchor ?? self.leadingAnchor, constant: prevButton != nil ? 0 : padding).isActive = true
            if let prevButton = prevButton { button.widthAnchor.constraint(equalTo: prevButton.widthAnchor).isActive = true }
        }
        
        if let lastButton = self.subviews.last {
            lastButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
            
            selectionBlur.widthAnchor.constraint(equalTo: lastButton.widthAnchor).isActive = true
            selectionBlur.heightAnchor.constraint(equalTo: lastButton.heightAnchor).isActive = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.layer.cornerRadius = blur.frame.height*0.5
        selectionBlur.layer.cornerRadius = selectionBlur.frame.height*0.5
        
        UpdateCorrectSelection(animated: false)
    }
    
    func UpdateCorrectSelection (animated: Bool = true) {
        guard let emojiPicker = emojiPicker else { return }

        if !emojiPicker.isSearching { self.alpha = emojiPicker.config.categories.count <= 1 ? 0 : 1 }
        
        let posX: CGFloat? = categoryButtons.indices.contains(emojiPicker.focusedSection) ? categoryButtons[emojiPicker.focusedSection].frame.origin.x : nil
        let safePos: CGFloat = posX ?? padding
        
        if animated {
            selectionConstraint?.constant = safePos
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
            return
        }
        
        selectionConstraint?.constant = safePos
    }
    
    class SectionButton: UIView {
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        let imageView = UIImageView()
        
        let section: Int
        weak var emojiPicker: ElegantEmojiPicker?
        
        init (_ section: Int, icon: UIImage?, emojiPicker: ElegantEmojiPicker) {
            self.section = section
            self.emojiPicker = emojiPicker
            super.init(frame: .zero)
            
            self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            
            imageView.image = icon
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemGray
            self.addSubview(imageView, anchors: LayoutAnchor.fullFrame(8))
            
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Tap)))
        }
        
        @objc func Tap () {
            guard let emojiPicker = emojiPicker else { return }
            emojiPicker.didSelectSection(section)
        }
    }
}
