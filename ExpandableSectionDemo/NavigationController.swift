//
//  NavigationController.swift
//  ExpandableSectionDemo
//
//  Created by Scott Gardner on 1/31/19.
//  Copyright © 2019 Scott Gardner. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
    
    @IBAction func scrollToTop(_ sender: Any) {
        guard let controller = viewControllers.first as? ViewController else { return }
        controller.scrollToTop()
    }
}
