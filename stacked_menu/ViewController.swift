//
//  ViewController.swift
//  stacked_menu
//
//  Created by Tim Beals on 2017-03-01.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    let data = ["Puttanesca", "Couscous salad", "Sundried Tomato Loaf", "Green Curry"]
    
    var views = [UIView]()
    
    var dynamicAnimator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var snap: UISnapBehavior!
    var previousTouchPoint: CGPoint!
    var viewDragging = false
    var viewPinned = false
    
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.black
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.text = "Seasonal Specials"
        label.textColor = ColorManager.customDarkGray()
        label.font = UIFont(name: "BanglaSangamMN-Bold", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupAnimator()
        setupBackground()
        

        
        var offset: CGFloat = 250
        
        for string in data {
            if let view = addViewController(atOffset: offset, withData: string as AnyObject?) {
                views.append(view)
                offset -= 50
            }
        }
    }


    
    func setupAnimator() {
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        gravity.magnitude = 4
        dynamicAnimator.addBehavior(gravity)
        
    }
    
    func setupBackground() {
        self.view.backgroundColor = UIColor.white
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.66)
        imageView.image = UIImage(named: "healthy_recipes")
        self.view.addSubview(imageView)
        
        label.frame = CGRect(x: 0, y: 70, width: self.view.frame.width - 16, height: 30)
        self.view.addSubview(label)
        
    }

    func addViewController(atOffset offset:CGFloat, withData data:AnyObject?) -> UIView? {
        
        
        //let frameForView = self.view.frame
        let frameForView = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
        
        let recipeVC = RecipeViewController()
        
        if let recipeView = recipeVC.view {
            recipeView.frame = frameForView
            recipeView.layer.cornerRadius = 5
            recipeView.layer.shadowOffset = CGSize(width: 2, height: 2)
            recipeView.layer.shadowColor = UIColor.black.cgColor
            recipeView.layer.shadowRadius = 3
            recipeView.layer.shadowOpacity = 0.5
            
            if let headerStr = data as! String? {
                recipeVC.headerString = headerStr
            }
            
            self.addChildViewController(recipeVC)
            view.addSubview(recipeView)
            recipeVC.didMove(toParentViewController: self)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            recipeView.addGestureRecognizer(panGestureRecognizer)

            let collision = UICollisionBehavior(items: [recipeView])
            collision.collisionDelegate = self
            dynamicAnimator.addBehavior(collision)

            //lower boundary
            let boundaryY = recipeView.frame.origin.y + recipeView.frame.size.height
            var boundaryStart = CGPoint(x: 0, y: boundaryY)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundaryY)
            collision.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)

            //upper boundary
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundary(withIdentifier: 2 as NSCopying, from: boundaryStart, to: boundaryEnd)

            gravity.addItem(recipeView)
            
            //Need to add dynamic item behavior to check state in handlePan(recognizer:)
            let itemBehavior = UIDynamicItemBehavior(items: [recipeView])
            
            dynamicAnimator.addBehavior(itemBehavior)
            
            return recipeView
            
        }
        
        
        return nil
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let touchedPoint = recognizer.location(in: self.view)
        let draggedView = recognizer.view
        
        if recognizer.state == .began {
            let dragStartPoint = recognizer.location(in: draggedView)
            
            if dragStartPoint.y < 200 {
                viewDragging = true
                previousTouchPoint = touchedPoint
                
            } else if recognizer.state == .changed && viewDragging {
                let yOffset = previousTouchPoint.y - touchedPoint.y
                
                draggedView?.center = CGPoint(x: draggedView?.center.x, y: draggedView?.center.y - yOffset)
                previousTouchPoint = touchedPoint
                
            } else if recognizer.state == .ended && viewDragging {
                
                dynamicAnimator.updateItem(usingCurrentState: <#T##UIDynamicItem#>)
                
            }
        }
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

