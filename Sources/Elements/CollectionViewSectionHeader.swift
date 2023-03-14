//
//  CollectionViewSectionHeader.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import Foundation
import UIKit

class CollectionViewSectionHeader: UICollectionReusableView {
    let label = UILabel()
    
    let padding = 16.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.InitLabel()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.InitLabel()
    }

    func InitLabel() {
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        self.addSubview(label, anchors: [.leading(padding), .trailing(padding), .top(padding), .bottom(0)])
    }
}
