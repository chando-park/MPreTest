import UIKit
import WebKit

class WebViewController: UIViewController {
    var url: URL!
    var pageTitle: String!

    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupNavigationBar()
        
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.title = pageTitle    
    }

}
