//
//  ListColrctionView.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import UIKit

import UIKit

class ListScrollView: UIScrollView {
    private var cells: [CustomScrollViewCell] = []
    private var columns: Int = 5
    private var cellWidth: CGFloat = 300
    private var cellHeight: CGFloat = 140  // 높이를 좀 더 크게 설정
    private var cellSpacing: CGFloat = 10
    private var verticalPadding: CGFloat = 10  // 상하 여백 추가
    
    var items: [ListPresentData] = [] {
        didSet {
            setupCells()
        }
    }
    
    var itemSelected: ((ListPresentData) -> Void)?

    private func setupCells() {
        cells.forEach { $0.removeFromSuperview() }
        cells = []

        for item in items {
            let cell = CustomScrollViewCell()
            cell.configure(with: item)
            addSubview(cell)
            cells.append(cell)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            cell.addGestureRecognizer(tapGesture)
        }

        setNeedsLayout()
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? CustomScrollViewCell,
              let index = cells.firstIndex(of: cell) else { return }
        let item = items[index]
        itemSelected?(item)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalWidth = CGFloat(columns) * (cellWidth + cellSpacing) - cellSpacing
        let rows = ceil(CGFloat(items.count) / CGFloat(columns))
        let totalHeight = rows * (cellHeight + cellSpacing) - cellSpacing + verticalPadding * 2
        
        contentSize = CGSize(width: totalWidth, height: totalHeight)
        
        for (index, cell) in cells.enumerated() {
            let row = index / columns
            let column = index % columns
            
            let x = CGFloat(column) * (cellWidth + cellSpacing)
            let y = CGFloat(row) * (cellHeight + cellSpacing) + verticalPadding
            
            cell.frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        }
    }
}
