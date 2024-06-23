//
//  ListTableViewCell.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import UIKit

class ListTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let customImageView = UIImageView()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            customImageView.heightAnchor.constraint(equalTo: customImageView.widthAnchor, multiplier: 0.75),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 8),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(title: String, imageUrl: URL?, publishedAt: String) {
        titleLabel.text = title
        dateLabel.text = publishedAt
        
        if let url = imageUrl {
            // 이미지 로딩 로직 추가 (예: URLSession, SDWebImage 등 사용)
            // 예를 들어:
            // customImageView.sd_setImage(with: url)
            customImageView.setImage(with: url.absoluteString)
        } else {
            customImageView.image = nil
        }
    }
}
