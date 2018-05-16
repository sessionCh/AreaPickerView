//
//  AreaPickerView.swift
//  Remind
//
//  Created by sessionCh on 2018/4/17.
//  Copyright © 2018年 ganyi. All rights reserved.
//

import UIKit

// MARK:- 自定义打印方法
public func HCLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    
    print("\(fileName):(\(lineNum))-\(message)")
    
    #endif
}

// 屏幕宽度
private let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
private let kScreenW = UIScreen.main.bounds.width
//适配iPhoneX
private let is_iPhoneX = (kScreenW == 375.0 && kScreenH == 812.0 ? true : false)
private let kNavibarH: CGFloat = is_iPhoneX ? 88.0 : 64.0
private let kTabbarH: CGFloat = is_iPhoneX ? 49.0+34.0 : 49.0
private let kStatusbarH: CGFloat = is_iPhoneX ? 44.0 : 20.0
private let iPhoneXBottomH: CGFloat = 34.0
private let iPhoneXTopH: CGFloat = 24.0

// MARK:- 常量
fileprivate struct Metric {
    
    static let height: CGFloat = 300.0
    
    static let row: Int = 3
    static let rowHeight: CGFloat = 52
    static let lineHeight: CGFloat = 1 / UIScreen.main.scale
    
    static let labFont = UIFont(name: "PingFang-SC-Regular", size: 17)
    
    static let alpha: CGFloat = 0.3
    static let duration: TimeInterval = 0.3
}

public enum AreaPickerViewButtonType: Int {
    case cancel = 0                     // 取消
    case confirm                        // 确定
}

public class AreaPickerView: UIView {
    
    @IBOutlet weak var fatherView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerWhiteView: UIView!
    @IBOutlet weak var centerTopLine: UIView!
    @IBOutlet weak var centerBottomLine: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var pickerLeftLine: UIView!
    @IBOutlet weak var pickerRightLine: UIView!
    
    @IBOutlet weak var pickerLineHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var topBottomLine: UIView!
    @IBOutlet weak var topBottomLineHeightCons: NSLayoutConstraint!
    @IBOutlet weak var bottomTopLine: UIView!
    @IBOutlet weak var bottomCenterLine: UIView!
    
    @IBOutlet weak var topLab: UILabel!
    @IBOutlet weak var bottomLeftBtn: UIButton!
    @IBOutlet weak var bottomRightBtn: UIButton!
    
    private var provinces = [ProvinceModel]()
    
    private var provinceIndex = 0
    private var cityIndex = 0
    private var areaIndex = 0
    private var address: String?
    
    private var defaultAddress: String?
    
    // MARK:- 成功回调
    typealias AddBlock = (_ type: AreaPickerViewButtonType, _ region: String)->Void
    var bottonClickedAction: AddBlock?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
    }
}

// MARK:- 初始化
extension AreaPickerView {
    
    // MARK:- 初始化视图
    private func initUI() {
        
        pickerView.isMultipleTouchEnabled = false
        
        backgroundColor = UIColor.bgColor
        fatherView.backgroundColor = UIColor.clear
        topView.backgroundColor = UIColor.clear
        pickerView.backgroundColor = UIColor.clear
        bottomView.backgroundColor = UIColor.clear
        
        centerWhiteView.backgroundColor = UIColor.white
        fatherView.sendSubview(toBack: centerWhiteView)
        
        centerTopLine.backgroundColor = UIColor.headerBg
        centerBottomLine.backgroundColor = UIColor.headerBg
        
        pickerLeftLine.backgroundColor = UIColor.headerBg
        pickerRightLine.backgroundColor = UIColor.headerBg
        pickerLineHeightCons.constant = Metric.lineHeight
        
        topBottomLine.backgroundColor = UIColor.headerBg
        topBottomLineHeightCons.constant = Metric.lineHeight
        
        bottomTopLine.backgroundColor = UIColor.headerBg
        
        bottomCenterLine.backgroundColor = UIColor.headerBg
        
        topLab.text = "选择地区"
        topLab.textColor = UIColor.word
        
        bottomLeftBtn.setTitle("取消", for: .normal)
        bottomLeftBtn.setTitleColor(UIColor.subWord, for: .normal)
        bottomLeftBtn.tag = AreaPickerViewButtonType.cancel.rawValue
        bottomLeftBtn.addTarget(self, action: #selector(bottonClicked), for: .touchUpInside)
        
        bottomRightBtn.setTitle("确定", for: .normal)
        bottomRightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        bottomRightBtn.setTitleColor(UIColor.confirm, for: .normal)
        bottomRightBtn.tag = AreaPickerViewButtonType.confirm.rawValue
        bottomRightBtn.addTarget(self, action: #selector(bottonClicked), for: .touchUpInside)
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // MARK:- 初始化视图
    func loadData() {
        
        let address = defaultAddress ?? "未选择"
        
        HCLog("----默认选择地区：\(address)")
        
        DispatchQueue.global().async {
            // 获取数据
            let bundle = Bundle.init(for: AreaPickerView.self).url(forResource: "AreaPickerView", withExtension: "bundle")
            guard let path = Bundle.init(url: bundle!)?.url(forResource: "province", withExtension: "json"),
                let data = NSData(contentsOf: path),
                let dictArr = try? JSONSerialization.jsonObject(with: data as Data, options: [JSONSerialization.ReadingOptions.mutableContainers]) as? [[String: Any]]
                else {
                    HCLog("----数据获取错误")
                    return
            }
            // 解析数据
            if let provinceArr = dictArr {
                
                var provinces = [ProvinceModel]()
                
                for (index, provinceDict) in provinceArr.enumerated() {
                    
                    let provinceModel = ProvinceModel()
                    provinceModel.province = provinceDict["name"] as! String
                    
                    let tempAddress = "\(provinceModel.province)"
                    if address.hasPrefix(tempAddress) {
                        self.provinceIndex = index
                    }
                    
                    if let cityArr = provinceDict["city"] as? [[String : Any]] {
                        
                        var cities = [CityModel]()
                        
                        for (index, cityDict) in cityArr.enumerated() {
                            let cityModel = CityModel()
                            cityModel.province = provinceModel.province
                            cityModel.city = cityDict["name"] as! String
                            
                            let tempAddress = "\(provinceModel.province)\(cityModel.city)"
                            if address.hasPrefix(tempAddress) {
                                self.cityIndex = index
                            }
                            
                            if let areaArr = cityDict["area"] as? [String] {
                                
                                var areas = [AreaModel]()
                                
                                for (index, area) in areaArr.enumerated() {
                                    
                                    let areaModel = AreaModel()
                                    areaModel.city = cityModel.city
                                    areaModel.area = area
                                    
                                    let tempAddress = "\(provinceModel.province)\(cityModel.city)\(areaModel.area)"
                                    if address.hasPrefix(tempAddress) {
                                        self.areaIndex = index
                                    }
                                    
                                    areas.append(areaModel)
                                }
                                
                                cityModel.areas = areas
                            }
                            cities.append(cityModel)
                        }
                        
                        provinceModel.cities = cities
                    }
                    provinces.append(provinceModel)
                }
                
                // 赋值
                self.provinces = provinces
                
                // 刷新数据
                self.updateUI()
            }
        }
    }
    
    // MARK:- 刷新显示
    func updateUI() {
        DispatchQueue.global().async {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05, execute: {
                self.pickerView.selectRow(self.provinceIndex, inComponent: 0, animated: false)
                self.pickerView.reloadComponent(0)
            })
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: {
                self.pickerView.selectRow(self.cityIndex, inComponent: 1, animated: false)
                self.pickerView.reloadComponent(1)
            })
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
                self.pickerView.selectRow(self.areaIndex, inComponent: 2, animated: false)
                self.pickerView.reloadComponent(2)
            })
        }
    }
    
    // MARK:- 按钮事件
    @objc func bottonClicked(sender: UIButton) {
        
        HCLog("----\(sender.tag == 1 ? "确认" : "取消")按钮被点击")
        
        if let type = AreaPickerViewButtonType.init(rawValue: sender.tag) {
            
            var address = ""
            
            if self.provinceIndex < provinces.count {
                
                address = provinces[self.provinceIndex].province
                
                let cities = self.provinces[self.provinceIndex].cities
                
                if self.cityIndex < cities.count {
                    
                    let areas = cities[self.cityIndex].areas
                    
                    address = address + cities[self.cityIndex].city
                    
                    if self.areaIndex < areas.count {
                        
                        address = address + areas[self.areaIndex].area
                    }
                }
            }
            self.address = address
            
            HCLog("----确认选择地区：\(address)")

            bottonClickedAction?(type, self.address ?? "")
        }
    }
    
    // MARK:- 获取文本
    func getTitle(row: Int, component: Int) -> String? {
        
        if component == 0 {
            if row < self.provinces.count {
                let provinceModel = self.provinces[row]
                return provinceModel.province
            }
        } else if component == 1 {
            let cities = self.provinces[self.provinceIndex].cities
            if row < cities.count {
                let cityModel = cities[row]
                return cityModel.city
            }
        } else if component == 2 {
            
            let cities = self.provinces[self.provinceIndex].cities
            let areas = cities[self.cityIndex].areas
            if row < areas.count {
                let areaModel = areas[row]
                return areaModel.area
            }
        }
        return nil
    }
    
    // MARK:- 控件高度
    static func defaultHeight() -> CGFloat {
        
        if is_iPhoneX {
            return Metric.height + iPhoneXBottomH
        }
        return Metric.height
    }
    
    // MARK:- 影藏
    @objc fileprivate func dismiss() {
        
        UIView.animate(withDuration: Metric.duration, animations: {
            self.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: AreaPickerView.defaultHeight())
            self.superview?.layoutIfNeeded()
            self.superview?.backgroundColor = UIColor.clear
        }) { (_) in
            self.superview?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}

// MARK:- 调用方法
extension AreaPickerView {
    
    public static func show(window: UIWindow, title: String, defaultValue: String, onNext: @escaping (_ region: String)->Void) {
        
        let pickerView = Bundle.init(identifier: "org.cocoapods.AreaPickerView")?.loadNibNamed("AreaPickerView", owner: self, options: nil)?.first as! AreaPickerView
        pickerView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: defaultHeight())
        
        pickerView.topLab.text = title
        pickerView.defaultAddress = defaultValue
        
        pickerView.loadData()
        
        pickerView.bottonClickedAction = { [weak pickerView] (type, region) in
            if type == .confirm {
                onNext(region)
            }
            pickerView?.dismiss()
        }
        
        let maskView = UIButton(frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.clear
        maskView.addTarget(pickerView, action: #selector(dismiss), for: .touchUpInside)
        maskView.addSubview(pickerView)
        
        window.addSubview(maskView)
        maskView.layoutIfNeeded()
        UIView.animate(withDuration: Metric.duration, animations: {
            pickerView.frame = CGRect(x: 0, y: kScreenH - defaultHeight(), width: kScreenW, height: defaultHeight())
            maskView.layoutIfNeeded()
            maskView.backgroundColor = UIColor(white: 0, alpha: Metric.alpha)
        }, completion: { (animate) in
            pickerView.updateUI()
        })
    }
    
    public static func show(window: UIWindow, onNext: @escaping (_ region: String)->Void) {
        
        let pickerView = Bundle.init(identifier: "org.cocoapods.AreaPickerView")?.loadNibNamed("AreaPickerView", owner: self, options: nil)?.first as! AreaPickerView
        pickerView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: defaultHeight())
        
        pickerView.loadData()
        
        pickerView.bottonClickedAction = { [weak pickerView] (type, region) in
            if type == .confirm {
                onNext(region)
            }
            pickerView?.dismiss()
        }
        
        let maskView = UIButton(frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.clear
        maskView.addTarget(pickerView, action: #selector(dismiss), for: .touchUpInside)
        maskView.addSubview(pickerView)
        
        window.addSubview(maskView)
        maskView.layoutIfNeeded()
        
        UIView.animate(withDuration: Metric.duration) {
            pickerView.frame = CGRect(x: 0, y: kScreenH - Metric.height, width: kScreenW, height: Metric.height)
            maskView.layoutIfNeeded()
            maskView.backgroundColor = UIColor(white: 0, alpha: Metric.alpha)
        }
    }
}

// MARK:- 协议
extension AreaPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Metric.row
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            let provinces = self.provinces
            return provinces.count
        } else if component == 1 {
            let provinces = self.provinces
            if self.provinceIndex < provinces.count {
                let cities = self.provinces[self.provinceIndex].cities
                return cities.count
            }
        } else if component == 2 {
            let provinces = self.provinces
            if self.provinceIndex < provinces.count {
                let cities = self.provinces[self.provinceIndex].cities
                if self.cityIndex < cities.count {
                    let areas = cities[self.cityIndex].areas
                    return areas.count
                }
            }
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //隐藏默认线条
        pickerView.subviews[1].isHidden = true
        pickerView.subviews[2].isHidden = true
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width / 3, height: Metric.rowHeight)
        let pickerLabel = UILabel(frame: frame)
        pickerLabel.textColor = UIColor.word
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.layer.transform = CATransform3DIdentity
        pickerLabel.textAlignment = .center
        pickerLabel.font =  Metric.labFont
        pickerLabel.text = getTitle(row: row, component: component)
        
        return pickerLabel
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            
            if row > self.provinces.count - 1 {
                self.provinceIndex = self.provinces.count - 1
            } else {
                self.provinceIndex = row
            }
            
            // 刷新 省
            self.pickerView.selectRow(self.provinceIndex, inComponent: 0, animated: false)
            self.pickerView.reloadComponent(0)
            
            // 刷新 市
            self.cityIndex = 0
            self.pickerView.selectRow(0, inComponent: 1, animated: false)
            self.pickerView.reloadComponent(1)
            
            // 刷新 区
            self.areaIndex = 0
            self.pickerView.selectRow(0, inComponent: 2, animated: false)
            self.pickerView.reloadComponent(2)
            
        } else if component == 1 {
            let cities = self.provinces[self.provinceIndex].cities
            
            if row > cities.count - 1 {
                self.cityIndex = cities.count - 1
            } else {
                self.cityIndex = row
            }
            
            // 刷新 市
            self.pickerView.selectRow(self.cityIndex, inComponent: 1, animated: false)
            self.pickerView.reloadComponent(1)
            
            // 刷新 区
            self.areaIndex = 0
            self.pickerView.selectRow(0, inComponent: 2, animated: false)
            self.pickerView.reloadComponent(2)
            
        } else if component == 2 {
            
            let cities = self.provinces[self.provinceIndex].cities
            let areas = cities[self.cityIndex].areas
            
            if row > areas.count - 1 {
                self.areaIndex = areas.count - 1
            } else {
                self.areaIndex = row
            }
            
            // 刷新 区
            self.pickerView.selectRow(self.areaIndex, inComponent: 2, animated: false)
            self.pickerView.reloadComponent(2)
        }
        
        let provinces = self.provinces
        
        
        var address = ""
        
        if self.provinceIndex < provinces.count {
            
            address = provinces[self.provinceIndex].province
            
            let cities = self.provinces[self.provinceIndex].cities
            
            if self.cityIndex < cities.count {
                
                let areas = cities[self.cityIndex].areas
                
                address = address + cities[self.cityIndex].city
                
                if self.areaIndex < areas.count {
                    
                    address = address + areas[self.areaIndex].area
                }
            }
        }
        
        self.address = address
        
        HCLog("----当前选择地区：\(address)")
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Metric.rowHeight
    }
}

