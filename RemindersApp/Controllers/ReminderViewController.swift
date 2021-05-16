//
//  ReminderViewController.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//

import UIKit

protocol ReminderAdditionProtocol {
    func isAddButtonEnabled(_ condition: Bool);
}

class ReminderViewController: UIViewController {
   
    @IBOutlet weak var editTextTable: UITableView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var flagView: UIView!
    
    @IBOutlet weak var listLabelView: UIStackView!
    
    @IBOutlet weak var priorityPickerView: UIStackView!
    
    @IBOutlet weak var listTypeText: UILabel!
    
    @IBOutlet weak var labelColor: UIImageView!
    
    @IBOutlet weak var priorityText: UILabel!
    
    @IBOutlet weak var switchFlag: UISwitch!
    
    var priorityId = 0;
    var listItemId: String!
    
    var pickerList = UIPickerView();
    var pickerPriority = UIPickerView();
    var toolBar = UIToolbar()
    
    var toolBarPriority = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
    var toolBarList = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
    
    weak var reminderDelegate: ReminderUpdateControllerDelegate?
    
    
    var priorities : KeyValuePairs =
    [
        "None" : 0,
        "Normal" : 1,
        "Low" : 2,
        "Medium" : 3,
        "High" : 4,
        
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = UIColor.gray
        self.editTextTable.tableFooterView = UIView(frame: .zero)
       editTextTable.alwaysBounceVertical = false;
        editTextTable.layer.cornerRadius = 10
        listView.layer.cornerRadius = 10
        priorityView.layer.cornerRadius = 10
        flagView.layer.cornerRadius = 10
        addButton.isEnabled = false;
         listLabelView.isUserInteractionEnabled = true
        let tapGestureForList = UITapGestureRecognizer(target: self, action: #selector(onListLabelTapped))
        let tapGestureForPriority = UITapGestureRecognizer(target: self, action: #selector(onPriorityLabelTapped))
        listLabelView.addGestureRecognizer(tapGestureForList)
        priorityPickerView.addGestureRecognizer(tapGestureForPriority)
        pickerPriority.tag = 2;
        pickerList.tag = 1;
        switchFlag.isOn = false;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        listTypeText.text = reminderDelegate?.getListItems()[0].name;
        labelColor.tintColor = uiColorFromHex(rgbValue: reminderDelegate?.getListItems()[0].colorCode ?? 0)
        priorityText.text = priorities[priorityId].key
        listItemId = reminderDelegate?.getListItems()[0].id
        
        
    }
        
    @objc func onPriorityLabelTapped(_ sender: UITapGestureRecognizer? = nil){
        
        onBannerTapped(picker: pickerPriority, toolBar: toolBarPriority)
    }
    @objc func onListLabelTapped(_ sender: UITapGestureRecognizer? = nil){
          onBannerTapped(picker: pickerList, toolBar: toolBarList)
          
      }
    
    
    private func onBannerTapped(picker: UIPickerView, toolBar: UIToolbar){
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        toolBar.barStyle = .default
        if(picker.tag == 1){
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil,  action: nil), UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        }
        else {
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil,  action: nil), UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTappedForPriority))]
        }
        self.view.addSubview(toolBar)
    }
  
   
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    @objc func onDoneButtonTapped() {
        listTypeText.text = reminderDelegate?.getListItems()[pickerList.selectedRow(inComponent: 0)].name
        labelColor.tintColor = uiColorFromHex(rgbValue: reminderDelegate?.getListItems()[pickerList.selectedRow(inComponent: 0)].colorCode ?? 0 )
        listItemId = reminderDelegate?.getListItems()[pickerList.selectedRow(inComponent: 0)].id
        toolBarList.removeFromSuperview()
        pickerList.removeFromSuperview()
        
    }
    
    @objc func onDoneButtonTappedForPriority() {
        priorityId = pickerPriority.selectedRow(inComponent: 0)
        priorityText.text = priorities[priorityId].key
        toolBarPriority.removeFromSuperview()
        pickerPriority.removeFromSuperview()
    }
    
    
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var index = IndexPath(row: 0, section: 0);
        let titleText = (editTextTable.cellForRow(at: index) as! NewReminderCell).editText.text!
        index = IndexPath(row: 1, section: 0);
        let notesText = (editTextTable.cellForRow(at: index) as! NewReminderCell).editText.text ?? "";
        let flag = switchFlag.isOn;
        let reminderItem = ReminderItem(title: titleText, notes: notesText, flag: flag, priority: priorityId, listItemId: listItemId!)
        reminderDelegate?.addListItem(item: reminderItem)
        dismiss(animated: true, completion: nil);
        
    }
}

extension ReminderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderEditCell") as! NewReminderCell;
        var text = "";
        var isMandatory = false;
        if indexPath.row == 1{
            text = "Notes";
        }
        else {
            text = "Title";
            isMandatory = true;
        }
        cell.configure(text: text, isMandatory: isMandatory)
        cell.reminderAddition = self;
        cell.selectionStyle = .none;
        
        return cell;
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.row == 1 {
            height = 100
        }
        else {
            height = 50
        }
        return height
    }
    
    
}

extension ReminderViewController : ReminderAdditionProtocol {
    func isAddButtonEnabled(_ condition: Bool) {
        addButton.isEnabled = condition;
    }
}

extension ReminderViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return reminderDelegate?.getListItems().count ?? 0;
        }
        return priorities.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 1){
            return reminderDelegate?.getListItems()[row].name;
        }
        return priorities[row].key;
    }
    
    
   
}





