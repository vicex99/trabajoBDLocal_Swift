//
//  UpdateVC.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 9/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import UIKit

protocol UpdateViewControllerDelegate: class {
    func updViewController(_ vc: UpdateVC)
}

class UpdateVC: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnAcept: UIButton!
    @IBOutlet weak var panelBack: UIView!
    @IBOutlet weak var swtpago: UISwitch!
    
    internal var updData: Participant?
    internal weak var repository: LocalDinnerRepository!
    internal weak var delegate: UpdateViewControllerDelegate!
    
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
        
        self.setData()
        
    }
    
    convenience init(data updData: Participant, repository:LocalDinnerRepository!){
        self.init()
        self.repository = repository
        self.updData = updData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func setData () {
        self.tfName.text = self.updData?.myName
        self.swtpago.isOn = (self.updData?.paid)!
       
    }
    
    @IBAction func create() {
        let participant = Participant()
        participant.id  = UUID().uuidString
        participant.myName = tfName.text!
        participant.myDateParticipation = Date()
        participant.paid = swtpago.isOn
    
        // animacion de transicion
        UIView.animate(withDuration: 0.4, animations: {
            self.view.backgroundColor =
                UIColor.white.withAlphaComponent(0.0)
        }) { (bool) in
            if self.repository.update(a: participant) {
                self.delegate?.updViewController(self)
            }
        }
    }
    
    private func comproveDontExist(participant: Participant) -> Bool{
        var end = true
        let actualData = repository.getAll()
        
        for part in actualData {
            if part.myName == participant.myName {
                end = false
            }
        }
        return end
    }
}
