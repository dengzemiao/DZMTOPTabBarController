//
//  DZMTopTabBarController.swift
//  DZMTopTabBarController
//
//  Created by 邓泽淼 on 2017/3/13.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

/** 建议继承使用 ----- 子控制器需要 viewHeight 进行修改 view 的显示范围  **/

class DZMTopTabBarController: UIViewController,DZMTopBarDelegate,DZMCycleScrollViewDelegate {
    
    /// true 无限滚动(views 必须至少2个)  false 不会无限滚动
    var limitScroll:Bool = true
    
    /// topBar 高度
    var topBarHeight:CGFloat = 60
    
    /// topBar 显示到导航栏上
    var showToNavigationBar:Bool = false
    
    /// tabBar 是否隐藏
    var isTabBarHidden:Bool = true
    
    /// 初始化选中
    var initSelectIndex:NSInteger = 0
    
    /// 动画时间
    var animateDuration:TimeInterval = 0.2
    
    /// 标题列表 重写 func getTitles() ->[String] {}
    private var titles:[String] = []
    
    /// 显示控制器 重写 func getControllers(viewHeight:CGFloat) ->[UIViewController] {}
    private var controllers:[UIViewController] = []
    
    /// topBar
    private(set) var topBar:DZMTopBar!
    
    /// 滚动view
    private var scrollView:DZMCycleScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 控件想要从00开始需要设置这两个属性
        // 显示状态栏 加上这句可以全部从00开始 设置隐藏显示导航栏全部控件不会移动  不加上 全部视图控件则会根据是否有导航栏自己上下调整位置
        extendedLayoutIncludesOpaqueBars = true
        
        // 有滚动的控件想要00从状态栏开始需要设置该属性为false
        automaticallyAdjustsScrollViewInsets = false
        
        // 添加子控件
        addSubviews()
    }
    
    // MARK: -- 获取Func

    /// 设置titles
    
    /*** 例子
     
     func getTitles() ->[String] {
     
     return ["推荐","专题","类别"]
     }
     
     ***/
    func getTitles() ->[String] {
        
        return []
    }
    
    /// 设置控制器列表
    
    /***  子控制器必须需要实现 这样在viewDidLoad()的时候则会拿到正确的高度进行布局
     
     /// 要实现 (必须) 请继续使用 view.frame.size.height 来获取高度
     var viewHeight:CGFloat?
     
     /// 要实现 (必须)
     override func loadView() {
     
        super.loadView()
     
        if viewHeight != nil {
     
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewHeight!)
        }
     }
     
     // 例子:
     var vc1:TempViewController!
     var vc2:TempViewController!
     var vc3:TempViewController!
     
     func getControllers(viewHeight:CGFloat) ->[UIViewController] {
     
         vc1 = TempViewController()
         vc1.viewHeight = viewHeight
         
         vc2 = TempViewController()
         vc2.viewHeight = viewHeight
         
         vc3 = TempViewController()
         vc3.viewHeight = viewHeight
         
         return [vc1,vc2,vc3]
     } ***/
    
    func getControllers(viewHeight:CGFloat) ->[UIViewController] {
        
        return []
    }

    /// 添加子控件
    func addSubviews() {
        
        titles = getTitles()
        
        creatHeaderBar()
        
        creatScrollView()
        
        controllers =  getControllers(viewHeight: scrollView.frame.size.height)
        
        // 获取view数组
        var views:[UIView] = []
        
        for controller in controllers {
            
            views.append(controller.view)
        }
        
        // 展示
        scrollView.setupViews(views: views)
        
    }
    
    /// 创建HeaderBar
    let itemW:CGFloat = 56
    private func creatHeaderBar() {
        
        // 导航栏
        let topBarY = (navigationController != nil && !navigationController!.isNavigationBarHidden) ? 64 : 0
        topBar = DZMTopBar.topBar(titles:titles)
        topBar.animateDuration = animateDuration
        topBar.initSelectIndex = initSelectIndex
        topBar.delegate = self
        topBar.backgroundColor = UIColor.clear
        
        if showToNavigationBar { // 显示到导航栏上
           
            topBar.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width - 2*itemW), height: 44)
            
            navigationItem.titleView = topBar
            
        }else{
            
            topBar.frame = CGRect(x: 0, y: CGFloat(topBarY), width: UIScreen.main.bounds.size.width, height: topBarHeight)
            view.addSubview(topBar)
        }
    }
    
    /// 创建滚动View
    private func creatScrollView() {
        
        // 滚动view
        let scrollViewY = showToNavigationBar ? ((navigationController != nil && !navigationController!.isNavigationBarHidden) ? 64 : 0) : topBar.frame.maxY
        var scrollViewH = UIScreen.main.bounds.size.height - scrollViewY
        
        // tabBar 是否隐藏了
        scrollViewH = isTabBarHidden ? scrollViewH : (scrollViewH - 48)
        
        // 创建
        scrollView = DZMCycleScrollView()
        scrollView.limitScroll = limitScroll
        scrollView.animateDuration = animateDuration
        scrollView.initSelectIndex = initSelectIndex
        scrollView.delegate = self
        scrollView.openTap = false
        view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: scrollViewY, width: UIScreen.main.bounds.size.width, height: scrollViewH)
    }
    
    
    // MARK: -- DZMTopBarDelegate
    func topBar(topBar: DZMTopBar, clickToIndex index: NSInteger) {
        
        let controller = controllers[index]
        
        if !childViewControllers.contains(controller) { // 不包含该控制器
            
            addChildViewController(controller)
        }
        
        scrollView.scrollIndex(index: index, animated: true)
    }
    
    
    // MARK: -- DZMCycleScrollViewDelegate
    func cycleScrollView(cycleScrollView: DZMCycleScrollView, scrollToIndex index: NSInteger) {
    
        topBar.selectIndex(index: cycleScrollView.currentIndex)
    }
    
    func cycleScrollViewDidScroll(cycleScrollView: DZMCycleScrollView) {
        
        let contentOffsetX = limitScroll ? (cycleScrollView.contentOffset.x - cycleScrollView.frame.width) : cycleScrollView.contentOffset.x
        
        let x = contentOffsetX / (cycleScrollView.frame.width / topBar.buttonW)
        
        topBar.scrollTempViewX(x: x)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
