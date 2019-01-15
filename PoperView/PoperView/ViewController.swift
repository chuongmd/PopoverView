//
//  ViewController.swift
//  PoperView
//
//  Created by Chuongmd on 1/14/19.
//  Copyright © 2019 chuongmd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var likeButton: UIButton!
    let iconContainerView:UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .red
        containerView.frame = CGRect(x: 0, y: 0, width: 215, height: 40)
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLikeButtonLongPress()
        self.dismissKeyBoard()
        print(likeButton.frame)
    }
    
    fileprivate func setupLikeButtonLongPress() {
        likeButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            view.addSubview(iconContainerView)
            let locationPress = gesture.location(in: self.view)
            let centeredX = (view.frame.width - iconContainerView.frame.width) / 2
            
            iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: locationPress.y - likeButton.frame.height)
            
        } else if gesture.state == .ended {
            iconContainerView.removeFromSuperview()
        }
    }

    private func dismissKeyBoard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleDismissKeyBoard() {
        view.endEditing(true)
    }
}

