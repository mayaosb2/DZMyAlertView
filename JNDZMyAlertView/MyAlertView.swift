//
//  MyAlertView.swift
//  alterview
//
//  Created by 马耀 on 16/8/15.
//  Copyright © 2016年 mayao. All rights reserved.
//
/**
增添方式，1.在MyAlertContentViewType枚举增加枚举
2.在MyAlertContentView里面根据枚举写新的弹窗
3.在MyAlertView的延展里面写计算弹框高度的方法
*/
import UIKit
import SnapKit
import MySwiftExtensions
import JNDZTELDTOOL

/**
 提示框类型的枚举
 
 - blackViewAndClickNotToDisappear: 黑框 点击不消失
 - blackViewAndClickDisappear:      黑框 点击消失
 - whiteViewAndClickNotToDisappear: 白框 点击不消失
 */
enum MyAlertViewType {
    case blackViewAndClickNotToDisappear
    case blackViewAndClickDisappear
    case whiteViewAndClickNotToDisappear
}

/**
 提示框内容的枚举
 
 - Warning:  提醒 黑框
 - collection: 收藏 黑框
 - bulb:  灯泡 黑框
 - wait:  等待 黑框
 - Common:  自定义白框
 - callPhone:  打电话
 - immediatelyUseTheCar: 立即用车 押金足够 不需要设置message
 - immediatelyUseTheCarNotDeposit: 立即用车 押金足够 不需要设置message
 - returnTheCar:  还车 不需要设置message
 - returnTheCarEr:  二维码还车 不需要设置message
 - openBlue:  打开蓝牙 不需要设置message
 */
enum MyAlertContentViewType{
    case warning
    case collection
    case bulb
    case wait
    case Common
    case callPhone
    case immediatelyUseTheCar
    case immediatelyUseTheCarNotDeposit
    case returnTheCar
    case returnTheCarEr
    case openBlue
}

/// 提示框
class MyAlertView: UIWindow {
    
    /// 具体显示内容的View
    var contentView:MyAlertContentView?
    /// 背景的透明View
    var coverView:UIView?
    /// 单例
    static let sharedInstance = MyAlertView(frame: CGRectZero)
    /// 定时器 隐藏功能
    private var hidenTimer:NSTimer?
    /// 弹框类型
    private var type:MyAlertViewType?
    
    private override init(frame: CGRect) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.clearColor()
        self.windowLevel = UIWindowLevelStatusBar
        self.hidden = true
        coverView = UIView()
        coverView?.frame = UIScreen.mainScreen().bounds
        coverView?.backgroundColor = UIColor.blackColor()
        coverView?.alpha = 0.3
        coverView?.hidden = true
        self.addSubview(coverView!)
    }
    
    /**
     设置提示框类型
     
     - parameter type:        提示框的类型
     - parameter contentType: 提示内容的类型
     - parameter message: 提示信息
     */
    private func setMyAlertViewType(type:MyAlertViewType,contentType:MyAlertContentViewType,message:[String]) -> Bool{
        if (self.type != nil && (self.type == .blackViewAndClickNotToDisappear || self.type == .whiteViewAndClickNotToDisappear)){
            
            return  false
        }
        //检验通过 应该重置任何属性
        self.hiden()
        self.coverView!.hidden = false
        self.type = type
        if "\(type)".containsString("black") {
            contentView = MyAlertContentBlackView(frame: CGRectZero, contentType: contentType,message: message)
        }else if "\(type)".containsString("white"){
            contentView = MyAlertContentWhiteView(frame: CGRectZero, contentType: contentType,message: message)
        }
        self.addSubview(contentView!)
        let size = calculationSizeSelf(type, contentType: contentType, message: message)
        contentView!.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
        handleTimerAndTap(type, contentType: contentType)
        
        return true
    }
    
    /**
     处理定时事件或点击事件
     
     - parameter type: 弹框类型
     */
    private func handleTimerAndTap(type:MyAlertViewType,contentType:MyAlertContentViewType){
        //点击覆盖层是否会消失
        if type == .blackViewAndClickDisappear || contentType == .openBlue{
            coverView?.userInteractionEnabled = true
            coverView?.tapActionsGesture({[weak self] () -> Void in
                if self != nil{
                    self?.hiden()
                }
                })
            contentView?.tapActionsGesture({[weak self] () -> Void in
                if self != nil{
                    self?.hiden()
                }
                })
        }else {
            
            coverView?.userInteractionEnabled = false
        }
        //自定义时间隐藏
        if type == .blackViewAndClickDisappear && hidenTimer == nil {
            setDurationTime(3)
        }else if((contentType == .immediatelyUseTheCarNotDeposit || contentType == .immediatelyUseTheCar) && hidenTimer == nil){
            setDurationTime(Double(CGFloat.max))
        }else if("\(type)".containsString("white") && hidenTimer == nil){
            setDurationTime(10)
        }
    }
    
    /**
     设置自动隐藏时间 如果想设置为不隐藏 设置为 Double(CGFloat.max)
     
     - parameter second: 多长时间后自动隐藏
     */
    func setDurationTime(second:NSTimeInterval){
        hidenTimer = NSTimer.scheduledTimerWithTimeInterval(second, target: self, selector: "hiden", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(hidenTimer!, forMode: NSRunLoopCommonModes)
    }
    
    /**
     显示 使用 默认隐藏时间
     
     - parameter type:        提示框的类型
     - parameter contentType: 提示内容的类型
     - parameter message: 提示信息
     */
    func show(type:MyAlertViewType,contentType:MyAlertContentViewType,message:[String]){
        if setMyAlertViewType(type, contentType: contentType,message: message) {
            assert(contentView != nil, "没有设置具体显示什么类型的提示框")
            self.makeKeyWindow()
            self.hidden = false
        }
    }
    
    /**
     显示提醒框 白色调用此方法
     
     - parameter contentType:  内容视图的类型
     - parameter message:      展示信息
     - parameter cancelAction: 左边按钮的点击事件
     - parameter othersAction: 其他按钮的点击事件
     */
    func show(contentType:MyAlertContentViewType,message:[String],cancelAction:()->(),othersAction:()->()...){
        if setMyAlertViewType(.whiteViewAndClickNotToDisappear, contentType: contentType,message: message) {
            assert(contentView != nil, "没有设置具体显示什么类型的提示框")
            self.makeKeyWindow()
            self.hidden = false
        }
        contentView?.cancelBtn?.tapActionsGesture({[weak self] () -> Void in
            self?.hiden()
            cancelAction()
            })
        contentView?.sureBtn?.tapActionsGesture({[weak self] () -> Void in
            self?.hiden()
            othersAction[0]()
            })
        contentView?.otherBtn?.tapActionsGesture({[weak self] () -> Void in
            self?.hiden()
            othersAction[1]()
            })
    }
    
    
    /**
     隐藏 强制性隐藏 隐藏所有类型的弹窗
     */
    func hiden(){
        baseHidden()
    }
    
    /**
     隐藏 非强制性隐藏 只隐藏点击消失的这种
     */
    private func hidden(){
        if type == .blackViewAndClickDisappear {
            baseHidden()
        }
    }
    
    private func baseHidden(){
        self.resignKeyWindow()
        self.hidden = true
        self.type = nil
        self.coverView!.hidden = true
        contentView?.removeFromSuperview()
        contentView = nil
        hidenTimer?.invalidate()
        hidenTimer = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 计算黑白框的大小
private extension MyAlertView {
    
    /**
     计算大小
     
     - parameter type: 黑白框
     - parameter contentType: 内容视图内容
     - parameter message: 内容
     
     - returns: Size
     */
    private func calculationSizeSelf(type:MyAlertViewType,contentType:MyAlertContentViewType,message:[String]) ->CGSize{
        if "\(type)".containsString("black") {
            
            return calculationBlackSize(message)
        }else{
            switch contentType {
                
            case .immediatelyUseTheCar : return calculationImmediatelySize(message)
            case .returnTheCar : return calculationReturnTheCarSize(message)
            case .returnTheCarEr : return calculationReturnTheCarErSize(message)
            case .Common : return calculationCommonSize(message)
            case .callPhone : return calculationCallPhoneSize(message)
            case .immediatelyUseTheCarNotDeposit : return calculationImmediatelyUseTheCarNotDepositSize(message)
            case .openBlue : return calculationOpenBlueSize()

            default :
                return CGSizeMake(0, 0)
            }
            
        }
    }
    
    /**
     计算打开蓝牙的大小
     
     - returns:
     */
    private func calculationOpenBlueSize()->CGSize{
    
        return CGSizeMake(MyAlertContentWhiteViewWidth ,MyAlertContentWhiteViewWidth / 437 * 250)
    }
    
    /**
     计算押金不足的用车弹框
     
     - parameter message:
     
     - returns:
     */
    private func calculationImmediatelyUseTheCarNotDepositSize(message:[String])->CGSize{
    
        let imageHeight = (k_Width - 150) / 5 * 2.5
        // 上部文字的高
        let heighTop = ("系统将为您预留\(GLOBAL_TIMEOUT_SECONDS/60)分钟找车时间，您可以通过导航、鸣笛、双闪找到车辆。" as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifont!], context: nil).height
        // 下部文字的高
        let heighBottom = ("1.若在用车中未造成任何经济损失（如违章罚款和事故车损等情况），可联系客服申请退换租车押金。\n2.在支付1次押金后未进行申请退款操作，租车押金可重复使用。" as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifontsma!], context: nil).height

        return CGSizeMake(MyAlertContentWhiteViewWidth,205 + imageHeight + heighBottom + heighTop)
    }

    /**
     计算打电话白框的大小 带标题和副标题
     
     - parameter message: 信息
     
     - returns: 尺寸
     */
    private func calculationCallPhoneSize(message:[String])->CGSize{
        
        let height = (message[0] as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifontmorebig2New!], context: nil).height
        
        let heightSub = (message[1] as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifont!], context: nil).height
        // 70 为别的控件高度
        return CGSizeMake(MyAlertContentWhiteViewWidth, height + heightSub + 113)
    }
    
    
    /**
     计算自定义白框的大小
     
     - parameter message: 信息
     
     - returns: 尺寸
     */
    private func calculationCommonSize(message:[String])->CGSize{
        
        let height = (message[0] as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifontmorebig2New!], context: nil).height
        // 70 为别的控件高度
        return CGSizeMake(MyAlertContentWhiteViewWidth, height + 103)
    }
    
    /**
     计算直接还车的白框大小
     
     - parameter message: 内容
     
     - returns: Size
     */
    private func calculationReturnTheCarSize(message:[String])->CGSize{
        
        return calculationBaseReturnCarSize(["车辆停到指定的网点并插上充电枪，否则将收取相应调度费。"])
    }
    
    /**
     计算二维码还车的白框大小
     
     - parameter message: 内容
     
     - returns: Size
     */
    private func calculationReturnTheCarErSize(message:[String])->CGSize{
        
        return calculationBaseReturnCarSize(["车辆停到指定的网点并插上充电枪，否则将收取相应调度费，插上充电枪后，扫描充电终端上的二维码"])
    }
    
    /**
     计算还车白框的基类
     
     - parameter message: 内容
     
     - returns: size
     */
    private func calculationBaseReturnCarSize(message:[String])->CGSize{
        
        let height = (message[0] as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifont!], context: nil).height
        let imageWidth = (MyAlertContentWhiteViewWidth - 80) / 2
        // 225  * 176 的比例 因为给的图片比例就是这样的 * 2 是两张
        let imageHeight = (imageWidth / 225 * 176)
        // 经测试全部为 391  则别的地方为365.4 6S
        return CGSizeMake(MyAlertContentWhiteViewWidth, height + 365.4 + (-91.91 + imageHeight) * 2)
        
    }
    
    /**
    计算立即用车的白框大小
    
    - parameter message: 内容
    
    - returns: Size
    */
    private func calculationImmediatelySize(message:[String])->CGSize{
        
        return calculationBaseSize(["系统将为您预留\(GLOBAL_TIMEOUT_SECONDS/60)分钟找车时间，您可以通过导航、鸣笛、双闪找到车辆。","您的可用余额为\(PersonInstance.shareInstance.balanceCanUse.toDouble.analyzingString(".2f").stringFormatterCurrency())元"])
    }
    
    
    /**
     计算立即用车的白框大小 基类
     
     - parameter message: 内容
     
     - returns: Size
     */
    private func calculationBaseSize(message:[String])->CGSize{
        
        // 上部文字的高
        let heighTop = (message[0] as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifont!], context: nil).height
        // 下部文字的高
        let heighCenter = (message[1] as NSString).boundingRectWithSize(CGSizeMake(MyAlertContentWhiteViewWidth - 40, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:_globaluifont!], context: nil).height
        
        let imageHeight = (k_Width - 150) / 5 * 3
        let height:CGFloat = 10 + imageHeight + 10 + heighTop + 5 + imageHeight + 5 + heighCenter + 10 + GLOBAL_BUTTON_HEIGHT + 35
        return CGSizeMake(MyAlertContentWhiteViewWidth, height)
    }
    
    
    /**
     计算黑框大小 宽有最低宽度 高度随文字自定义
     
     - parameter message: 内容
     
     - returns: Size
     */
    private func calculationBlackSize(message:[String])->CGSize{
        guard let title = message.first else{
            assert(false, "计算黑框大小，未设置显示文字内容")
            return CGSizeZero
        }
        // 宽
        var width = (title as NSString).boundingRectWithSize(CGSize(), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 18)!], context: nil).width
        width = (width <= contentView!.black_MinWidth ? contentView!.black_MinWidth : width)//最小
        width = (width >= contentView!.black_MaxWidth ? contentView!.black_MaxWidth : width)//最大
        // 高
        let height = (title as NSString).boundingRectWithSize(CGSizeMake(width, k_Height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 18)!], context: nil).height
        
        return CGSizeMake(width + 40, height + contentView!.black_ImageWidthAndHeight + contentView!.black_ImageTop + contentView!.black_ImageBottom + contentView!.black_LabelBottom)
    }
    
    
}
