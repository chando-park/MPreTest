//
//  ListColrctionViewCell.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let customImageView = UIImageView()
    private let dateLabel = UILabel()
    
    private var visited = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true

        contentView.addSubview(customImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 8),

            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with viewModel: ListPresentData) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.publishedAt

        if let url = viewModel.urlToImage {
            // 이미지 로딩 로직 추가 (예: URLSession, SDWebImage 등 사용)
            // 예를 들어:
            // customImageView.sd_setImage(with: url)
        } else {
            customImageView.image = nil
        }

        if visited {
            titleLabel.textColor = .red
        } else {
            titleLabel.textColor = .black
        }
    }
    
    func markAsVisited() {
        visited = true
        titleLabel.textColor = .red
    }
}
