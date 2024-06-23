//
//  ListColrctionView.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import UIKit

class ListCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var items: [ListPresentData] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    var itemSelected: ((ListPresentData, ListCollectionViewCell) -> Void)?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        self.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    // UICollectionViewDataSource 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout 메서드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        if let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell {
            cell.markAsVisited()
            itemSelected?(item, cell)
        }
    }
}
