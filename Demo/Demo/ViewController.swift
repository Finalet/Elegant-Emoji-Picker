//
//  ViewController.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import UIKit

class ViewController: UIViewController {
     let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😀"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 50)
        return label
    }()
    
    let emojiSelectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select emoji", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        emojiSelectionButton.addTarget(self, action: #selector(TappedEmojiSelection), for: .touchUpInside)
        self.view.addSubview(emojiLabel, anchors: [.centerX(0)])
        self.view.addSubview(emojiSelectionButton, anchors: [.centerX(0), .height(40), .topToBottom(emojiLabel, 32)])
        
        let lg = self.view.setupLayoutGuide(top: emojiLabel.topAnchor, bottom: emojiSelectionButton.bottomAnchor, leading: emojiSelectionButton.leadingAnchor, trailing: emojiSelectionButton.trailingAnchor)
        lg.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        lg.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    @objc func TappedEmojiSelection () {
        self.present(ElegantEmojiPicker(delegate: self), animated: true)
    }
}

extension ViewController: ElegantEmojiPickerDelegate {
    func emojiPicker(_ picker: ElegantEmojiPicker, didSelectEmoji emoji: Emoji?) {
        emojiLabel.text = emoji?.emoji ?? ""
        
        emojiLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4) {
            self.emojiLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

