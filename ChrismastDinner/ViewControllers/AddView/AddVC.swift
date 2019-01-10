//
//  AddVC.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 9/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: class {
    func addViewController(_ vc: AddVC)
}

class AddVC: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnAcept: UIButton!
    @IBOutlet weak var panelBack: UIView!
    @IBOutlet weak var swtpago: UISwitch!
    
    internal weak var repository: LocalDinnerRepository!
    internal weak var delegate: AddViewControllerDelegate!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 1.4, animations: {
            self.view.backgroundColor =
                UIColor.gray.withAlphaComponent(0.8)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAcept.layer.cornerRadius = 8.0
        btnAcept.layer.masksToBounds = true
        
        panelBack.layer.cornerRadius = 8.0
        panelBack.layer.masksToBounds = true
        
    }
    
    convenience init(_ repository:LocalDinnerRepository!){
        self.init()
        self.repository = repository
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func create() {
        let participant = Participant()
        participant.id  = UUID().uuidString
        participant.myName = tfName.text!
        participant.myDateParticipation = Date()
        participant.paid = swtpago.isOn
        
        if (comproveDontExist(participant: participant) && participant.myName != "") {
            // animacion de transicion
            UIView.animate(withDuration: 0.4, animations: {
                self.view.backgroundColor =
                    UIColor.white.withAlphaComponent(0.0)
            }) { (bool) in
                if self.repository.create(a: participant) {
                    self.delegate?.addViewController(self)
                }
            }
        }else {
            let alert = UIAlertController(title: "ERROR", message: "name actual used", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func comproveDontExist(participant: Participant) -> Bool{
        
        let actualData = repository.getAll()
        
        for part in actualData {
            if part.myName == participant.myName {
                return false
            }
        }
        return true
    }
}
