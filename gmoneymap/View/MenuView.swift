//
//  MenuView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/14.
//

import UIKit

import MessageUI
import KakaoSDKCommon
import KakaoSDKLink
import KakaoSDKTemplate
import SafariServices

class MenuView: BaseViewWithXIB {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuList = ["📋  공지사항", "💾  데이터 다운로드", "❌  오류제보", "⭐️  평점주기", "💕  공유하기", "ℹ️  앱 정보"]
    
    override func setupView() {
        super.setupView()
        
        tableView.registerCustomTableViewCell(reuseIdentifier: MenuTableViewCell.rawString)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // 공지사항
    private func showNoticeList() {
        guard let vc = UIViewController.instantiate(viewController: NoticeListViewController.rawString, in: .Main) as? NoticeListViewController else {
            return
        }
        
        vc.loadViewIfNeeded()
        parentVC.present(vc, animated: true, completion: nil)
    }
    
    // 데이터 다운로드
    private func showDataDownloadView() {
        guard let vc = UIViewController.instantiate(viewController: DataDownloadViewController.rawString, in: .Main) as? DataDownloadViewController else {
            return
        }
        
        vc.loadViewIfNeeded()
        parentVC.present(vc, animated: true, completion: nil)
    }
    
    // 오류제보
    private func sendEmail() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        if MFMailComposeViewController.canSendMail() {
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String else { return }
            
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = rootVC as! ContainerViewController
            compseVC.setToRecipients(["729mail1@gmail.com"])
            compseVC.setSubject("경기지역화폐지도 오류제보")
            compseVC.setMessageBody(
                """
                앱버전 : \(version)
                기기명 : \(UIDevice.modelName) - \(UIDevice.current.systemVersion)
                오류내용 :
                
                """, isHTML: false)
            
            rootVC.present(compseVC, animated: true, completion: nil)
        } else {
            parentVC.customAlert(title: "메일 전송 실패",
                                 message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.",
                                 hasCancel: false)
        }
    }
    
    private func moveToAppStore() {
        let appID = "1584224506"
        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(appID)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) { // 유효한 URL인지 검사합니다.
            UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        } else {
            parentVC.customAlert(title: "오류 발생",
                                 message: "알 수 없는 오류가 발생했습니다 😭",
                                 hasCancel: false)
        }
    }
    
    // 공유하기
    private func kakaoLink() {
        let imageUrl = "https://lee-chance.github.io/gmoneymap.github.io/kakaoLink.png"
        let directUrl = "https://lee-chance.github.io/gmoneymap.github.io/shareApp.html"
            
        // 템플릿 만들기 (피드)
        let feedTemplateJsonStringData =
            """
            {
                "object_type": "feed",
                "content": {
                    "title": "경기지역화폐지도",
                    "description": "경기도민 필수어플!\\n지역화폐 가맹점을 쉽게 찾아보세요.",
                    "image_url": "\(imageUrl)",
                    "link": {
                        "mobile_web_url": "\(directUrl)",
                        "web_url": "\(directUrl)"
                    }
                },
                "buttons": [
                    {
                        "title": "앱 다운로드",
                        "link": {
                            "mobile_web_url": "\(directUrl)",
                            "web_url": "\(directUrl)"
                        }
                    }
                ]
            }
            """.data(using: .utf8)!
        
        // 기본 템플릿으로 카카오링크 보내기
        guard let templatable = try? SdkJSONDecoder.custom.decode(FeedTemplate.self, from: feedTemplateJsonStringData) else { return }
        
        if LinkApi.isKakaoLinkAvailable() {
            LinkApi.shared.defaultLink(templatable: templatable) {(linkResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    if let linkResult = linkResult {
                        UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        } else {
            if let url = LinkApi.shared.makeSharerUrlforDefaultLink(templatable: templatable) {
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.modalTransitionStyle = .crossDissolve
                safariViewController.modalPresentationStyle = .overCurrentContext
                parentVC.present(safariViewController, animated: true)
            }
        }
    }
    
    // 앱 정보
    private func showAppInfoPopup() {
        guard let vc = UIViewController.instantiate(viewController: AppInfoPopupViewController.rawString, in: .Popup) as? AppInfoPopupViewController else {
            return
        }
        
        vc.loadViewIfNeeded()
        parentVC.present(vc, animated: true, completion: nil)
    }
    
}

extension MenuView: UITableViewDataSource, UITableViewDelegate {
    
    var cellHeight: CGFloat { return 52.ratioConstant }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: // 공지사항
            showNoticeList()
        case 1: // 데이터 다운로드
            showDataDownloadView()
        case 2: // 오류제보
            sendEmail()
        case 3: // 평점주기
            moveToAppStore()
        case 4: // 공유하기
            kakaoLink()
        case 5: // 앱 정보
            showAppInfoPopup()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = menuList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.ratioConstant)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: cellHeight, width: Screen.width, height: -1))
        bottomView.backgroundColor = .lightGray
        cell.addSubview(bottomView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
