//
//  CommentsViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 28.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class CommentsViewController: SceneViewController<CommentsViewModel> {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    
    private let commentCellReuseId = "commentCell"

    override func setupViews() {
        super.setupViews()
        commentsTableView.tableFooterView = UIView()  // remove extra horizontal lines
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        let output = viewModel.transform(CommentsViewModel.Input(doneButtonTap: doneButton.rx.tap.asObservable()))
        
        output.commentsAreHidden.drive(commentsTableView.rx.isHidden).disposed(by: disposeBag)
        output.noCommentsTextIsHidden.drive(noCommentsLabel.rx.isHidden).disposed(by: disposeBag)
        output.commentViewModels.drive(commentsTableView.rx.items(
            cellIdentifier: commentCellReuseId,
            cellType: CommentTableViewCell.self)
        ) { row, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: disposeBag)
    }
}
