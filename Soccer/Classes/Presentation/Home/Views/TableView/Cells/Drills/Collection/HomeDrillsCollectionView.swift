//
//  HomeDrillsCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

final class HomeDrillsCollectionView: UICollectionView {
    var didTap: ((Drill) -> Void)?
    
    lazy var elements = [Drill]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeDrillsCollectionView {
    func setup(elements: [Drill]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension HomeDrillsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeDrillsCollectionCell.self), for: indexPath) as! HomeDrillsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeDrillsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        HomeDrillsCollectionCell.size(for: elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drill = elements[indexPath.row]
        didTap?(drill)
    }
}

// MARK: Private
private extension HomeDrillsCollectionView {
    func initialize() {
        register(HomeDrillsCollectionCell.self, forCellWithReuseIdentifier: String(describing: HomeDrillsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
