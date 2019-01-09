//
//  ParticipantListVC.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 9/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import UIKit

class ParticipantListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    internal var participants: [Participant]!
    internal var repository: LocalDinnerRepository!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.8){
            self.view.backgroundColor =
                UIColor.white.withAlphaComponent(0.8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.repository = LocalDinnerRepository()
        self.participants = self.repository.getAll()
        
        title = "participants"
        
        registerCell()
        let addbarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        
        navigationItem.rightBarButtonItem = addbarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set the cell of the table
    internal func registerCell(){
        let identifier = "ParticipantCell"
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    @objc internal func addPressed () {
        let addVC = AddVC(repository)
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC, animated: true, completion: nil)
        
    }
    
    
    internal func goUpdate(_ index: Int) {
        let participant = participants[index]
        let updVC = UpdateVC(data: participant, repository: repository)
        updVC.modalTransitionStyle = .coverVertical
        updVC.modalPresentationStyle = .overCurrentContext
        present(updVC, animated: true, completion: nil)
    }
}



// tableView extension

extension ParticipantListVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    // update values
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goUpdate(indexPath.row)
    }
    
    // set cells values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ParticipantCell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
        
        let participant = participants[indexPath.row]
        
        cell.cellName.text = participant.myName
        cell.checkMoney.isHidden = participant.paid
        
        
        return cell
    }
    
    // delete row
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle , forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = participants[indexPath.row]
            if repository.delete(a: taskToDelete){
                participants.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}


extension ParticipantListVC: AddViewControllerDelegate, UpdateViewControllerDelegate {
    func addViewController(_ vc:AddVC) {
        vc.dismiss(animated: true) {
            
            self.participants = self.repository.getAll()
            self.tableView.reloadData()
        }
    }
    
    func updViewController(_ vc:UpdateVC) {
        vc.dismiss(animated: true) {

            self.participants = self.repository.getAll()
            self.tableView.reloadData()
        }
    }
    
}
