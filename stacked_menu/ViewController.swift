//
//  ViewController.swift
//  stacked_menu
//
//  Created by Tim Beals on 2017-03-01.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.black
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
//        setupBackground()
        
    }

    
    func setupBackground() {
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.66)
        self.view.addSubview(imageView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

