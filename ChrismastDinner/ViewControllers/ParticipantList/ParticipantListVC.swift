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
    internal var filteredParticipants: [Participant]!
    internal var filteredMissParticipants: [Participant]!
    internal var repository: LocalDinnerRepository!

    internal var isFilteringAfirmative: Bool!
    internal var isFilteringnegative: Bool!

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
        self.filteredMissParticipants = self.repository.getPaid(blnPaid: false)
        self.filteredParticipants = self.repository.getPaid(blnPaid: true)
        
        title = "participants"
        isFilteringAfirmative = false
        isFilteringnegative = false
        
        // defined layout cell
        registerCell()
        
        // tabBar add buton
        let addbarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        let filtersButtonItem = UIBarButtonItem(title: "filter", style:.plain, target: self, action: #selector(filterPressed))
        
        navigationItem.rightBarButtonItem = addbarButtonItem
        navigationItem.leftBarButtonItem = filtersButtonItem
        
        
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
    
    @objc internal func filterPressed () {
        let filterVC = DropDownFilter()
        filterVC.delegate = self
        filterVC.modalTransitionStyle = .coverVertical
        filterVC.modalPresentationStyle = .overCurrentContext
        present(filterVC, animated: true, completion: nil)
    }
    
    
    internal func goUpdate(_ index: Int) {
        let participant = participants[index]
        let updVC = UpdateVC(data: participant, repository: repository)
        updVC.delegate = self
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
        if isFilteringAfirmative {
            return filteredMissParticipants.count
        } else if isFilteringnegative {
            return filteredParticipants.count
        }
        return participants.count
    }
    
    // update values
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goUpdate(indexPath.row)
    }
    
    // set cells values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ParticipantCell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
        var participant: Participant
        if isFilteringAfirmative {
            participant = filteredParticipants[indexPath.row]
            
        } else if isFilteringnegative {
            participant = filteredMissParticipants[indexPath.row]
        } else {
            participant = participants[indexPath.row]
            
        }
        
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


extension ParticipantListVC: AddViewControllerDelegate, UpdateViewControllerDelegate, DropDownFilterDelegate{

    func filterList(_ btnSelect: String) {
        if btnSelect == "paid" {
            self.filteredParticipants = self.repository.getPaid(blnPaid: true)
            self.isFilteringAfirmative = true
            self.isFilteringnegative = false
            
            
        } else if btnSelect == "noPaid" {
            self.filteredParticipants = self.repository.getPaid(blnPaid: false)
            self.isFilteringAfirmative = false
            self.isFilteringnegative = true
            
        } else {
            self.isFilteringAfirmative = false
            self.isFilteringnegative = false
        }
    }
    
    func returnListViewController(_ vc: DropDownFilter) {
        vc.dismiss(animated: true) {
            
            if self.isFilteringAfirmative{
                self.filteredParticipants = self.repository.getAll()
                
            } else if self.isFilteringnegative{
                self.filteredMissParticipants = self.repository.getAll()
                
            }else {
                self.participants = self.repository.getAll()
            }
            self.tableView.reloadData()
        }
    }

    func addViewController(_ vc:AddVC) {
        vc.dismiss(animated: true) {
            
            if self.isFilteringAfirmative{
                self.filteredParticipants = self.repository.getAll()
                
            } else if self.isFilteringnegative{
                self.filteredMissParticipants = self.repository.getAll()
                
            }else {
                self.participants = self.repository.getAll()
            }
            self.tableView.reloadData()
        }
    }

    func updViewController(_ vc:UpdateVC) {
        vc.dismiss(animated: true) {

            if self.isFilteringAfirmative{
                self.filteredParticipants = self.repository.getAll()
                
            } else if self.isFilteringnegative{
                self.filteredMissParticipants = self.repository.getAll()
                
            }else {
                self.participants = self.repository.getAll()
            }
            self.tableView.reloadData()
        }
    }
}
