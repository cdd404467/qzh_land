//
//  PrivacyAgreementVC.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/5.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import WebKit

class PrivacyAgreementVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "隐私政策"
        loadWebView()
    }
    
    func loadWebView() {
        let webView = WKWebView.init()
        webView.backgroundColor = .white
        let urlString: String = "http://yzh.yizuhui.vip/yinsi.html"
        let url = URL.init(string: urlString)
        let request: URLRequest = URLRequest.init(url: url!)
        webView.load(request)
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(NAV_HEIGHT)
            make.left.right.bottom.equalTo(0)
        }
    }
}
