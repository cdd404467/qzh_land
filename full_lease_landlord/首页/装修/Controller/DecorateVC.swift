//
//  DecorateVC.swift
//  full_lease_landlord
//
//  Created by apple on 2020/12/24.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit

class DecorateVC: BaseViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "装修"
        setupUI()
        
    }
    
    func setupUI() {
        webView = WKWebView.init()
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        let urlString: String = "http://qzh.comprorent.com/decorate/index.html"
        let url = URL.init(string: urlString)
        let request: URLRequest = URLRequest.init(url: url!)
        webView.load(request)
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(NAV_HEIGHT)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-(TABBAR_HEIGHT + 30))
        }

        let phoneAskBtn = UIButton.init(type: .custom)
        phoneAskBtn.layer.cornerRadius = 4
        phoneAskBtn.clipsToBounds = true
        phoneAskBtn.setTitle("电话咨询", for: .normal)
        phoneAskBtn.backgroundColor = HexColor("#5CDEEA", 1)
        phoneAskBtn.setImage(UIImage.init(named: "icon_phone_ask"), for: .normal)
        phoneAskBtn.setTitleColor(.white, for: .normal)
        phoneAskBtn.addTarget(self, action: #selector(contactPhone), for: .touchUpInside)
        phoneAskBtn.titleLabel?.font = KFont(16)
        phoneAskBtn.adjustsImageWhenHighlighted = false
        view.addSubview(phoneAskBtn)
        phoneAskBtn.snp.makeConstraints { (make) in
            make.left.equalTo(KFit_W(24))
            make.size.equalTo(CGSize(width: KFit_W(150), height: 45))
            make.bottom.equalTo(-Bottom_Height_Dif - KFit_W(12))
        }
        phoneAskBtn.layout(with: .left, imageTitleSpace: 5)

        let entrustBtn = UIButton.init(type: .custom)
        entrustBtn.layer.cornerRadius = 4
        entrustBtn.clipsToBounds = true
        entrustBtn.setTitle("在线联系", for: .normal)
        entrustBtn.backgroundColor = HexColor("#27C3CE", 1)
        entrustBtn.setImage(UIImage.init(named: "icon_house_entrust"), for: .normal)
        entrustBtn.setTitleColor(.white, for: .normal)
        entrustBtn.addTarget(self, action: #selector(jumpToEntrustOnline), for: .touchUpInside)
        entrustBtn.titleLabel?.font = KFont(16)
        entrustBtn.adjustsImageWhenHighlighted = false
        view.addSubview(entrustBtn)
        entrustBtn.snp.makeConstraints { (make) in
            make.right.equalTo(KFit_W(-24))
            make.size.bottom.equalTo(phoneAskBtn)
        }
        phoneAskBtn.layout(with: .left, imageTitleSpace: 5)
    }

    @objc func contactPhone() {
        FastTool.phoneCall(ContactPhone)
    }

    @objc func jumpToEntrustOnline() {
        let vc = DecorateContactOnlineVC.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}
