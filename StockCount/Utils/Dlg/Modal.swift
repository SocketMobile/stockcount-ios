//
//  Modal.swift
//  ModalView
//
//  Created by Sohel Dhanani 1/17/18.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation

import UIKit

protocol Modal {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

extension Modal where Self:UIView{
    func show(animated:Bool){
        self.backgroundView.alpha = 0
        self.dialogView.alpha = 0
        if var topController = UIApplication.shared.delegate?.window??.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.view.addSubview(self)
        }
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
                self.dialogView.alpha = 1.0
            })
        }else{
            self.backgroundView.alpha = 0.66
            self.dialogView.center  = self.center
        }
    }
    
    func dismiss(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
                self.dialogView.alpha = 0
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
        
    }
}

