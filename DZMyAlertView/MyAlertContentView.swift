//
//  MyAlertContentView.swift
//  alterview
//
//  Created by 马耀 on 16/8/15.
//  Copyright © 2016年 mayao. All rights reserved.
//

import UIKit
import JNDZTELDTOOL
import MySwiftExtensions

/// 提示框内容视图基类
class MyAlertContentView: UIView {
    
    //MARK:黑框相关变量
    /// 最大宽度
    let black_MaxWidth:CGFloat = UIScreen.mainScreen().bounds.width * 0.8
    /// 最小宽度
    let black_MinWidth:CGFloat = 130
    /// 图片大小
    let black_ImageWidthAndHeight:CGFloat = 40
    /// 图片距离上边
    let black_ImageTop:CGFloat = 15
    /// 图片距离label
    let black_ImageBottom:CGFloat = 20
    /// label距离下边
    let black_LabelBottom:CGFloat = 15
    
    //MARK:白框相关变量
    /// 左边的按钮 一般为取消按钮
    var cancelBtn:UIButton?
    /// 右边的按钮 一般为确定按钮
    var sureBtn:UIButton?
    /// 其他按钮  立即用车时候有使用
    var otherBtn:UIButton?
    
    /**
     初始化
     
     - parameter frame:       frame
     - parameter contentType: 内容视图类型
     - parameter message:     信息
     
     - returns: self
     */
    init(frame: CGRect,contentType:MyAlertContentViewType,message:[String]) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 提示框内容视图黑框
class MyAlertContentBlackView: MyAlertContentView {

    override init(frame: CGRect,contentType:MyAlertContentViewType,message:[String]) {
        super.init(frame: frame, contentType: contentType, message: message)
        
        createBlackView(contentType,message: message)
    }
    
    /**
     创建黑框
     
     - parameter contentType: 内容样式
     */
    func createBlackView(contentType:MyAlertContentViewType,message:[String]){
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.8
        createTopImageView(contentType)

        let subTitleLabel = UILabel(frame: CGRectZero)
        subTitleLabel.textColor = UIColor.whiteColor()
        subTitleLabel.textAlignment = .Center
        subTitleLabel.text = message.first
        subTitleLabel.numberOfLines = 0
        self.addSubview(subTitleLabel)
        subTitleLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        subTitleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(65)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }
    
    /**
     创建头部图片
     */
    func createTopImageView(contentType:MyAlertContentViewType){
        if contentType == .wait{
            let wait = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            wait.alpha = 0.8
            self.addSubview(wait)
            wait.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(black_ImageTop)
                make.width.equalTo(black_ImageWidthAndHeight)
                make.height.equalTo(black_ImageWidthAndHeight)
                make.centerX.equalTo(0)
            }
            wait.startAnimating()
            
            return
        }
        
        var imageName = ""
        switch contentType {
        case .bulb : imageName = "fszc_alertview_bulb"
             break
        case .warning : imageName = "fszc_alertview_tishi"
            break
        case .collection : imageName = "fszc_alertview_collectionWhiteEdge"
            break
            default :
                assert(false, "黑框里面没有这个枚举！")
            break
        }
        
        let imageView = UIImageView(image: BaseImage(named: imageName)?.image)
        imageView.backgroundColor = UIColor.blackColor()
        self.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(black_ImageTop)
            make.width.equalTo(black_ImageWidthAndHeight)
            make.height.equalTo(black_ImageWidthAndHeight)
            make.centerX.equalTo(0)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 提示框 白框的宽度
let MyAlertContentWhiteViewWidth:CGFloat = k_Width - 60
/// 提示框内容视图白框
class MyAlertContentWhiteView: MyAlertContentView {
/// 信用卡／支付宝／微信支付 按钮
    let creditPay = UIButton()
    let aliPay = UIButton()
    let wxPay = UIButton()
    override init(frame: CGRect,contentType:MyAlertContentViewType,message:[String]) {
        super.init(frame: frame, contentType: contentType, message: message)
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.whiteColor()
        //判断创建什么样的视图
        switch contentType {
        case .immediatelyUseTheCar : createImmediatelyUseTheCar(contentType)
            break
        case .returnTheCar : createReturnTheCarUseTheCar(contentType)
            break
        case .returnTheCarEr : createReturnTheCarErUseTheCar(contentType)
            break
        case .Common : createCommonAlterView(message)
            break
        case .callPhone : createCallPhoneAlterView(message)
            break
        case .immediatelyUseTheCarNotDeposit : createImmediatelyUseTheCarNotDeposit(message)
            break
        case .openBlue : createOpenBlue()
        break
            
        default :
            assert(false, "白框里面没有这个枚举！")
            break
        }
    }
    
    /**
     创建打电话白框 带标题和副标题
     
     - parameter message: 信息
     */
    func createCallPhoneAlterView(message:[String]){
        //提示两个字
        let promptLabel = UILabel(frame: CGRectZero)
        promptLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .Center
        promptLabel.text = "提示"
        self.addSubview(promptLabel)
        promptLabel.font = _globaluifontmorebig3
        promptLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(13)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        //文字
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.text = message[0]
        self.addSubview(titleLabel)
        titleLabel.font = _globaluifontmorebig2New
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(promptLabel.snp_bottom).offset(3)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //副标题文字
        let titleSubLabel = UILabel(frame: CGRectZero)
        titleSubLabel.textColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        titleSubLabel.numberOfLines = 0
        titleSubLabel.textAlignment = .Center
        titleSubLabel.text = message[1]
        self.addSubview(titleSubLabel)
        titleSubLabel.font = _globaluifontmorebig
        titleSubLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //左按钮
        cancelBtn = UIButton()
        cancelBtn!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelBtn!.layer.masksToBounds = true
        cancelBtn!.setTitle(message[2], forState: UIControlState.Normal)
        self.addSubview(cancelBtn!)
        cancelBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleSubLabel.snp_bottom).offset(13)
            make.left.equalTo(0)
            make.right.equalTo(self.snp_centerX)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //右按钮
        sureBtn = UIButton()
        sureBtn!.setTitleColor(GLOBAL_MASTER_COLOR, forState: UIControlState.Normal)
        sureBtn!.setTitle(message[3], forState: UIControlState.Normal)
        self.addSubview(sureBtn!)
        sureBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleSubLabel.snp_bottom).offset(10)
            make.left.equalTo(self.snp_centerX)
            make.right.equalTo(0)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //横线
        let lineTransverse = UIView()
        lineTransverse.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineTransverse.alpha = 0.5
        self.addSubview(lineTransverse)
        lineTransverse.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cancelBtn!.snp_top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //竖线
        let lineVertical = UIView()
        lineVertical.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineVertical.alpha = 0.5
        self.addSubview(lineVertical)
        lineVertical.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.centerX.equalTo(0)
            make.top.equalTo(lineTransverse.snp_top)
            make.width.equalTo(0.5)
        }
    }

    
    /**
     创建普通白框
     
     - parameter message: 信息
     */
    func createCommonAlterView(message:[String]){
        //提示两个字
        let promptLabel = UILabel(frame: CGRectZero)
        promptLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .Center
        promptLabel.text = "提示"
        self.addSubview(promptLabel)
        promptLabel.font = _globaluifontmorebig3
        promptLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(13)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        //文字
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        titleLabel.numberOfLines = 0
        titleLabel.text = message[0]
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        titleLabel.font = _globaluifontmorebig2New
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(promptLabel.snp_bottom).offset(3)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //左按钮
        cancelBtn = UIButton()
        cancelBtn!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelBtn!.layer.masksToBounds = true
        cancelBtn!.setTitle(message[1], forState: UIControlState.Normal)
        self.addSubview(cancelBtn!)
        cancelBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(self.snp_centerX)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //右按钮
        sureBtn = UIButton()
        sureBtn!.setTitleColor(GLOBAL_MASTER_COLOR, forState: UIControlState.Normal)
        sureBtn!.setTitle(message[2], forState: UIControlState.Normal)
        self.addSubview(sureBtn!)
        sureBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.left.equalTo(self.snp_centerX)
            make.right.equalTo(0)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //横线
        let lineTransverse = UIView()
        lineTransverse.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineTransverse.alpha = 0.5
        self.addSubview(lineTransverse)
        lineTransverse.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cancelBtn!.snp_top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //竖线
        let lineVertical = UIView()
        lineVertical.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineVertical.alpha = 0.5
        self.addSubview(lineVertical)
        lineVertical.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.centerX.equalTo(0)
            make.top.equalTo(lineTransverse.snp_top)
            make.width.equalTo(0.5)
        }
    }
    
    /**
     二维码还车
     
     - parameter contentType: 类型
     */
    func createReturnTheCarErUseTheCar(contentType:MyAlertContentViewType){
       createBaseReturnTheCar(MyAlertContentViewType.returnTheCarEr, message: ["fszc_alertview_CarryingArticles.png","fszc_alertview_CloseWindow.png","携带随身物品","关车窗","fszc_alertview_CloseDoor.png","fszc_alertview_PlugInChargingGun.png","关车门","插上充电枪","车辆停到指定的网点并插上充电枪，否则将收取相应调度费，插上充电枪后，扫描充电终端上的二维码","取消","扫码还车"])
    }
    
    /**
     直接还车
     
     - parameter contentType: 类型
     */
    func createReturnTheCarUseTheCar(contentType:MyAlertContentViewType){
        createBaseReturnTheCar(MyAlertContentViewType.returnTheCarEr, message: ["fszc_alertview_CarryingArticles.png","fszc_alertview_CloseWindow.png","携带随身物品","关车窗","fszc_alertview_CloseDoor.png","fszc_alertview_PlugInChargingGun.png","关车门","插上充电枪","车辆停到指定的网点并插上充电枪，否则将收取相应调度费","取消","还车"])
    }
    
    /**
     新设计还车的基类
     
     - parameter contentType: 类型
     - parameter message:     信息
     */
    func createBaseReturnTheCar(contentType:MyAlertContentViewType,message:[String]){
        // 80 为 左边 20 右边 20 两个图片之间 40
        let imageWidth = (MyAlertContentWhiteViewWidth - 80) / 2
        // 225  * 176 的比例 因为给的图片比例就是这样的
        let imageHeight = imageWidth / 225 * 176
        // 图片
        let leftTopImage = BaseImage(named: message[0])?.image
        let rightTopImage = BaseImage(named: message[1])?.image
        let leftBottomImage = BaseImage(named: message[4])?.image
        let rightBottomImage = BaseImage(named: message[5])?.image
        
        //顶部image 左
        let leftTopImageView = UIImageView(image: leftTopImage)
        self.addSubview(leftTopImageView)
        leftTopImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.left.equalTo(20)
            make.top.equalTo(20)
        }
        
        //顶部image 右
        let rightTopImageView = UIImageView(image: rightTopImage)
        self.addSubview(rightTopImageView)
        rightTopImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.right.equalTo(-20)
            make.top.equalTo(20)
        }
        
        //顶部文字 左
        let leftTopLabel = UILabel(frame: CGRectZero)
        leftTopLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        leftTopLabel.numberOfLines = 0
        leftTopLabel.textAlignment = .Center
        leftTopLabel.text = message[2]
        self.addSubview(leftTopLabel)
        leftTopLabel.font = _globaluifont1
        leftTopLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(leftTopImageView.snp_bottom).offset(10)
            make.left.equalTo(leftTopImageView.snp_left)
            make.right.equalTo(leftTopImageView.snp_right)
        }

        //顶部文字 右
        let rightTopLabel = UILabel(frame: CGRectZero)
        rightTopLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        rightTopLabel.numberOfLines = 0
        rightTopLabel.textAlignment = .Center
        rightTopLabel.text = message[3]
        self.addSubview(rightTopLabel)
        rightTopLabel.font = _globaluifont1
        rightTopLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(leftTopLabel.snp_top)
            make.left.equalTo(rightTopImageView.snp_left)
            make.right.equalTo(rightTopImageView.snp_right)
        }
        
        //中部image 左
        let leftBottomImageView = UIImageView(image: leftBottomImage)
        self.addSubview(leftBottomImageView)
        leftBottomImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.left.equalTo(20)
            //此处用左边的label 的下边 因为左边的文字比右边多
            make.top.equalTo(leftTopLabel.snp_bottom).offset(40)
        }
        
        //中部image 右
        let rightBottomImageView = UIImageView(image: rightBottomImage)
        self.addSubview(rightBottomImageView)
        rightBottomImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.right.equalTo(-20)
            make.top.equalTo(leftBottomImageView.snp_top)
        }
        
        //中部文字 左
        let leftBottomLabel = UILabel(frame: CGRectZero)
        leftBottomLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        leftBottomLabel.numberOfLines = 0
        leftBottomLabel.textAlignment = .Center
        leftBottomLabel.text = message[6]
        self.addSubview(leftBottomLabel)
        leftBottomLabel.font = _globaluifont1
        leftBottomLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(leftBottomImageView.snp_bottom).offset(10)
            make.left.equalTo(leftBottomImageView.snp_left)
            make.right.equalTo(leftBottomImageView.snp_right)
        }
        
        //中部文字 右
        let rightBottomLabel = UILabel(frame: CGRectZero)
        rightBottomLabel.textColor = GLOBAL_MASTER_BLACKCOLOR
        rightBottomLabel.numberOfLines = 0
        rightBottomLabel.textAlignment = .Center
        rightBottomLabel.text = message[7]
        self.addSubview(rightBottomLabel)
        rightBottomLabel.font = _globaluifont1
        rightBottomLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(rightBottomImageView.snp_bottom).offset(10)
            make.left.equalTo(rightBottomImageView.snp_left)
            make.right.equalTo(rightBottomImageView.snp_right)
        }
        
        //底部文字
        let bottomLabel = UILabel(frame: CGRectZero)
        bottomLabel.textColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .Left
        bottomLabel.text = message[8]
        self.addSubview(bottomLabel)
        bottomLabel.font = _globaluifont
        bottomLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(rightBottomLabel.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //左按钮
        cancelBtn = UIButton()
        cancelBtn!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelBtn!.layer.masksToBounds = true
        cancelBtn!.setTitle(message[9], forState: UIControlState.Normal)
        self.addSubview(cancelBtn!)
        cancelBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomLabel.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(self.snp_centerX)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //右按钮
        sureBtn = UIButton()
        sureBtn!.setTitleColor(GLOBAL_MASTER_COLOR, forState: UIControlState.Normal)
        sureBtn!.setTitle(message[10], forState: UIControlState.Normal)
        self.addSubview(sureBtn!)
        sureBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomLabel.snp_bottom).offset(10)
            make.left.equalTo(self.snp_centerX)
            make.right.equalTo(0)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //横线
        let lineTransverse = UIView()
        lineTransverse.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineTransverse.alpha = 0.5
        self.addSubview(lineTransverse)
        lineTransverse.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cancelBtn!.snp_top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //竖线
        let lineVertical = UIView()
        lineVertical.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineVertical.alpha = 0.5
        self.addSubview(lineVertical)
        lineVertical.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.centerX.equalTo(0)
            make.top.equalTo(sureBtn!.snp_top)
            make.width.equalTo(0.5)
        }
        
        //十字横线
        let lineTransverseCross = UIView()
        lineTransverseCross.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineTransverseCross.alpha = 0.5
        self.addSubview(lineTransverseCross)
        lineTransverseCross.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(leftTopLabel.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(0.5)
        }
        
        //十字竖线
        let lineVerticalCross = UIView()
        lineVerticalCross.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineVerticalCross.alpha = 0.5
        self.addSubview(lineVerticalCross)
        lineVerticalCross.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(rightBottomLabel.snp_bottom)
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(20)
            make.width.equalTo(0.5)
        }

    }
    
    /**
     打开蓝牙
     */
    func createOpenBlue(){
        let topImageView = UIImageView(image: BaseImage(named: "fszc_alertview_openBlue")?.image)
        self.addSubview(topImageView)
        topImageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        }
        topImageView.userInteractionEnabled = true
        topImageView.tapActionsGesture { () -> Void in
            MyAlertView.sharedInstance.hiden()
        }
    }
    
    /**
     创建押金不足的立即用车弹框
     
     - parameter message: 信息
     */
    func createImmediatelyUseTheCarNotDeposit(message:[String]){
        let topImage = BaseImage(named: "fszc_alertview_useCar")?.image
        let imageWidth = k_Width - 150
        let imageHeight = (k_Width - 150) / 5 * 2.5
        
        //顶部image
        let topImageView = UIImageView(image: topImage)
        self.addSubview(topImageView)
        topImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(8)
        }
        
        //顶部文字
        let titleLabelTop = UILabel(frame: CGRectZero)
        titleLabelTop.textColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        titleLabelTop.attributedText = returnRestTimeOfCar()
        titleLabelTop.numberOfLines = 0
        self.addSubview(titleLabelTop)
        titleLabelTop.font = _globaluifont
        titleLabelTop.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topImageView.snp_bottom).offset(14)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        // 租车押金
        let depositLabel = UILabel(frame: CGRectZero)
        depositLabel.attributedText = returnDepositOfCar()
        depositLabel.numberOfLines = 0
        self.addSubview(depositLabel)
        depositLabel.font = _globaluifont
        depositLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabelTop.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        // 需要支付的租车押金
        let depositNeedLabel = UILabel(frame: CGRectZero)
        depositNeedLabel.attributedText = returnNeedDepositOfCar()
        depositNeedLabel.numberOfLines = 0
        self.addSubview(depositNeedLabel)
        depositNeedLabel.font = _globaluifont
        depositNeedLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(depositLabel.snp_bottom).offset(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }

        // 点击选择支付方式
        let clickToSelectLabel = UILabel(frame: CGRectZero)
        clickToSelectLabel.numberOfLines = 0
        clickToSelectLabel.textColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        clickToSelectLabel.text = "点击选择支付方式"
        self.addSubview(clickToSelectLabel)
        clickToSelectLabel.font = _globaluifontsmall
        clickToSelectLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(depositNeedLabel.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //上部横线
        let lineTop = UIView()
        lineTop.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineTop.alpha = 0.5
        self.addSubview(lineTop)
        lineTop.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(clickToSelectLabel.snp_bottom).offset(7)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(0.5)
        }
        
        //支付宝
        aliPay.setImage(BaseImage(named: "fszc_alertview_aliPayUnSelect")?.image, forState: UIControlState.Normal)
        self.addSubview(aliPay)
        aliPay.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(lineTop.snp_bottom).offset(5)
            make.left.equalTo(20)
            make.height.equalTo(32)
            make.width.equalTo(25)
        }
        aliPay.tag = 100
        aliPay.addTarget(self, action: "selectPayType:", forControlEvents: UIControlEvents.TouchUpInside)
        aliPay.setTitle("支付宝", forState: UIControlState.Normal)
        aliPay.titleLabel?.font = _globaluifontsmall
        aliPay.setTitleColor(GLOBAL_MASTER_LIGHTGRAYCOLOR, forState: .Normal)
        aliPay.setVerticalLabelBottom(1)
        
        //微信
        wxPay.setImage(BaseImage(named: "fszc_personalcenter_wxLogo")?.image, forState: UIControlState.Normal)
        self.addSubview(wxPay)
        wxPay.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(lineTop.snp_bottom).offset(5)
            make.left.equalTo(aliPay.snp_right).offset(10)
            make.height.equalTo(32)
            make.width.equalTo(25)
        }
        wxPay.tag = 200
        wxPay.addTarget(self, action: "selectPayType:", forControlEvents: UIControlEvents.TouchUpInside)
        wxPay.setTitle("微信", forState: UIControlState.Normal)
        wxPay.titleLabel?.font = _globaluifontsmall
        wxPay.setTitleColor(GLOBAL_MASTER_LIGHTGRAYCOLOR, forState: .Normal)
        wxPay.setVerticalLabelBottom(1)

        if GLOBAL_CREDIT_FUNCTION == 0 {
            //信用卡
            creditPay.setImage(BaseImage(named: "fszc_personalcenter_creditCardLogo")?.image, forState: UIControlState.Normal)
            self.addSubview(creditPay)
            creditPay.tag = 300
            creditPay.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(lineTop.snp_bottom).offset(5)
                make.left.equalTo(wxPay.snp_right).offset(10)
                make.height.equalTo(32)
                make.width.equalTo(25)
            }
            creditPay.addTarget(self, action: "selectPayType:", forControlEvents: UIControlEvents.TouchUpInside)
            creditPay.setTitle("信用卡", forState: UIControlState.Normal)
            creditPay.titleLabel?.font = _globaluifontsmall
            creditPay.setTitleColor(GLOBAL_MASTER_LIGHTGRAYCOLOR, forState: .Normal)
            creditPay.setVerticalLabelBottom(1)
        }
        // 检测上一次选择了什么支付方式
        chickPayType()
        
        //下部横线
        let lineBottom = UIView()
        lineBottom.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineBottom.alpha = 0.5
        self.addSubview(lineBottom)
        lineBottom.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(wxPay.snp_bottom).offset(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(0.5)
        }
        
        let bottomLabel = UILabel(frame: CGRectZero)
        bottomLabel.textColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        bottomLabel.text = "1.若在用车中未造成任何经济损失（如违章罚款和事故车损等情况），可联系客服申请退换租车押金。\n2.在支付1次押金后未进行申请退款操作，租车押金可重复使用。"
        bottomLabel.numberOfLines = 0
        self.addSubview(bottomLabel)
        bottomLabel.font = _globaluifontsma
        bottomLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(lineBottom.snp_bottom).offset(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //左按钮
        cancelBtn = UIButton()
        cancelBtn!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelBtn!.layer.masksToBounds = true
        cancelBtn!.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn!.titleLabel?.font = _globaluifontmorebig
        self.addSubview(cancelBtn!)
        cancelBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomLabel.snp_bottom).offset(7)
            make.left.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //右按钮
        sureBtn = UIButton()
        sureBtn!.setTitleColor(GLOBAL_MASTER_COLOR, forState: UIControlState.Normal)
        sureBtn!.setTitle("确认下单并支付租车押金", forState: UIControlState.Normal)
        sureBtn!.titleLabel?.font = _globaluifontmorebig
        self.addSubview(sureBtn!)
        sureBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomLabel.snp_bottom).offset(7)
            make.left.equalTo(cancelBtn!.snp_right).offset(1)
            make.right.equalTo(0)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //横线
        let lineTransverse = UIView()
        lineTransverse.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineTransverse.alpha = 0.5
        self.addSubview(lineTransverse)
        lineTransverse.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cancelBtn!.snp_top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //竖线
        let lineVertical = UIView()
        lineVertical.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineVertical.alpha = 0.5
        self.addSubview(lineVertical)
        lineVertical.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.left.equalTo(cancelBtn!.snp_right)
            make.top.equalTo(lineTransverse.snp_bottom)
            make.width.equalTo(0.5)
        }
        
    }
    
    /**
     立即用车
     
     - parameter contentType: 类型
     */
    func createImmediatelyUseTheCar(contentType:MyAlertContentViewType){
        createBaseUseTheCar(contentType, message: ["fszc_alertview_useCarTop.png","","fszc_alertview_useCarBottom.png","","取消","用车"])
    }
    
    /**
     立即用车的基类 本来抽出为了还车也可以使用 现在还车有了新设计
     
     - parameter contentType: 类型
     - parameter message:     信息
     */
    func createBaseUseTheCar(contentType:MyAlertContentViewType,message:[String]){
        assert(message.count == 6, "用车提示白框信息错误")
        let topImage = BaseImage(named: message.first!)?.image
        let centerImage = BaseImage(named: message[2])?.image
        let imageWidth = k_Width - 150
        let imageHeight = (k_Width - 150) / 5 * 3
        
        //顶部image
        let topImageView = UIImageView(image: topImage)
        self.addSubview(topImageView)
        topImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(10)
        }
        
        //顶部文字
        let titleLabelTop = UILabel(frame: CGRectZero)
        titleLabelTop.textColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        if contentType == .immediatelyUseTheCar {
            titleLabelTop.attributedText = returnRestTimeOfCar()
        }else{
            titleLabelTop.text = message[1]
        }
        titleLabelTop.numberOfLines = 0
        self.addSubview(titleLabelTop)
        titleLabelTop.font = _globaluifont
        titleLabelTop.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topImageView.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //中部image
        let centerImageView = UIImageView(image: centerImage)
        self.addSubview(centerImageView)
        centerImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(titleLabelTop.snp_bottom).offset(5)
        }
        centerImageView.userInteractionEnabled = true
        
        //中部文字
        let titleLabelCenter = UILabel(frame: CGRectZero)
        titleLabelCenter.textColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        if contentType == .immediatelyUseTheCar {
            titleLabelCenter.attributedText = returnRestMoneyOfUser()
        }else{
            titleLabelCenter.text = message[3]
        }
        titleLabelCenter.numberOfLines = 0
        self.addSubview(titleLabelCenter)
        titleLabelCenter.font = _globaluifont
        titleLabelCenter.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(centerImageView.snp_bottom).offset(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //中间的按钮 只有在立即用车时候才会有
        if contentType == .immediatelyUseTheCar {
            let buttonCenter = UIButton()
            buttonCenter.backgroundColor = UIColor.clearColor()
            centerImageView.addSubview(buttonCenter)
            buttonCenter.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(centerImageView).offset(26)
                make.left.equalTo(centerImageView).offset(23)
                make.width.equalTo(80)
                make.height.equalTo(30)
            }
            otherBtn = buttonCenter
        }
        
        //左按钮
        cancelBtn = UIButton()
        cancelBtn!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelBtn!.layer.masksToBounds = true
        cancelBtn!.setTitle(message[4], forState: UIControlState.Normal)
        self.addSubview(cancelBtn!)
        cancelBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabelCenter.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(self.snp_centerX)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //右按钮
        sureBtn = UIButton()
        sureBtn!.setTitleColor(GLOBAL_MASTER_COLOR, forState: UIControlState.Normal)
        sureBtn!.setTitle(message[5], forState: UIControlState.Normal)
        self.addSubview(sureBtn!)
        sureBtn!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabelCenter.snp_bottom).offset(10)
            make.left.equalTo(self.snp_centerX)
            make.right.equalTo(0)
            make.height.equalTo(43)
            make.bottom.equalTo(0)
        }
        
        //横线
        let lineTransverse = UIView()
        lineTransverse.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineTransverse.alpha = 0.5
        self.addSubview(lineTransverse)
        lineTransverse.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cancelBtn!.snp_top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //横线
        let lineVertical = UIView()
        lineVertical.backgroundColor = GLOBAL_MASTER_LIGHTGRAYCOLOR
        lineVertical.alpha = 0.5
        self.addSubview(lineVertical)
        lineVertical.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.centerX.equalTo(0)
            make.top.equalTo(sureBtn!.snp_top)
            make.width.equalTo(0.5)
        }
    }

    
    /**
     立即用车 返回需要支付的押金余额
     
     - returns: NSMutableAttributedString
     */
    private func returnNeedDepositOfCar() -> NSMutableAttributedString{
        let searchCarTime = GLOBAL_AddForegift.toDouble()!.analyzingString(".2f").stringFormatterCurrency()
        let showString = "需支付租车押金：\(searchCarTime)元"
        let attrString = NSMutableAttributedString(string: showString)
        attrString.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_LIGHTGRAYCOLOR, range: NSMakeRange(0, showString.length))
        attrString.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_ORANGECOLOR, range: NSMakeRange(8, searchCarTime.length))
        
        return attrString
    }
    
    
    /**
     立即用车 返回押金余额
     
     - returns: NSMutableAttributedString
     */
    private func returnDepositOfCar() -> NSMutableAttributedString{
        let searchCarTime = GLOBAL_Account.toDouble()!.analyzingString(".2f").stringFormatterCurrency()
        let showString = "押金余额：\(searchCarTime)元"
        let attrString = NSMutableAttributedString(string: showString)
        attrString.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_LIGHTGRAYCOLOR, range: NSMakeRange(0, showString.length))
        attrString.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_ORANGECOLOR, range: NSMakeRange(5, searchCarTime.length))
        
        return attrString
    }
    
     /**
     立即用车 返回预留的时间
     
     - returns: NSMutableAttributedString
     */
    private func returnRestTimeOfCar() -> NSMutableAttributedString{
        let searchCarTime = "\(GLOBAL_TIMEOUT_SECONDS/60)"
        let showString = "系统将为您预留\(searchCarTime)分钟找车时间，您可以通过导航、鸣笛、双闪找到车辆。"
        let attrString = NSMutableAttributedString(string: showString)
        attrString.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_LIGHTGRAYCOLOR, range: NSMakeRange(0, showString.length))
        attrString.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_ORANGECOLOR, range: NSMakeRange(7, searchCarTime.length))
        
        return attrString
    }
    
    /**
     立即用车 返回可用余额的提示信息
    
     - returns: NSMutableAttributedString
     */
    private func returnRestMoneyOfUser() -> NSMutableAttributedString{
        let price = PersonInstance.shareInstance.balanceCanUse.analyzingString(".2f").stringFormatterCurrency()
        let priceNew = price
        let attrprice =  NSMutableAttributedString(string: priceNew)
        attrprice.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_ORANGECOLOR, range: NSMakeRange(0, priceNew.length))
        let centerTitileFirst = "您的可用余额为"
        let centerTitileSecond = "元"
        let centerAttrStrng = NSMutableAttributedString(string: centerTitileSecond)
        centerAttrStrng.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_LIGHTGRAYCOLOR, range: NSMakeRange(0, centerTitileSecond.length))
        let attrCenter = NSMutableAttributedString(string: centerTitileFirst)
        attrCenter.addAttribute(NSForegroundColorAttributeName, value: GLOBAL_MASTER_LIGHTGRAYCOLOR, range: NSMakeRange(0, centerTitileFirst.length))
        attrCenter.appendAttributedString(attrprice)
        attrCenter.appendAttributedString(centerAttrStrng)
        
        return attrCenter
    }
    
    
    /**
     检测支付方式
     */
    private func chickPayType(){
        switch GLOBAL_PAY_TYPE {
        case "alipay" :
            aliPay.setImage(BaseImage(named: "fszc_alertview_aliPaySelect")?.image, forState: UIControlState.Normal)
            break
        case "wx" :
            wxPay.setImage(BaseImage(named: "fszc_alertview_wxSelect")?.image, forState: UIControlState.Normal)
            break
        default :
            assert(false, "支付方式 错误")
            break
        }
        
    }

    
    /**
     选择支付方式
     
     - parameter sender: 按钮
     */
    func selectPayType(sender:UIButton){
        switch sender.tag {
        case 100 :
            GLOBAL_PAY_TYPE = "alipay"
            sender.setImage(BaseImage(named: "fszc_alertview_aliPaySelect")?.image, forState: UIControlState.Normal)
            wxPay.setImage(BaseImage(named: "fszc_personalcenter_wxLogo")?.image, forState: UIControlState.Normal)
            break
        case 200 :
            GLOBAL_PAY_TYPE = "wx"
            sender.setImage(BaseImage(named: "fszc_alertview_wxSelect")?.image, forState: UIControlState.Normal)
            aliPay.setImage(BaseImage(named: "fszc_alertview_aliPayUnSelect")?.image, forState: UIControlState.Normal)
            break
        case 300 :
            print("不支持信用卡")
            break
        default :
            assert(false, "tag 错误")
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
