//
//  NoticeListViewController.swift
//  gmoneymap
//
//  Created by HelloDigital on 2021/07/14.
//

import Foundation

import Firebase

class NoticeListViewController: BaseViewController {
    
    @IBOutlet weak var noticeListTableView: UITableView!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    var noticeList = [Notice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupFirebase()
    }
    
    private func setup() {
        noticeListTableView.delegate = self
        noticeListTableView.dataSource = self
        noticeListTableView.register(UINib(nibName: NoticeListCell.rawString, bundle: nil), forCellReuseIdentifier: NoticeListCell.rawString)
        
        statusBarHeight.constant = Screen.statusBar
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
    }
    
    private func setupFirebase() {
        let db = Firestore.firestore()
        
        db.collection("notices")
            .order(by: "timestamp", descending: true)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        // get title
                        let documentID = document.documentID
                        let index = documentID.firstIndex(of: "_") ?? documentID.endIndex
                        let title = String(documentID[..<index])
                        // get content
                        let contentData = document.data()["content"] as? String ?? "불러오는 중 오류가 발생했습니다."
                        let content = contentData.replacingOccurrences(of: "!@#", with: "\n")
                        
                        self.noticeList.append(Notice(title: title, content: content))
                    }
                    self.noticeListTableView.reloadData()
                }
            }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NoticeListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noticeList[section].opened {
            return 1 + 1 // title + content
        } else {
            return 1 // title
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return UITableView.automaticDimension
//        } else {
//            return UITableView.automaticDimension
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoticeListCell.rawString, for: indexPath) as! NoticeListCell
            cell.cellTitle.text = noticeList[indexPath.section].title
            cell.backgroundColor = .white
            cell.isSelected = noticeList[indexPath.section].opened
            cell.showIcon()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoticeListCell.rawString, for: indexPath) as! NoticeListCell
            cell.cellTitle.text = noticeList[indexPath.section].content
            cell.backgroundColor = UIColor.appColor(.LightGray)
            cell.hideIcon()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            noticeList[indexPath.section].opened = !noticeList[indexPath.section].opened
            tableView.reloadSections([indexPath.section], with: .fade)
        }
    }
    
}

struct Notice {
    let title: String
    let content: String
    var opened = false
}
