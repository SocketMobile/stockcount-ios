//
//  InstructionViewController.swift
//  InventoryUtility
//
//  Created by IT Star on 2/15/18.
//  Copyright © 2018 Socket Mobile Inc.
//

import Foundation
import UIKit

class InstructionViewController : UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    
    let img_name_list = ["img_instruction_1", "img_instruction_2", "img_instruction_3"]
    let txt_name_list = ["txt_instruction_1", "txt_instruction_2", "txt_instruction_3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollViewWidth : CGFloat = scrollView.frame.width
        for index in 0 ..< img_name_list.count {
            let imgView = UIImageView(frame: CGRect(x: scrollViewWidth * CGFloat(index), y: 0, width: scrollViewWidth, height: scrollViewWidth))
            imgView.image = UIImage(named: img_name_list[index])
            
            scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: scrollViewWidth * 3, height: scrollViewWidth)
        scrollView.delegate = self
        
        pageControl.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        
        lblDesc.attributedText = getAttributedString(txt_name_list[0].localized)
        btnStart.alpha = 0.5
        
    }
    
    private func getAttributedString(_ str : String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: str)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        updatePageControl()
    }
    
    
    /*private func updatePageControl() {
        for (index, dot) in pageControl.subviews.enumerated() {
            if index == pageControl.currentPage {
                dot.backgroundColor = UIColor.red
                dot.layer.cornerRadius = dot.frame.size.height / 2
            } else {
                dot.backgroundColor = UIColor.clear
                dot.layer.cornerRadius = dot.frame.size.height / 2
                dot.layer.borderColor = UIColor.blue.cgColor
                dot.layer.borderWidth = 0.4
            }
        }
    }*/
    
    //MARK: - ScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage : CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        
        pageControl.currentPage = Int(currentPage)
        
        lblDesc.attributedText = getAttributedString(txt_name_list[Int(currentPage)].localized ?? "")
        
        if Int(currentPage) == img_name_list.count - 1 {
            btnStart.alpha = 1.0
            btnStart.isEnabled = true
        }
//        updatePageControl()
    }
    
    //MARK: - Event
    
    @IBAction func onBtnStart(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("Yes", forKey: "isStarted")
        defaults.synchronize()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
    }
    
}
