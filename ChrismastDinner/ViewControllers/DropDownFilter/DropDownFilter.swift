//
//  DropDownFilter.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 11/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import UIKit

protocol DropDownFilterDelegate: class {
    func filterList(_ btnSelect: String)
    func returnListViewController(_ vc:DropDownFilter)
}

class DropDownFilter: UIViewController {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var btnNPaid: UIButton!
    @IBOutlet weak var btnShowAll: UIButton!
    
    internal weak var delegate: DropDownFilterDelegate!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 1.4, animations: {
            self.view.backgroundColor =
                UIColor.gray.withAlphaComponent(0.8)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.layer.cornerRadius = 8.0
        btnCancel.layer.masksToBounds = true
        
        settingsView.layer.cornerRadius = 8.0
        settingsView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // back to list
    @IBAction private func back() {
        self.delegate.returnListViewController(self)
    }
    
    // button settings
    @IBAction func paidFilter(){
        self.delegate.filterList("paid")
        back()
    }
    @IBAction func noPaidFilter(){
        self.delegate.filterList("noPaid")
        back()
    }
    @IBAction func noFilter(){
        self.delegate.filterList("no")
        back()
    }

}
