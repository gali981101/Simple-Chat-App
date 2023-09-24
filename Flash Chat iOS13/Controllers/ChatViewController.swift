//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
}


// MARK: - Setting

extension ChatViewController {
    
    private func setUp() {
        loadTextData()
        setTableViewDelegate()
        cellNibSet()
        layOut()
    }
    
    private func setTableViewDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func cellNibSet() {
        tableView.register(UINib(nibName: Contants.cellNibName, bundle: nil), forCellReuseIdentifier: Contants.cellIdentifier )
    }
    
}


// MARK: - LayOut

extension ChatViewController {
    
    private func layOut() {
        navigationItem.hidesBackButton = true
        title = Contants.appName
    }
    
}


// MARK: - @IBAction

extension ChatViewController {
    
    @IBAction func sendPressed(_ sender: UIButton) {
        checkData(messageTextfield.text, Auth.auth().currentUser?.uid, Auth.auth().currentUser?.email)
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        userSignOut()
    }
    
}


// MARK: - Upload Data To Firestore

extension ChatViewController {
    
    private func checkData(_ message: String?, _ uid: String?, _ email: String?) {
        messages = []
        
        if let message = message, let uid = uid, let email = email {
            textNotEmpty(message, uid, email)
        }
    }
    
    private func textNotEmpty(_ message: String, _ uid: String, _ email: String) {
        if message != "" {
            uploadFirestore(message, uid, email)
        } else {
            makeAlert()
        }
    }
    
    private func uploadFirestore(_ message: String, _ uid: String, _ email: String) {
        let dataDic = [
            Contants.FStore.senderField: email,
            Contants.FStore.bodyField: message,
            Contants.FStore.dateField: Date().timeIntervalSince1970,
            "User UID": uid
        ] as [String : Any]
        
        db.collection(Contants.FStore.collectionName)
            .addDocument(data: dataDic, completion: errorCompletion(_:))
    }
    
    private func errorCompletion(_ e: Error?) {
        if let e = e {
            print(e.localizedDescription)
        } else {
            clearTextField()
            view.endEditing(true)
            print("Successfully saved data.")
        }
    }
    
    private func clearTextField() {
        DispatchQueue.main.async { [self] in
            messageTextfield.text = ""
        }
    }
    
}


// MARK: - Load Data from Firestore

extension ChatViewController {
    
    private func loadTextData() {
        db.collection(Contants.FStore.collectionName)
            .order(by: Contants.FStore.dateField)
            .addSnapshotListener(listenerCompletion(_:_:))
    }
    
    private func listenerCompletion(_ snapshot: QuerySnapshot?, _ error: Error?) {
        messages = []
        
        if let e = error {
            print(e.localizedDescription)
        } else {
            loopForDocuments(snapshot!)
        }
    }
    
    private func loopForDocuments(_ snap: QuerySnapshot) {
        for document in snap.documents {
            messages.append(Message(sender: document.get("sender") as! String, body: document.get("body") as! String))
        }
        
        reloadTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .top, animated: true)
        }
    }
    
}


// MARK: - Sign Out

extension ChatViewController {
    
    private func userSignOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}


// MARK: - TableView DataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Contants.cellIdentifier, for: indexPath) as! MessageCell
        
        cell.label.text = messages[indexPath.row].body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Contants.BrandColors.blue)
            cell.label.textColor = .white
        } else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Contants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Contants.BrandColors.purple)
        }
        
        return cell
        
    }
    
}


// MARK: - TableView Delegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}


// MARK: - Alert

extension ChatViewController {
    
    private func makeAlert() {
        let alert = UIAlertController(title: "請輸入訊息", message: "撰寫文字後，才能發送", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
    
}
