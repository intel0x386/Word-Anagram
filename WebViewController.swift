//
//  WebViewController.swift
//  Word Scrambler - Final
//
//  Created by Ankit Shah on 2/27/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    var word: String!
    var maskedWord: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //webView.isHidden = true
        
        guard let word = word else { return }

        let url = URL(string: "https://www.merriam-webster.com/dictionary/\(word)")!
        let urlR = URLRequest(url: url)
        
        webView.load(urlR)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
