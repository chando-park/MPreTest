//
//  ListColrctionViewCell.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import UIKit

class CustomScrollViewCell: UIView {
    private let titleLabel = UILabel()
    private let customImageView = UIImageView()
    private let dateLabel = UILabel()

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

        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        dateLabel.numberOfLines = 0
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray

        addSubview(customImageView)
        addSubview(titleLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            customImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 8),

            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configure(with viewModel: ListPresentData) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.publishedAt

        if let url = viewModel.urlToImage {
            customImageView.setImage(with: url.absoluteString)
        } else {
            customImageView.image = nil
        }
    }
}
