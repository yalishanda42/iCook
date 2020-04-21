//
//  CommentViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class CommentViewModel {
    
    var commentText: String {
        model.text
    }
    
    var commentAuthorInfoText: String {
        "\(model.authorNames) <\(model.authorEmail)>"
    }

    private let model: Comment
    
    init(with model: Comment) {
        self.model = model
    }
}
