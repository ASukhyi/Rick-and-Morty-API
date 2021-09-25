//
//  LocationItemCell.swift
//  RickAndMorty...
//
//  Created by Андрей on 24.06.2021.
//

import UIKit

class LocationItemCell: UICollectionViewCell {

    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    

    // MARK: Properties
    
    static let reuseId = String(describing: LocationItemCell.self)
    private var name: String?
    private var task: URLSessionDataTask?
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        bottomView.roundCorners([.bottomRight, .bottomLeft], radius: 8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanCell()
    }
    
    // MARK: Public Methods
    
    public func configureCell(name: String?) {
        self.name = name
        fillCell()
    }
    
    // MARK: Private Methods
    
    private func fillCell() {
        nameLabel.text = name
        }
    
    private func cleanCell() {
        nameLabel.text = nil
        task?.cancel()
        task = nil
    }
    
}
        

