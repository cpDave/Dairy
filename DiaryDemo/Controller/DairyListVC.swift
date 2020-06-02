//
//  DairyListVC.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability

class DairyListVC: UIViewController, UITableViewDelegate {
  
    //----------------------------------------
    //MARK:- IBOutlet
    //----------------------------------------
    @IBOutlet weak var tableView: UITableView!
   
    private let disposeBag = DisposeBag()
    var notes: [notesModel] = []
    var dictChatHistory = Dictionary<String, [notesModel]>()
    var arrAllDates = [String]()
    let objCoreData = CoreData_BussinessLogic()
    var reachability: Reachability?

    //----------------------------------------
    //MARK:- View Life Cycle
    //----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation title
        self.title = "My Dairy"
        
        // register tableview cell
        tableView.register(UINib(nibName: "DairyTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        //check internet connection
        if ReachabilityClass.isConnectedToNetwork(){
            print("Internet connection is available")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //lunch first application
            if appDelegate.isAppAlreadyLaunchedOnce(){
                //get notes from api
                self.getNotes()
            }else{
                //get data from local
                self.getvalueFromLocalAndAPI()
            }
        }else{
            //show alertview if internet connection is not available
            self.showAlert(title: "Network error", message: "Unable to contact the server", style: .alert,
                           actions: [AlertAction.action(title: "Ok")])
        }
    }
    
  
    //get data from local
    func getvalueFromLocalAndAPI(){
        //get notes from db
        self.notes = objCoreData.getNotesFromLocal()
        setupTableview()
        
    }
    
    //----------------------------------------
    //MARK:- API CALL
    //----------------------------------------
    func getNotes() {
        let client = APIClient.shared
          do{
            try client.getNotes().subscribe(
              onNext: { result in
                 self.notes = result
                for items in self.notes{
                    self.objCoreData.saveOrUpdateNotesList(notes: items)
                }
                self.setupTableview()
              },
              onError: { error in
                 print(error.localizedDescription)
              },
              onCompleted: {
                 print("Completed event.")
              }).disposed(by: disposeBag)
            }
            catch{
          }
    }
    
  
//----------------------------------------------
    //MARK:- UITableview Datasource and Delegate
//----------------------------------------------
    func setupTableview()
    {
        DispatchQueue.main.async {
            let items = Observable.just(self.notes)

            items
                .bind(to: self.tableView.rx.items(cellIdentifier: "Cell", cellType: DairyTableViewCell.self)) { (row, element, cell) in
                    print(element)
                    
                    // set title
                    cell.lblTitle.text = element.title
                    
                    //set content
                    cell.lblDetails.text = element.content
                    
                    //set time
                    cell.lblTime.text = element.date
                    
                    let localDate = constantVC.formatDateTime(timestamp: "\(element.date)", dateFormat: "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
                    let dataFormatter = DateFormatter()
                    dataFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
                    
                    if let date1 = dataFormatter.date(from: localDate){
                        let lastSeenTime = date1.getElapsedInterval()
                        
                        cell.lblTime.text = lastSeenTime
                        
                        let dayInterval = Date().getDaysDifference(localDate, fromFormat: "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
                        if dayInterval == 0{
                            cell.lblDayName.text = "Today"
                        }else if dayInterval == 1{
                            cell.lblDayName.text = "Yesterday"
                        }else{
                            cell.lblDayName.text = localDate
                        }
                        if row != 0 {
                            cell.timeImageHeight.constant = 0
                            cell.lblDayName.text = ""
                        }else{
                            cell.timeImageHeight.constant = 20
                        }
                    }
                    
                    //set shadow for view
                    cell.containtView.layer.shadowColor = UIColor.black.cgColor
                    cell.containtView.layer.shadowOpacity = 0.2
                    cell.containtView.layer.shadowOffset = .zero
                    cell.containtView.layer.shadowRadius = 3
                    
                    
                    let observable = Observable.merge(
                        cell.btnedit.rx.tap.map { 0 },
                        cell.BtnClose.rx.tap.map { 1 }
                    )
                    // set Button action
                    observable.subscribe(onNext: { id in
                        print("\(id) button is tapped.")
                        if id == 0{
                            if let addVC = self.storyboard?.instantiateViewController(withIdentifier: "DairyDetailsVC") as? DairyDetailsVC {
                                self.navigationController?.pushViewController(addVC, animated: true)
                                addVC.notes = element
                                return
                            }
                        }else{
                            //delete note
                            self.objCoreData.deleteNotes(Id: element.id)
                           
                            self.tableView.delegate = nil
                            self.tableView.dataSource = nil
                            self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
                            self.getvalueFromLocalAndAPI()
                           return
                        }
                    }).disposed(by: self.disposeBag)
            }
            .disposed(by: self.disposeBag)
            
            self.tableView.rx.itemSelected
           .subscribe(onNext: { indexPath in
             print("call from rx.itemSelected")
           })
                .disposed(by: self.disposeBag)
        }
    }
  
   
}

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style
    
    static func action(title: String, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}

extension UIViewController {
    
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction]) -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}
