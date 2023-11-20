//
//  AuthPermissionWebView.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import UIKit
import WebKit

protocol UserAuthPermissionRequestDelegate: AnyObject {
    func didRequestUserAuthWithSuccess()
}

final class UserAuthPermissionWebViewController: UIViewController, WKUIDelegate {
    private var webView: WKWebView!
    private let delegate: UserAuthPermissionRequestDelegate
    
    private var resultHandler: ((Result<Void, MovieFetchingError>) -> Void)?
    
    init(delegate: UserAuthPermissionRequestDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
}

extension UserAuthPermissionWebViewController: WKNavigationDelegate{
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        // this means login successful
        if url.absoluteString.contains("/allow") {
            // if we execute resultHandler too soon - tmdb api will return "auth error 17 session denied"
            let deadline: DispatchTime = .now() + 0.1
            DispatchQueue.global().asyncAfter(deadline: deadline) { [weak self] in
                self?.resultHandler?(.success(()))
                self?.delegate.didRequestUserAuthWithSuccess()
            }
        }
        decisionHandler(.allow)
    }
}

extension UserAuthPermissionWebViewController: UserAuthPermissionRequestWorkerProtocol {
    func requestUserAuthPermission(url: URL, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        let myRequest = URLRequest(url: url)
        resultHandler = completion
        webView.load(myRequest)
    }
}
