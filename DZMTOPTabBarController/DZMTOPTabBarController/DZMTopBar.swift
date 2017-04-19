//
//  DZMTopBar.swift
//  DZMTopBar
//
//  Created by 邓泽淼 on 2017/3/13.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

@objc protocol DZMTopBarDelegate:NSObjectProtocol {
    
    /// 点击哪一个index
    @objc optional func topBar(topBar:DZMTopBar,clickToIndex index:NSInteger)
}

class DZMTopBar: UIView {
    
    /// 代理
    weak var delegate:DZMTopBarDelegate?
    
    /// 默认字体
    var nomalFont:UIFont = UIFont.systemFont(ofSize: 16) {
        
        didSet{
            
            for button in buttons {
                
                if !button.isSelected {
                
                    button.titleLabel?.font = nomalFont
                }
            }
        }
    }
    
    /// 选中字体
    var selectFont:UIFont = UIFont.boldSystemFont(ofSize: 18) {
        
        didSet{
            
            for button in buttons {
                
                if button.isSelected {
                    
                    button.titleLabel?.font = nomalFont
                }
            }
        }
    }
    
    /// 默认颜色
    var nomalTextColor:UIColor = UIColor.red {
        
        didSet{
            
            for button in buttons {
                
                button.setTitleColor(nomalTextColor, for: .normal)
            }
        }
    }
    
    /// 选中颜色
    var selectTextColor:UIColor = UIColor.green {
        
        didSet{
            
            for button in buttons {
                
                button.setTitleColor(nomalTextColor, for: .selected)
            }
        }
    }
    
    /// 滚动条背景颜色
    var scrollBarBGColor:UIColor = UIColor.green {
        
        didSet{
            
            scrollBar.backgroundColor = scrollBarBGColor
        }
    }
    
    /// 滚动条底部间距
    var scrollBarBottomSpace:CGFloat = 1 {
        
        didSet{
            
            setNeedsLayout()
        }
    }
    
    /// 初始化选中
    var initSelectIndex:NSInteger = 0
    
    /// 动画时间
    var animateDuration:TimeInterval = 0.2
    
    /// 按钮宽度
    var buttonW:CGFloat = 0
    
    /// 滑动view
    private var scrollBar:UIView!
    
    /// 滑动viewH
    private var scrollBarH:CGFloat = 2
    
    /// 按钮数组
    private var buttons:[UIButton] = []
    
    /// 标题数组
    private var titles:[String] = []
    
    /// 记录按钮
    private var selectButton:UIButton?
    
    /// 初始化方法
    init(titles:[String]) {
        
        super.init(frame: CGRect.zero)
        
        creatUI(titles: titles)
        
        layer.masksToBounds = true
    }
    
    /// 选中按钮
    func selectIndex(index:NSInteger) {
        
        selectButton(button: buttons[index])
    }
    
    /// 滚动到指定索引
    func scrollTempViewX(x:CGFloat) {
        
        scrollBar.frame.origin = CGPoint(x:x,y:scrollBar.frame.origin.y)
    }
    
    /// 更新titles
    func updateTitles(titles:[String]) {
        
        for i in 0..<titles.count {
            
            updateTitle(title: titles[i], index: i)
        }
    }
    
    /// 指定更新title
    func updateTitle(title:String,index:NSInteger) {
        
        let button:UIButton = buttons[index]
        
        button.setTitle(title, for: .normal)
        
        button.setTitle(title, for: .selected)
    }
    
    
    /// 创建UI
    private func creatUI(titles:[String]) {
        
        // 记录
        self.titles = titles
        
        // 按钮
        for i in 0..<titles.count {
            
            let title = titles[i]
            let button = UIButton(type:.custom)
            button.tag = i
            button.titleLabel?.font = nomalFont
            button.setTitle(title, for: .normal)
            button.setTitle(title, for: .selected)
            button.setTitleColor(nomalTextColor, for: .normal)
            button.setTitleColor(selectTextColor, for: .selected)
            button.addTarget(self, action: #selector(DZMTopBar.clickButton(button:)), for: .touchUpInside)
            addSubview(button)
            buttons.append(button)
        }
        
        // 滚动view
        scrollBar = UIView()
        scrollBar.backgroundColor = scrollBarBGColor
        addSubview(scrollBar)
    }
    
    /// 滚动到指定索引
    private func scrollIndex(index:NSInteger) {
        
        let count = buttons.count
        
        let h:CGFloat = frame.size.height
        
        let scrollBarH:CGFloat = self.scrollBarH
        
        let scrollBarBottomSpace:CGFloat = self.scrollBarBottomSpace
        
        let scrollBarW:CGFloat = frame.size.width / CGFloat(count)
        
        UIView.animate(withDuration: animateDuration) { [weak self] ()->Void in
            
            self?.scrollBar.frame = CGRect(x: CGFloat(index) * scrollBarW, y: h - scrollBarH - scrollBarBottomSpace, width: scrollBarW, height: scrollBarH)
        }
    }
    
    /// 点击按钮
    @objc private func clickButton(button:UIButton) {
        
        selectButton(button: button)
        
        scrollIndex(index: button.tag)
        
        delegate?.topBar?(topBar: self, clickToIndex: button.tag)
    }
    
    /// 选中按钮
    private func selectButton(button:UIButton) {
        
        if selectButton == button {return}
        
        selectButton?.isSelected = false
        
        selectButton?.titleLabel?.font = nomalFont
        
        button.isSelected = true
        
        button.titleLabel?.font = selectFont
        
        selectButton = button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = buttons.count
        
        buttonW = frame.size.width / CGFloat(count)
        
        for i in 0..<count {
            
            let button = buttons[i]
            
            button.frame = CGRect(x: CGFloat(i) * buttonW , y: 0, width: buttonW, height: frame.size.height)
        }
        
        scrollBar.frame = CGRect(x: CGFloat(initSelectIndex) * buttonW, y: frame.size.height - scrollBarH - scrollBarBottomSpace, width: buttonW, height: scrollBarH)
        
        clickButton(button: buttons[initSelectIndex])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
