//
//  H5WebViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit
import WebKit
import RxSwift
import RxCocoa
import StoreKit

class H5WebViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        ["fortior",
         "suggestage",
         "septuagesimability",
         "athroidward",
         "issuesome",
         "itemon"].forEach {
            config.userContentController.add(self, name: $0)
        }
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(hex: "#EF7CFC")
        progressView.trackTintColor = .clear
        progressView.progress = 0
        progressView.isHidden = true
        return progressView
    }()
    
    var pageUrl: String = ""
    
    private var locationTool: LocationTool?
    
    private let launchViewModel = LaunchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindWebView()
        loadWeb()
    }
    
    // MARK: - UI
    private func setupUI() {
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(webView)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        headView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - Load
    private func loadWeb() {
        
        let h5Url = APIHelper.apiURLString(path: pageUrl) ?? ""
        print("h5Url====: \(h5Url)")
        
        if let encodedUrl = h5Url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrl) {
            webView.load(URLRequest(url: url))
        }
    }
    
    // MARK: - Rx Bindings
    private func bindWebView() {
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] progress in
                guard let self = self else { return }
                
                self.progressView.isHidden = progress >= 1.0
                self.progressView.setProgress(Float(progress), animated: true)
                
                if progress >= 1.0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.progressView.progress = 0
                    }
                }
            })
            .disposed(by: disposeBag)
        
        webView.rx.observe(Bool.self, "loading")
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.progressView.isHidden = !loading
            })
            .disposed(by: disposeBag)
        
        webView.rx.observe(String.self, "title")
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.headView.configure(withTitle: title)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - JS Bridge
extension H5WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        let name = message.name
        let body = message.body
        
        print("name=====\(name)")
        print("body=====\(body)")
        
        switch name {
        case "fortior":
            snapiktInfo(body as? [String] ?? [])
            break
            
        case "suggestage":
            handleSuggestage(message.body)
            
        case "septuagesimability":
            navigationController?.popViewController(animated: true)
            
        case "athroidward":
            changeRootVc()
            
        case "issuesome":
            handleSendEmail(message.body)
            
        case "itemon":
            toAppStore()
            
        default:
            break
        }
    }
}

// MARK: - Private Methods
private extension H5WebViewController {
    
    func snapiktInfo(_ body: [String]) {
        locationTool = LocationTool(presentingVC: self)
        locationTool?.startLocation { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                print("result====\(result)")
                Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    AppLocationModel.shared.locationJson = result
                }
            } else {
                
            }
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            let productID = body.first ?? ""
            let odrdeID = body.last ?? ""
            await self.stayApp(with: productID, orderID: odrdeID)
        }
        
    }
    
    func handleSuggestage(_ body: Any) {
        guard let pageUrl = body as? String, !pageUrl.isEmpty else { return }
        
        if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
            URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
        } else {
            if pageUrl.isEmpty {
                return
            }
            self.pageUrl = pageUrl
            loadWeb()
        }
    }
    
    func handleSendEmail(_ body: Any) {
        guard let email = body as? String, !email.isEmpty else { return }
        sendEmailInfo(with: email)
    }
    
    func toAppStore() {
        guard #available(iOS 14.0, *),
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    func sendEmailInfo(with email: String) {
        let phone = UserLoginConfig.phone ?? ""
        let body = "Dana Bantuan: \(phone)"
        
        guard let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let emailURL = URL(string: "mailto:\(email)?body=\(encodedBody)"),
              UIApplication.shared.canOpenURL(emailURL) else {
            return
        }
        
        UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
    }
}

extension H5WebViewController {
    
    private func stayApp(with productID: String, orderID: String) async {
        if LanguageManager.currentLanguage == .en {
            return
        }
        let locationJson = AppLocationModel.shared.locationJson ?? [:]
        let amward = locationJson["amward"] ?? ""
        let rhizeur = locationJson["rhizeur"] ?? ""
        do {
            let json = ["cupship": String(Int(Date().timeIntervalSince1970)),
                        "laud": String(Int(Date().timeIntervalSince1970)),
                        "amward": amward,
                        "rhizeur": rhizeur,
                        "recordage": "9",
                        "selenality": orderID,
                        "archaeoourster": productID]
            let _ = try await launchViewModel.uploadSnippetInfo(json: json)
        } catch {
            
        }
    }
    
}
