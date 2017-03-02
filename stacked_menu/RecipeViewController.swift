//
//  RecipeViewController.swift
//  stacked_menu
//
//  Created by Tim Beals on 2017-03-02.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    var headerString: String? {
        didSet {
            label.text = headerString
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Puttanesca"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = FontManager.headingFont()
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.clear
        textView.text = PlaceHolderText.textViewText()
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorManager.customGrayBlue()
        
        setupView()
        
    }

    func setupView() {
        label.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 26)
        self.view.addSubview(label)
        
        textView.frame = CGRect(x: 20, y: 55, width: self.view.frame.width - 40, height: 360)
        self.view.addSubview(textView)
        
        
    }


}
