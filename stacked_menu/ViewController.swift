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
        label.font = FontManager.headingFont()
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
            
            if dragStartPoint.y < 200 { //you can only drag the view if you touch it near the top
                viewDragging = true
                previousTouchPoint = touchedPoint
            }
            
        } else if recognizer.state == .changed && viewDragging {
            let yOffset = previousTouchPoint.y - touchedPoint.y
            
            draggedView?.center = CGPoint(x: (draggedView?.center.x)!, y: (draggedView?.center.y)! - yOffset)
            previousTouchPoint = touchedPoint
            
        } else if recognizer.state == .ended && viewDragging {
            
            pin(view: draggedView!)
            
            addVelocity(to: draggedView!, panGesture: recognizer)
            
            dynamicAnimator.updateItem(usingCurrentState: draggedView!)
            
            viewDragging = false
        }
    }

    func pin(view: UIView) {
        let viewHasReachedPinLocation = view.frame.origin.y < 170
        
        if viewHasReachedPinLocation {
            if !viewPinned {
                var snapPosition = self.view.center
                snapPosition.y += 120
                snap = UISnapBehavior(item: view, snapTo: snapPosition)
                dynamicAnimator.addBehavior(snap)
                viewPinned = true
                setVisibility(mainView: view, alpha: 0)
            }
        } else {
            if viewPinned {
                dynamicAnimator.removeBehavior(snap)
                viewPinned = false
                setVisibility(mainView: view, alpha: 1)
            }
        }
    }
    
    func setVisibility(mainView: UIView, alpha: CGFloat) {
        for aView in views {
            if aView != mainView {
                aView.alpha = alpha
            }
        }
    }
    
    func addVelocity(to view: UIView, panGesture: UIPanGestureRecognizer) {
        var velocity = panGesture.velocity(in: self.view)
        velocity.x = 0
        
        if let behavior = itemBehaviorfor(view: view) {
            behavior.addLinearVelocity(velocity, for: view)
        }
        
    }
    
    func itemBehaviorfor(view: UIView) -> UIDynamicItemBehavior? {
        
        for behavior in dynamicAnimator.behaviors {
            if let itemBehavior = behavior as? UIDynamicItemBehavior {
                if let possibleView = itemBehavior.items.first as? UIView, possibleView == view {
                    return itemBehavior
                }
            }
        }
        return nil
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        if let number = identifier as! Int? {
            if number == 2 {
                let view = item as! UIView
                pin(view: view)
            }
            
        }
    }
}

