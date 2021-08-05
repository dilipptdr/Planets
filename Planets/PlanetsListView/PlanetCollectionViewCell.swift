//
//  PlanetCollectionViewCell.swift
//  Planets
//
//  Created by Dilip Patidar on 04/08/21.
//

import Combine
import UIKit

final class PlanetCollectionViewCell: UICollectionViewCell {

    // MARK: var
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)

        // Accessibility
        isAccessibilityElement = true
        nameLabel.isAccessibilityElement = false
        accessibilityLabel = nameLabel.text

        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.0

        // Apply constraints
        NSLayoutConstraint.activate(createConstraints())

        updateColors()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: public

    func setUp(with viewData: PlanetListCellViewData) {
        self.nameLabel.text = viewData.name
    }

    // MARK: cell prepare for reuse
    override func prepareForReuse() {
        nameLabel.text = nil
    }

    // MARK: private

    private func updateColors() {
        var bgColor: UIColor = .white
        var textColor: UIColor = .black
        if traitCollection.userInterfaceStyle == .dark {
            bgColor = .black
            textColor = .white
        }
        contentView.backgroundColor = bgColor
        backgroundColor = bgColor
        nameLabel.textColor = textColor
        contentView.layer.borderColor = textColor.cgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
}


// MARK : extension to help with creating constraints for cell subviews
extension PlanetCollectionViewCell {
    func createConstraints() -> [NSLayoutConstraint] {

        let safeArea = contentView.safeAreaLayoutGuide
        let constraints =
                [
                    nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8.0),
                    nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                    nameLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                    nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor)
                ]
        return constraints
    }
}
