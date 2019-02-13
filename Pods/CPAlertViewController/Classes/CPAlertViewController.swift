//
//  CPAlertViewController.swift
//  CPAlertViewController
//
//  Created by ZhaoWei on 15/12/8.
//  Copyright © 2015年 CP3HNU. All rights reserved.
//

import UIKit

public enum CPAlertStyle {
    case success, error, warning, info, none
    case customImage(imageName: String)
    
    var backgroundColorInt: UInt {
        switch self {
        case .success:
            return 0x10A110
        case .error:
            return 0xDC2121
        case .warning:
            return 0xF8E71C
        case .info:
            return 0x4A90E2
        default:
            return 0xFFFFFF
        }
    }
}

public typealias UserAction = ((_ buttonIndex: Int) -> Void)

open class CPAlertViewController: UIViewController {
    
    //MARK: - Custom Properties
    /// The font size of tittle
    open static var titleFontSize: CGFloat = 22.0
    
    /// The font size of message
    open static var messageFontSize: CGFloat = 16.0
    
    /// The font size of title of button
    open static var buttonFontSize: CGFloat = 16.0
    
    /// The text color of tittle
    open static var titleColor = UIColor(rgbValue: 0x333333)
    
    /// The text color of message
    open static var messageColor = UIColor(rgbValue: 0x555555)
    
    /// The text color of title of button
    open static var buttonTitleColor = UIColor.white
    
    /// The normal background color of button
    open static var buttonBGNormalColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    
    /// The highlighted background color of button
    open static var buttonBGHighlightedColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.7)
    
    //MARK: - Const
    fileprivate let kBGTransparency: CGFloat = 0.5
    fileprivate let kVerticalGap: CGFloat = 15.0
    fileprivate let kWidthMargin: CGFloat = 15.0
    fileprivate let kHeightMargin: CGFloat = 15.0
    fileprivate let kContentWidth: CGFloat = 270.0
    fileprivate let kContentHeightMargin: CGFloat = 20.0
    fileprivate let kButtonHeight: CGFloat = 35.0
    fileprivate let kTitleLines: Int = 3
    fileprivate let kImageViewWidth: CGFloat = 30.0
    fileprivate let kButtonBaseTag: Int = 100
    fileprivate let kButtonHoriSpace: CGFloat = 20.0
    fileprivate var imageViewSpace: CGFloat = 0.0
    fileprivate var titleLabelSpace: CGFloat = 0.0
    fileprivate var messageTextViewSpace: CGFloat = 0.0
    
    
    //MARK: - View
    fileprivate var strongSelf: CPAlertViewController?
    fileprivate var contentView = UIView()
    fileprivate var imageView = UIImageView()
    fileprivate var titleLabel: UILabel = UILabel()
    fileprivate var messageTextView = CPAdaptiveTextView()
    fileprivate var buttons: [UIButton] = []
    fileprivate var userAction: UserAction? = nil
    
    //MARK: - Init
    public init() {
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.view.backgroundColor = UIColor(white: 0.0, alpha: kBGTransparency)
        
        strongSelf = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    fileprivate func setupContentView() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.borderColor = UIColor(rgbValue: 0xCCCCCC).cgColor
        self.view.addSubview(contentView)
        
        //Constraints
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-margin-[contentView]-margin-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["margin": kContentHeightMargin], views: ["contentView": contentView])
        for constraint in heightConstraints {
            constraint.priority = UILayoutPriority.defaultHigh
        }
        self.view.addConstraints(heightConstraints)
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: kContentWidth))
        self.view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
    fileprivate func addContentSubviewConstraints() {
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[label]-margin-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["margin": kWidthMargin], views: ["label": titleLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[textView]-margin-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["margin": kWidthMargin], views: ["textView": messageTextView]))
        
        let lastButton = buttons.last!
        
        if buttons.count == 1 {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[button]-margin-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["margin": kWidthMargin], views: ["button": lastButton]))
        } else {
            let firstButton = buttons.first!
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[firstButton]-space-[lastButton(==firstButton)]-margin-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: ["margin": kWidthMargin, "space": kButtonHoriSpace], views: ["firstButton": firstButton, "lastButton": lastButton]))
        }
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-margin-[imageView]-imageSpace-[label]-labelSpace-[textView]-textViewSpace-[button]-margin-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["margin": kHeightMargin, "imageSpace": imageViewSpace, "labelSpace": titleLabelSpace, "textViewSpace": messageTextViewSpace], views: ["label": titleLabel, "textView": messageTextView, "button": lastButton, "imageView": imageView]))
        
        titleLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        messageTextView.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
    }
    
    fileprivate func setupImageView(_ style: CPAlertStyle) {
        
        var imageOption: UIImage? = nil
        
        switch style {
        case .success:
            imageOption = CPAlertViewStyleKit.imageOfCheckmark
        case .error:
            imageOption = CPAlertViewStyleKit.imageOfCross
        case .warning:
            imageOption = CPAlertViewStyleKit.imageOfWarning
        case .info:
            imageOption = CPAlertViewStyleKit.imageOfInfo
        case let .customImage(imageName):
            imageOption = UIImage(named: imageName)
        default:
            break
        }
        
        var imageWidth: CGFloat = 0
        var imageHeight: CGFloat = 0
        if let image = imageOption {
            self.imageView.image = image
            imageWidth = kImageViewWidth
            imageHeight = kImageViewWidth
            imageViewSpace = kVerticalGap
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        //Width and height constraints
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: imageWidth))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: imageHeight))
        
        imageView.backgroundColor = UIColor(rgbValue: style.backgroundColorInt)
        if case .customImage(_) = style {
            imageView.layer.cornerRadius = 0
        } else {
            imageView.layer.cornerRadius = kImageViewWidth/2
        }
    }
    
    fileprivate func setupTitleLabel(_ title: String?) {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = kTitleLines
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: CPAlertViewController.titleFontSize)
        titleLabel.textColor = CPAlertViewController.titleColor
        titleLabel.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        
        if let aTitle = title , aTitle.isEmpty == false {
            titleLabelSpace = kVerticalGap
        }
    }
    
    fileprivate func setupMessageTextView(_ message: String?) {
        
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.textAlignment = .center
        messageTextView.text = message ?? ""
        messageTextView.font = UIFont.systemFont(ofSize: CPAlertViewController.messageFontSize)
        messageTextView.textColor = CPAlertViewController.messageColor
        messageTextView.isEditable = false
        messageTextView.isSelectable = false
        messageTextView.textContainerInset = UIEdgeInsets.zero
        messageTextView.fixedWidth = kContentWidth - 2 * kWidthMargin
        messageTextView.backgroundColor = UIColor.clear
        contentView.addSubview(messageTextView)
        
        if messageTextView.text.isEmpty == false {
            messageTextViewSpace = kVerticalGap
        }
    }
    
    fileprivate func setupButtons(buttonTitle: String, otherButtonTitle: String?) {
        
        if let buttonTitle2 = otherButtonTitle , buttonTitle2.isEmpty == false {
            let button = createButton(buttonTitle2)
            contentView.addSubview(button)
            buttons.append(button)
        }
        
        let buttonTitle1 = buttonTitle.isEmpty ? "OK" : buttonTitle
        let button = createButton(buttonTitle1)
        contentView.addSubview(button)
        buttons.append(button)
    }
    
    fileprivate func createButton(_ title: String) -> UIButton {

        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = kButtonBaseTag + buttons.count
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.setTitle(title, for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: CPAlertViewController.buttonFontSize)
        button.setTitleColor(CPAlertViewController.buttonTitleColor, for: UIControl.State())
        button.setBackgroundImage(CPAlertViewController.buttonBGNormalColor.image(), for: UIControl.State())
        button.setBackgroundImage(CPAlertViewController.buttonBGHighlightedColor.image(), for: .highlighted)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(CPAlertViewController.pressed(_:)), for: UIControl.Event.touchUpInside)
        
        //Height constraints
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: kButtonHeight))
        
        return button
    }
    
    @objc fileprivate func pressed(_ sender: UIButton) {
        
        let index = sender.tag - kButtonBaseTag
        close(clickedAtIndex:index)
    }
    
    fileprivate func close(clickedAtIndex index: Int) {
        
        if let action = userAction {
            action(index)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 0.0
            }) { (Bool) -> Void in
                
                self.contentView.removeFromSuperview()
                self.contentView = UIView()
                
                self.view.removeFromSuperview()
                
                //Releasing strong refrence of itself.
                self.strongSelf = nil
        }
    }
    
    fileprivate func animateAlert() {
        
        view.alpha = 0
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.alpha = 1.0
        })
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.0)), NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 0.0)), NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.0)), NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0))]
        animation.keyTimes = [0, 0.5, 0.75, 1]
        animation.isAdditive = true
        animation.duration = 0.4
        self.contentView.layer.add(animation, forKey: "animation")
    }
    
    //MARK: - API
    open func showSuccess(title: String? = nil, message: String? = nil, buttonTitle: String = "OK", otherButtonTitle: String? = nil, action: UserAction? = nil) {
        show(title: title, message: message, style: .success, buttonTitle: buttonTitle, otherButtonTitle: otherButtonTitle, action: action)
    }
    
    open func showError(title: String? = nil, message: String? = nil, buttonTitle: String = "OK", otherButtonTitle: String? = nil, action: UserAction? = nil) {
        show(title: title, message: message, style: .error, buttonTitle: buttonTitle, otherButtonTitle: otherButtonTitle, action: action)
    }
    
    open func showWarning(title: String? = nil, message: String? = nil, buttonTitle: String = "OK", otherButtonTitle: String? = nil, action: UserAction? = nil) {
        show(title: title, message: message, style: .warning, buttonTitle: buttonTitle, otherButtonTitle: otherButtonTitle, action: action)
    }
    
    open func showInfo(title: String? = nil, message: String? = nil, buttonTitle: String = "OK", otherButtonTitle: String? = nil, action: UserAction? = nil) {
        show(title: title, message: message, style: .info, buttonTitle: buttonTitle, otherButtonTitle: otherButtonTitle, action: action)
    }

    open func show(title: String? = nil, message: String? = nil, style: CPAlertStyle = .none, buttonTitle: String = "OK", otherButtonTitle: String? = nil, action: UserAction? = nil) {
        
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubviewToFront(view)
        view.frame = window.bounds
        
        self.userAction = action
        
        setupContentView()
        setupImageView(style)
        setupTitleLabel(title)
        setupMessageTextView(message)
        setupButtons(buttonTitle: buttonTitle, otherButtonTitle: otherButtonTitle)
        addContentSubviewConstraints()
        
        animateAlert()
    }
}

private class CPAlertViewStyleKit : NSObject {
    
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfWarning: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    //MARK: - Drawing Methods
    class func drawCheckmark() {
        
        let lineColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 89.43, y: 43.76))
        linePath.addLine(to: CGPoint(x: 52.23, y: 79.68))
        linePath.addLine(to: CGPoint(x: 30.52, y: 57.42))
        linePath.lineCapStyle = CGLineCap.square
        linePath.usesEvenOddFillRule = true;
        linePath.lineWidth = 6
        lineColor.setStroke()
        linePath.stroke()
    }
    
    class func drawCross() {
    
        let lineColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 36.9, y: 37.5))
        linePath.addLine(to: CGPoint(x: 83.7, y: 84.3))
        linePath.lineCapStyle = CGLineCap.round
        linePath.usesEvenOddFillRule = true
        linePath.lineWidth = 6
        lineColor.setStroke()
        linePath.stroke()
        
        let line2Path = UIBezierPath()
        line2Path.move(to: CGPoint(x: 83.7, y: 36.9))
        line2Path.addLine(to: CGPoint(x: 36.9, y: 84.3))
        line2Path.lineCapStyle = CGLineCap.round
        line2Path.usesEvenOddFillRule = true
        line2Path.lineWidth = 6
        lineColor.setStroke()
        line2Path.stroke()
    }
    
    class func drawWarning() {
        
        let lineColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 60, y: 66))
        linePath.addLine(to: CGPoint(x: 60, y: 26))
        linePath.lineCapStyle = CGLineCap.round
        linePath.usesEvenOddFillRule = true
        linePath.lineWidth = 8
        lineColor.setStroke()
        linePath.stroke()
        
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 54, y: 88, width: 12, height: 12))
        lineColor.setFill()
        oval2Path.fill()
    }
    
    class func drawInfo() {
        
        let lineColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 60, y: 54))
        linePath.addLine(to: CGPoint(x: 60, y: 94))
        linePath.lineCapStyle = CGLineCap.round
        linePath.usesEvenOddFillRule = true
        linePath.lineWidth = 8
        lineColor.setStroke()
        linePath.stroke()
       
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 54, y: 20, width: 12, height: 12))
        lineColor.setFill()
        oval2Path.fill()
    }
    
    //MARK: - images
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 120), false, 0)
        CPAlertViewStyleKit.drawCheckmark()
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 120), false, 0)
        CPAlertViewStyleKit.drawCross()
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    
    class var imageOfWarning: UIImage {
        if (Cache.imageOfWarning != nil) {
            return Cache.imageOfWarning!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 120), false, 0)
        CPAlertViewStyleKit.drawWarning()
        Cache.imageOfWarning = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfWarning!
    }
    
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 120), false, 0)
        CPAlertViewStyleKit.drawInfo()
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}




