//
//  SearchResultsCell.swift
//  iCook
//
//  Created by Alexander Ignatov on 1.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultsCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var leadingImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - ViewModel
    
    private var viewModel: DishOverviewViewModel?
    
    func configure(with viewModel: DishOverviewViewModel) {
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.subtitleText
        
        UIImage
            .imageDownloaded(from: viewModel.imageUrl)
            .drive(leadingImageView.rx.image)
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
    }
}
