//
//  extension+UINavigationItem.swift
//  ToDoList
//
//  Created by Faruk YILDIRIM on 2.01.2022.
//

import Foundation
import UIKit

extension UINavigationItem {
    func setTitle(title:String, subtitle:String) {
        
        let navTitle = UILabel()
        navTitle.text = title
        navTitle.font = UIFont.systemFont(ofSize: 17)
        navTitle.sizeToFit()
        
        let navSubTitle = UILabel()
        navSubTitle.text = subtitle
        navSubTitle.font = UIFont.systemFont(ofSize: 13)
        navSubTitle.textColor = .gray
        navSubTitle.textAlignment = .center
        navSubTitle.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [navTitle, navSubTitle])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(navTitle.frame.size.width, navSubTitle.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        navTitle.sizeToFit()
        navSubTitle.sizeToFit()
        
        self.titleView = stackView
    }
}
