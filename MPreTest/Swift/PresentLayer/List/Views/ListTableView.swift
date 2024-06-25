//
//  ListScrollView.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import UIKit

class ListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var items: [ListPresentData] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    var itemSelected: ((ListPresentData) -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        self.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        let item = items[indexPath.row]
        cell.configure(title: item.title, imageUrl: item.urlToImage, publishedAt: item.publishedAt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        itemSelected?(item)
    }
}
