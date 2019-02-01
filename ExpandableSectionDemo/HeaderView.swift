//
//  HeaderView.swift
//  ExpandableSectionDemo
//
//  Created by Scott Gardner on 1/31/19.
//  Copyright © 2019 Scott Gardner. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    
    func didToggleExpansion(sender: HeaderView)
}

final class HeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var viewForContent: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    @IBOutlet weak var bottomDivider: UIView!
    
    var sectionModel: SectionModel!
    weak var delegate: HeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewForContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleDisclosureButton)))
    }
    
    @IBAction func toggleDisclosureButton() {
        guard sectionModel.isCollapsible else { return }
        sectionModel.isCollapsed.toggle()
        delegate?.didToggleExpansion(sender: self)
    }
    
    func updateDisclosureButton() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.disclosureButton.transform = self.sectionModel.isCollapsed ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
        }
    }
}
