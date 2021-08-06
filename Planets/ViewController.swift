//
//  ViewController.swift
//  Planets
//
//  Created by Dilip Patidar on 03/08/21.
//

import Combine
import UIKit

final class ViewController: UIViewController {

    private var collectionView: UICollectionView!
    private let viewModel: PlanetListViewModel
    private let cellreuseIdentifier = String(describing: PlanetCollectionViewCell.self)

    private var cancellables: [AnyCancellable] = []

    private(set) var activityIndicator: UIActivityIndicatorView

    init(with viewModel: PlanetListViewModel) {
        self.viewModel = viewModel
        activityIndicator = UIActivityIndicatorView()
        super.init(nibName: nil, bundle: nil)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .blue
        activityIndicator.style = .large

        let collectionViewLayout = creatCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self

        title = "Planets"

        self.viewModel.cellModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center

        // configure collection view and register cell reuse identifier
        collectionView.register(PlanetCollectionViewCell.self, forCellWithReuseIdentifier: cellreuseIdentifier)

        // Apply constraints
        NSLayoutConstraint.activate(createConstraints())

        activityIndicator.startAnimating()
        updateBackgroundColors()
    }

    // MARK: private Util

    /// This method creates a list view layout
    /// - Returns:an instance of UICollectionViewCompositionalLayout
    private func creatCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.interItemSpacing = .fixed(CGFloat(10))
        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = viewModel.items(in: section)
        if items > 0 {
            self.activityIndicator.stopAnimating()
        }
        return items
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections
    }
}

// MARK: UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellreuseIdentifier, for: indexPath) as! PlanetCollectionViewCell
        let cellViewModel = viewModel.cellViewModel(for: indexPath.item, in: indexPath.section)
        cell.setUp(with: cellViewModel)
        return cell
    }
}

// MARK : extension to help with creating constraints to layout collection view in view controller
extension ViewController {
    func createConstraints() -> [NSLayoutConstraint] {

        let safeArea = view.safeAreaLayoutGuide
        let constraints =
                [
                    collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16.0),
                    collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16.0),
                    collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                    collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor)
                ]
        return constraints
    }
}

// MARK : extension to help adopt to theme changes
extension ViewController {

    private func updateBackgroundColors() {
        let bgColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
        collectionView.backgroundColor = bgColor
        view.backgroundColor = bgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBackgroundColors()
    }
}
