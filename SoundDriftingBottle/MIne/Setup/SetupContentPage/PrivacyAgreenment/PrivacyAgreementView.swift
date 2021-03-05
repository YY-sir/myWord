//
//  PrivacyAgreementView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/3/5.
//

import Foundation
import UIKit
class PrivacyAgreementView: UIView {
    let contentScrollview = UIScrollView()
    let contentTextfiled = UITextField()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupScrollview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.addSubview(contentScrollview)
//        contentScrollview.backgroundColor = .black
        contentScrollview.snp.makeConstraints{(make) in
            make.height.width.equalToSuperview()
        }
        contentScrollview.contentSize = CGSize(width: contentScrollview.frame.width, height: 1500)
    }
    
    fileprivate func setupScrollview(){
        contentScrollview.addSubview(label)
        label.snp.makeConstraints{(make) in
            make.top.left.equalTo(10)
            make.width.equalToSuperview().offset(-20)
        }
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "本应用尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照本隐私权政策的规定使用和披露您的个人信息。但本应用将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本应用不会将这些信息对外披露或向第三方提供。本应用会不时更新本隐私权政策。您在同意本应用服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本应用服务使用协议不可分割的一部分。\n1. 适用范围 \na) 在您使用本应用网络服务，进行您获取网络数据以帮助您选择靠谱的运营商。\n2. 信息使用 \na)本应用不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息，除非事先得到您的许可，或该第三方和本应用（含本应用关联公司）单独或共同为您提供服务，且在该服务结束后，其将被禁止访问包括其以前能够访问的所有这些资料。\nb)本应用亦不允许任何第三方以任何手段收集、编辑、出售或者无偿传播您的个人信息。任何本应用平台用户如从事上述活动，一经发现，本应用有权立即终止与该用户的服务协议。\nc)为服务用户的目的，本应用可能通过使用您的个人信息，向您提供您感兴趣的信息，包括但不限于向您发出产品和服务信息，或者与本应用合作伙伴共享信息以便他们向您发送有关其产品和服务的信息（后者需要您的事先同意）。\n3.信息披露\n在如下情况下，本应用将依据您的个人意愿或法律的规定全部或部分的披露您的个人信息：\na)经您事先同意，向第三方披露；\nb)为提供您所要求的产品和服务，而必须和第三方分享您的个人信息；\nc)根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\nd) 如您出现违反中国有关法律、法规或者本应用服务协议或相关规则的情况，需要向第三方披露；\ne) 如您是适格的知识产权投诉人并已提起投诉，应被投诉人要求，向被投诉人披露，以便双方处理可能的权利纠纷；\nf) 其它本应用根据法律、法规或者网站政策认为合适的披露。\n4. 信息安全 \na)我们不会将您的信息提交或者上传，所以您的信息绝对安全。"
        
        //动态获得label的高度，再调整scrollview contentSize的高度
        let labelMaxSize = CGSize(width: self.frame.width - 20, height: 1500)
        let realSize = label.sizeThatFits(labelMaxSize)
        contentScrollview.contentSize = CGSize(width: contentScrollview.frame.width, height: realSize.height + 50)
        contentScrollview.isScrollEnabled = true
        
    }
}
