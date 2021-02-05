//
//  TestSwift.swift
//  full_lease_landlord
//
//  Created by apple on 2020/9/28.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class TestSwift: BaseViewController {
    typealias cddBlock = (_ name:String) -> Void
    @objc var cblock :cddBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "test"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ttt))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func cddBlock(block: cddBlock?) {
        self.cblock = block
    }
    
    @objc func ttt() {
        if let bk = self.cblock {
            bk("cdd")
        }
        
//        let vc = CDDsss()
//        vc.block = { name in
//            print(name)
//        }
//        navigationController?.pushViewController(vc, animated: true)
    }
    

}
