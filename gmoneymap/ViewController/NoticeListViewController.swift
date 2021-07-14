//
//  NoticeListViewController.swift
//  gmoneymap
//
//  Created by HelloDigital on 2021/07/14.
//

import Foundation

class NoticeListViewController: BaseViewController {
    
    @IBOutlet weak var noticeListTableView: UITableView!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    // DEBUG: 파이어베이스 데이터로 변환 후 삭제
    var noticeList = [
        Notice(title: "title", content: "긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠긴 컨텐츠 긴 컨텐츠 긴 컨텐츠"),
        Notice(title: "2", content: """
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeListTableView.delegate = self
        noticeListTableView.dataSource = self
        noticeListTableView.register(UINib(nibName: NoticeListCell.rawString, bundle: nil), forCellReuseIdentifier: NoticeListCell.rawString)
        
        statusBarHeight.constant = Screen.statusBar
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
    }
"""),
        Notice(title: "3", content: "content2"),
        Notice(title: "4444", content: "content3"),
        Notice(title: "555", content: "content5")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeListTableView.delegate = self
        noticeListTableView.dataSource = self
        noticeListTableView.register(UINib(nibName: NoticeListCell.rawString, bundle: nil), forCellReuseIdentifier: NoticeListCell.rawString)
        
        statusBarHeight.constant = Screen.statusBar
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
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
        if noticeList[section].opened == true {
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
            // TODO: 열고 닫는 화살표 추가해야됨
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoticeListCell.rawString, for: indexPath) as! NoticeListCell
            cell.cellTitle.text = noticeList[indexPath.section].content
            cell.backgroundColor = .systemPink // FIXME: 옅은 회색
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
