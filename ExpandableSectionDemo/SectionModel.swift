//
//  SectionModel.swift
//  StackableExpandableSections
//
//  Created by Scott Gardner on 2/1/19.
//  Copyright © 2019 Scott Gardner. All rights reserved.
//

import Foundation

final class SectionModel {
    
    let section: Int
    let title: String
    let data: [String]
    var isCollapsible = true
    var isCollapsed = false
    
    init(section: Int, title: String, data: [String], isCollapsible: Bool = true, isCollapsed: Bool = false) {
        self.section = section
        self.title = title
        self.data = data
        self.isCollapsible = isCollapsible
        self.isCollapsed = isCollapsed
    }
}
