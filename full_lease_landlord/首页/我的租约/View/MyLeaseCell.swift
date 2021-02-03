//
//  MyLeaseCell.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/12.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class MyLeaseCell: BaseTableViewCell {

    var addressLab: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupUI() {
        self.backgroundColor = HexColor("#f5f5f5", 1)

        let bgView: UIView = UIView.init(frame: CGRect.init(x: KFit_W(16), y: 0, width: SCREEN_WIDTH - KFit_W(32), height: KFit_W(108)))
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 5
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = HexColor("#000000", 0.05).cgColor
        self.contentView.addSubview(bgView)
        
        addressLab = UILabel.init()
        addressLab?.textColor = HexColor("#333333", 1)
        addressLab?.font = KFont(14)
        bgView.addSubview(addressLab!)
        addressLab?.snp.makeConstraints { (make) in
            make.left.equalTo(KFit_W(16));
            make.top.equalTo(20);
            make.height.equalTo(KFit_W(20));
            make.right.equalTo(0);
        }
    }
}
