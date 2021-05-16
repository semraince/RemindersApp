//
//  NewReminderCell.swift
//  RemindersApp
//
//  Created by semra on 13.05.2021.
//

import UIKit

class NewReminderCell: UITableViewCell {

    var placeholder = ""
    let start = NSRange(location: 0, length: 0)
    var isMandatoryField: Bool?
    var reminderAddition: ReminderAdditionProtocol?
    var buttonEnabled = false;
    
    
    @IBOutlet weak var editText: UITextView!
    
    func configure(text: String, isMandatory: Bool){
        placeholder = text;
        editText.delegate = self;
        isMandatoryField = isMandatory
        placeholder = text
        editText.text = text
        editText.textColor = UIColor.gray
        editText.alwaysBounceVertical = false;
    
    }

}

extension  NewReminderCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if editText.text == placeholder {
            editText.text = ""
            editText.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if editText.text == "" {
            editText.text = placeholder
            editText.textColor = UIColor.gray
            
        }
       
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let isMandatory = isMandatoryField , isMandatory == true {
            if(!buttonEnabled && !textView.text.isEmpty) {
                buttonEnabled = true;
                reminderAddition?.isAddButtonEnabled(buttonEnabled);
            }
            else if (buttonEnabled && textView.text.isEmpty) {
                buttonEnabled = false;
                reminderAddition?.isAddButtonEnabled(buttonEnabled);
            }
        }//Handle the text changes here
        
    }
}


