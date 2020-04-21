//
//  CommentTableViewCell.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    // MARK: - ViewModel
    
    private var viewModel: CommentViewModel?
    
    func configure(with viewModel: CommentViewModel) {
        self.viewModel = viewModel
        commentLabel.text = viewModel.commentText
        authorLabel.text = viewModel.commentAuthorInfoText
    }
}
