//
//  OAuthViewController.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 8/10/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit
import WebKit

class OAuthViewController: UIViewController {
    private let clientID = AuthCredentials.clientID
    private let clientSecret = AuthCredentials.clientSecret
    
    private let uuid = UUID().uuidString
    var shouldRedirect = false
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard var request = tokenGetRequest else {
            return
        }
        request.httpMethod = "GET"
        webView.load(request)
        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        webView.navigationDelegate = nil
    }
    
    private var tokenGetRequest: URLRequest?{
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize")else{
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: "gist"),
            URLQueryItem(name: "state", value: uuid)
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    func showTabController(){
        print("success")
        performSegue(withIdentifier: "ShowTabController", sender: nil)
    }
    
    func requestAccessToken(code: String){
        let urlString = "https://github.com/login/oauth/access_token"
        guard var urlComponents = URLComponents(string: urlString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data else{
                return
            }
            guard error == nil else{
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200..<300 ~= statusCode else{
                print("Error: Incorrect status code: \(statusCode).")
                return
            }
            print(statusCode)

            do{
                let decoder = JSONDecoder()
                let token = try decoder.decode(AccessToken.self, from: data)
                print(token)
                
                GistApi.apiKey = token.access_token
                print(token.access_token)
                self.shouldRedirect = false
                DispatchQueue.main.async {
                    self.showTabController()
                }
            }catch{
                print(error)
            }
            
            }
        dataTask.resume()
        if (shouldRedirect) {
            showTabController()
        } else {
            shouldRedirect = true
        }
    }

}

extension OAuthViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "notes" {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                print("code: \(code)")
                requestAccessToken(code: code)
            }
        }
        defer {
            decisionHandler(.allow)
        }
    }
}
