//
//  ViewController.swift
//  ExpandableSectionDemo
//
//  Created by Scott Gardner on 1/31/19.
//  Copyright © 2019 Scott Gardner. All rights reserved.
//

import UIKit
import HMSegmentedControl

final class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: HMSegmentedControl!
    @IBOutlet weak var favoritesSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControlHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesSectionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var toggleFavoritesButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var data = {
        return [
            SectionModel(section: 0, title: "FAVORITES", data: (0..<10).map { "F - \($0)" }, isCollapsed: true),
            SectionModel(section: 1, title: "ALL", data: (0..<30).map { "A - \($0)" }, isCollapsible: false)
        ]
    }()
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureSegmentedControl()
        configureTableView()
    }
    
    @IBAction func toggleFavorites() {
        let sectionModel = data[0]
        sectionModel.isCollapsed.toggle()
        tableView.beginUpdates()
        
        UIView.animate(withDuration: 0.2) {
            self.toggleFavoritesButton.transform = sectionModel.isCollapsed ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
        }
        
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        tableView.endUpdates()
        
        if sectionModel.isCollapsed == false {
            scrollToTop()
        }
    }
    
    @objc func handleSegmentedControlChanged(_ segmentedControl: HMSegmentedControl) {
//        print(segmentedControl.selectedSegmentIndex)
    }
    
    func configureSearchController() {
        let searchBar = searchController.searchBar
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func configureSegmentedControl() {
        segmentedControl.sectionTitles = ["Dashboards", "Lists"]
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.selectionIndicatorHeight = 3.0
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionIndicatorColor = UIColor(displayP3Red: 0.467, green: 0.29, blue: 0.643, alpha: 1.0)
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControlChanged(_:)), for: .valueChanged)
    }
    
    func configureTableView() {
        let name = String(describing: HeaderView.self)
        let header = UINib(nibName: name, bundle: Bundle.main)
        tableView.register(header, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func scrollToTop() {
        if data[0].isCollapsed == false,
            data[0].data.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        } else {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.tableView.contentOffset = .zero
            }
        }
    }
    
    func toggleSegmentedControl() {
        let isExpanded = favoritesSectionHeightConstraint.constant == 115.0
        segmentedControlHeightConstraint.constant = isExpanded ? 0.0 : 40.0
        favoritesSectionHeightConstraint.constant = isExpanded ? 64.0 : 115.0
        
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        toggleSegmentedControl()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        toggleSegmentedControl()
        return true
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = data[section]
        return sectionModel.isCollapsed ? 0 : sectionModel.data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: HeaderView.self)) as! HeaderView
        let sectionModel = data[section]
        header.sectionModel = sectionModel
        header.titleLabel.text = sectionModel.title
        header.disclosureButton.isHidden = sectionModel.isCollapsible == false
        header.delegate = sectionModel.isCollapsible ? self : nil
        header.updateDisclosureButton()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 64.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = data[indexPath.section].data[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard tableView.contentOffset.y < 0.0 else {
            favoritesSectionBottomConstraint.constant = 0.0
            return
        }
        
        favoritesSectionBottomConstraint.constant = tableView.contentOffset.y
    }
}

extension ViewController: HeaderViewDelegate {
    
    func didToggleExpansion(sender: HeaderView) {
        tableView.beginUpdates()
        sender.updateDisclosureButton()
        tableView.reloadSections(IndexSet(arrayLiteral: sender.sectionModel.section), with: .automatic)
        tableView.endUpdates()
    }
}
