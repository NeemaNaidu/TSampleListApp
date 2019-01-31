//
//  TSCustomTableViewCell.swift
//  TelstraSampleProject
//
//  Created by cts on 24/01/19.
//  Copyright © 2019 cts. All rights reserved.
//

import UIKit

class TSCustomTableViewCell : UITableViewCell {
    var customValues : TSCustomTableValues? {
        didSet {
            listImage.image = customValues?.image
            nameLabel.text = customValues?.name
            descriptionTxtView.text = customValues?.description
        }
    }
    
    public let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.backgroundColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    public let descriptionTxtView : UITextView = {
        let txt = UITextView()
        txt.textColor = .black
        txt.backgroundColor = .white
        txt.isUserInteractionEnabled = false
        txt.font = UIFont.systemFont(ofSize: 15)
        txt.textAlignment = .left
        txt.isScrollEnabled = false
        txt.showsHorizontalScrollIndicator = false
        txt.showsVerticalScrollIndicator = false
        return txt
    }()
    
    public let listImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(listImage)
        addSubview(nameLabel)
        addSubview(descriptionTxtView)
        
        listImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: listImage.leftAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 20, paddingRight: 0, width: 70, height: 65, enableInsets: false)
        nameLabel.anchor(top: topAnchor, left: listImage.rightAnchor, bottom: descriptionTxtView.topAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 18, enableInsets: false)
        descriptionTxtView.anchor(top: nameLabel.bottomAnchor, left: listImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
