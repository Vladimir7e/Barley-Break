//
//  StartCollectionViewCell.swift
//  Barley-Break
//
//  Created by Developer on 18.08.2022.
//

import UIKit

private extension CGFloat {
    static let inset: CGFloat = 20
    static let interItemSpacing: CGFloat = 20
}

class StartCollectionViewCell: UICollectionViewCell {
    
    var numberLabel:  UILabel = UILabel(frame: CGRect.zero)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        numberLabel.text = ""
    }

    override init(frame : CGRect) {
        super.init(frame : frame)
        numberLabel.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        numberLabel.textColor = .black
        contentView.addSubview(numberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func size(for size: CGSize, itemsPerRow: CGFloat) -> CGSize {
        let paddinWidth: CGFloat = (CGFloat.inset * 2) + CGFloat.interItemSpacing
        let availableWidht: CGFloat = size.width - paddinWidth
        let widthPerItem: CGFloat = availableWidht / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 80)
    }
}
