//
//  TempViewController.swift
//  HJTOPTabBarController
//
//  Created by 邓泽淼 on 2017/3/14.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

/// RGBA
func RGBA(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

class TempViewController: UIViewController {
    
    var index:NSInteger = 0
    
    var label:UILabel!
    
    /// 要实现 (必须) 请继续使用 view.frame.size.height 来获取高度
    var viewHeight:CGFloat?
    
    /// 要实现 (必须)
    override func loadView() {
        super.loadView()
       
        if viewHeight != nil {
            
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewHeight!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = RGBA(CGFloat(arc4random() % 255), g: CGFloat(arc4random() % 255), b: CGFloat(arc4random() % 255), a: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
