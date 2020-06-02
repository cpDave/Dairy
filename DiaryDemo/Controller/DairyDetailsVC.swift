//
//  DairyDetailsVC.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import UIKit

class DairyDetailsVC: UIViewController {
    
    //-------------------------------------------------------
    //MARK:-IBOutlet
    //-------------------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtTitle: UITextView!
    
    @IBOutlet weak var lblcontent: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    
    @IBOutlet weak var BtnSave: UIButton!
    
    var notes:notesModel?
    
    let objCoreData = CoreData_BussinessLogic()

    let textView = UITextView()
    //-------------------------------------------------------
    //MARK:- UIView Life Cycle
    //-------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dairy Title"
        
        //setup data
        self.txtTitle.text = notes?.title
        self.txtContent.text = notes?.content
        
        //set dynamic height for texview
//        adjustUITextViewHeight(arg: self.txtTitle)
//        adjustUITextViewHeight(arg: self.txtContent)
        
      
    
    }
    
    //set dynamic height method
    func adjustUITextViewHeight(arg : UITextView)
    {
        var frame = arg.frame
        frame.size.height = arg.contentSize.height
        arg.frame = frame
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = true
    }
    
    
    //-------------------------------------------------------
    //MARK:- UIButton Action
    //-------------------------------------------------------
    @IBAction func BtnSave(_ sender: UIButton) {
        let note = notesModel(id: notes?.id ?? "", title: self.txtTitle.text, content: self.txtContent.text, date: notes?.date ?? "")
        objCoreData.saveOrUpdateNotesList(notes: note)
        self.navigationController?.popViewController(animated: true)
    }

    //-----------------------------------------------------
    //MARK:- TEXTVIEW DELEGATE METHODS
    //-----------------------------------------------------
   


}
