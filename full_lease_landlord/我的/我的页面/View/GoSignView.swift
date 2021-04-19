//
//  GoSignView.swift
//  full_lease_landlord
//
//  Created by apple on 2021/4/8.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class GoSignView: UIView {

    @objc var msgTitle: UILabel!
    @objc var signingBtn: UIButton!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HexColor("#F1FBFC", 1)
        setupUI()
    }
    
    private func setupUI() {
        msgTitle = UILabel()
        msgTitle.font = KFont(12)
        msgTitle.textColor = HexColor("#606266", 1)
        self.addSubview(msgTitle)
        msgTitle.snp.makeConstraints { (make) in
            make.left.equalTo(KFit_W(14))
            make.centerY.equalTo(self)
        }
        
        signingBtn = UIButton.init(type: .custom)
        signingBtn.setTitle("去签约", for: .normal)
        signingBtn.setTitleColor(HexColor("#64D9C1", 1), for: .normal)
        signingBtn.titleLabel?.font = KFont(12)
        self.addSubview(signingBtn)
        signingBtn.snp.makeConstraints { (make) in
            make.right.equalTo(KFit_W(-14))
            make.centerY.equalTo(msgTitle)
            make.width.equalTo(KFit_W(42))
            make.height.equalTo(self)
        }
        
    }
    
}
