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
    private let iconContainerView:UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        let images = [#imageLiteral(resourceName: "like"),#imageLiteral(resourceName: "love"),#imageLiteral(resourceName: "haha"),#imageLiteral(resourceName: "wow"),#imageLiteral(resourceName: "sad"),#imageLiteral(resourceName: "angry")]
        let iconHeight: CGFloat = 50
        let padding: CGFloat = 8
        
        let arrangedSubViews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubViews.count)
        let width = numIcons * iconHeight + (numIcons + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        
        stackView.frame = containerView.frame
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLikeButtonLongPress()
        self.dismissKeyBoard()
        print(likeButton.frame)
    }
    
    private func setupLikeButtonLongPress() {
        likeButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                self.iconContainerView.transform = self.iconContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconContainerView.alpha = 0
            }, completion: {(_) in
                self.iconContainerView.removeFromSuperview()
                })
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    private func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconContainerView)
        let pressedLocation = gesture.location(in: self.view)
        let centeredX = (view.frame.width - iconContainerView.frame.width) / 2
        
        iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - likeButton.frame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconContainerView.frame.height)
            self.iconContainerView.alpha = 1
        })
    }
    
    private func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconContainerView)
        let hitEmoji = iconContainerView.hitTest(pressedLocation, with: nil)
        if hitEmoji is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                hitEmoji?.transform = CGAffineTransform(translationX: 0, y: -30)
            }, completion: nil)
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

