//
//  ViewController.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import UIKit
import ElegantEmojiPicker

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
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emojiLabel)
        self.view.addSubview(emojiSelectionButton)
        
        let lg = UILayoutGuide()
        self.view.addLayoutGuide(lg)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            emojiSelectionButton.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 32),
            emojiSelectionButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            emojiSelectionButton.heightAnchor.constraint(equalToConstant: 40),
            
            lg.topAnchor.constraint(equalTo: emojiLabel.topAnchor),
            lg.bottomAnchor.constraint(equalTo: emojiSelectionButton.bottomAnchor),
            lg.leadingAnchor.constraint(equalTo: emojiSelectionButton.leadingAnchor),
            lg.trailingAnchor.constraint(equalTo: emojiSelectionButton.trailingAnchor),
            lg.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            lg.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func TappedEmojiSelection () {
        self.present(ElegantEmojiPicker(delegate: self, sourceView: emojiSelectionButton), animated: true)
    }
}

extension ViewController: ElegantEmojiPickerDelegate {
    func emojiPicker(_ picker: ElegantEmojiPicker, didSelectEmoji emoji: Emoji?) {
        emojiLabel.text = emoji?.emoji ?? " "

        emojiLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4) {
            self.emojiLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
