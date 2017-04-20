//
//  ViewController.swift
//  DZMTOPTabBarController
//
//  Created by 邓泽淼 on 2017/4/5.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class ViewController: DZMTopTabBarController {

    override func viewDidLoad() {
        
        // 禁止无线滚动
//        limitScroll = false
        
        // 轮播标题显示到导航栏上
        showToNavigationBar = true
        
        // 禁止滚动
//        isScrollEnabled = false
        
        super.viewDidLoad()
        
        // 支持动态更新标题列表
        
//        topBar.updateTitles(titles: <#T##[String]#>)
        
//        topBar.updateTitle(title: <#T##String#>, index: <#T##NSInteger#>)
    }
    
    // 获取标题
    override func getTitles() ->[String] {
        
        return ["推荐","专题","类别"]
    }
    
    // 获取控制器
    var vc1:TempViewController!
    var vc2:TempViewController!
    var vc3:TempViewController!
    
    override func getControllers(viewHeight:CGFloat) ->[UIViewController] {
        
        vc1 = TempViewController()
        vc1.viewHeight = viewHeight
        
        vc2 = TempViewController()
        vc2.viewHeight = viewHeight
        
        vc3 = TempViewController()
        vc3.viewHeight = viewHeight
        
        return [vc1,vc2,vc3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

