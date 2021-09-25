//
//  MainTableViewCell.swift
//  RickAndMorty...
//
//  Created by Андрей on 15.06.2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {
   
    //MARK: Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maskImageView: UIView!
    
    // MARK: Properties
    
    static let reuseId = String(describing: MainTableViewCell.self)
    public var model: MainModel? {
        didSet {
            configureCell()
        }
    }
    
    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 16
    }
    
    // MARK: Private Methods
    
    private func cleanCell() {
        mainImageView = nil
        titleLabel.text = nil
    }
    
    private func configureCell() {
        mainImageView?.image = model?.image
        titleLabel?.text = model?.type.rawValue.capitalized
    }
}
