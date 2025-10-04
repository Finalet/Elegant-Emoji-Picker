//
//  ViewController.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import UIKit
import ElegantEmojiPicker
import SwiftUI

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
    
    let swiftuiDemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show SwiftUI Demo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGreen
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        emojiSelectionButton.addTarget(self, action: #selector(TappedEmojiSelection), for: .touchUpInside)
        swiftuiDemoButton.addTarget(self, action: #selector(TappedSwiftUIDemo), for: .touchUpInside)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        swiftuiDemoButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emojiLabel)
        self.view.addSubview(emojiSelectionButton)
        self.view.addSubview(swiftuiDemoButton)
        
        let lg = UILayoutGuide()
        self.view.addLayoutGuide(lg)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            emojiSelectionButton.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 32),
            emojiSelectionButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            emojiSelectionButton.heightAnchor.constraint(equalToConstant: 40),
            emojiSelectionButton.widthAnchor.constraint(equalToConstant: 200),
            
            swiftuiDemoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            swiftuiDemoButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            swiftuiDemoButton.heightAnchor.constraint(equalToConstant: 40),
            swiftuiDemoButton.widthAnchor.constraint(equalToConstant: 200),
            
            lg.topAnchor.constraint(equalTo: emojiLabel.topAnchor),
            lg.bottomAnchor.constraint(equalTo: emojiSelectionButton.bottomAnchor),
            lg.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            lg.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lg.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    @objc func TappedEmojiSelection () {
        self.present(ElegantEmojiPicker(delegate: self, sourceView: emojiSelectionButton), animated: true)
    }
    
    @objc func TappedSwiftUIDemo () {
        if #available(iOS 14.0, *) {
            let hostingController = UIHostingController(rootView: SwiftUIDemoView())
            self.present(hostingController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "SwiftUI Not Available", message: "SwiftUI features require iOS 14 or later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
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
