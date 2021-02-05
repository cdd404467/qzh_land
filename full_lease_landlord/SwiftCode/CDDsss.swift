//
//  CDDsss.swift
//  full_lease_landlord
//
//  Created by apple on 2020/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CDDsss: BaseViewController {

    typealias textBlock = (String) -> Void
    var block :textBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle = "cdd"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ooo))
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    func cddBlock(block: textBlock?) {
        self.block = block
    }
    

    @objc func ooo(){
        
        if let bk = self.block {
            bk("name")
        }
        
        
    }

}
