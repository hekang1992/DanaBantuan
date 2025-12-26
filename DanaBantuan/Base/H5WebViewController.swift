//
//  H5WebViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit
import WebKit

class H5WebViewController: BaseViewController {
    
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
        progressView.progressTintColor = UIColor.systemPink
        progressView.trackTintColor = .clear
        progressView.isHidden = true
        return progressView
    }()
    
    var pageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
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
        
        let h5Url = APIHelper.apiURLString(path: pageUrl) ?? ""
        
        if let encodedUrl = h5Url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrl) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
        
        headView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            }else {
                backProductPageVc()
            }
        }
        
        print("h5Url====: \(h5Url)")
    }
    
}

extension H5WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
}
