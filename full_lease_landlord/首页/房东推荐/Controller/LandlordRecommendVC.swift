//
//  LandlordRecommendVC.swift
//  full_lease_landlord
//
//  Created by apple on 2021/2/19.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import WebKit

class LandlordRecommendVC: BaseViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    @objc var urlString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "装修"
        setupUI()
        
    }
    
    private func setupUI() {
        webView = WKWebView.init()
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        let url = URL.init(string: urlString)
        let request: URLRequest = URLRequest.init(url: url!)
        webView.load(request)
        view.addSubview(webView)
        webView.snp.makeConstraints { 
            $0.top.equalTo(NAV_HEIGHT)
            $0.left.right.equalTo(0)
            $0.bottom.equalTo(-(TABBAR_HEIGHT + 30))
        }

        let phoneAskBtn = UIButton.init(type: .custom)
        phoneAskBtn.layer.cornerRadius = 4
        phoneAskBtn.clipsToBounds = true
        phoneAskBtn.setTitle("电话咨询", for: .normal)
        phoneAskBtn.backgroundColor = HexColor("#F5A623", 1)
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

        let recommendBtn = UIButton.init(type: .custom)
        recommendBtn.layer.cornerRadius = 4
        recommendBtn.clipsToBounds = true
        recommendBtn.setTitle("在线推荐", for: .normal)
        recommendBtn.backgroundColor = HexColor("#CF0019", 1)
        recommendBtn.setImage(UIImage.init(named: "icon_house_entrust"), for: .normal)
        recommendBtn.setTitleColor(.white, for: .normal)
        recommendBtn.addTarget(self, action: #selector(jumpToRecommendOnline), for: .touchUpInside)
        recommendBtn.titleLabel?.font = KFont(16)
        recommendBtn.adjustsImageWhenHighlighted = false
        view.addSubview(recommendBtn)
        recommendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(KFit_W(-24))
            make.size.bottom.equalTo(phoneAskBtn)
        }
        recommendBtn.layout(with: .left, imageTitleSpace: 5)
    }
    
    @objc func contactPhone() {
        FastTool.phoneCall(ContactPhone)
    }
    
    @objc func jumpToRecommendOnline() {
        let vc = RecommendNowVC.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}
