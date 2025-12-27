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
        progressView.progressTintColor = UIColor.systemPink
        progressView.trackTintColor = .clear
        progressView.progress = 0
        progressView.isHidden = true
        return progressView
    }()
    
    var pageUrl: String = ""
    
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
                backProductPageVc()
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
        // JS 回调处理
    }
}
