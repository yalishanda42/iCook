//
//  CommentsViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 28.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommentsViewModel: SceneViewModel {
    weak var coordinatorDelegate: Coordinator?
    
    // TEST DATA
    private var noCommentsTextIsHidden: Driver<Bool> {
        commentsAreHidden.map(!)
    }
    
    private var commentsAreHidden: Driver<Bool> {
        Observable.just(true).asDriver(onErrorJustReturn: false)
    }
    
    private var commentViewModels: Driver<[CommentViewModel]> {
        Observable.just([
            CommentViewModel(with: Comment(text: "Хахаа, много добре се получи! Рецепта Класик 3.", authorNames: "Test Testerson", authorEmail: "test@example.com")),
            CommentViewModel(with: Comment(text: "Много гадна рецепта. Изобщо няма нищо общо с реалността! Срам и позор.", authorNames: "Maionez Stoev", authorEmail: "ant@oni.com")),
        ]).asDriver(onErrorJustReturn: [])
    }
    // =========
}

extension CommentsViewModel: IOTransformable {
    struct Input {
        let doneButtonTap: Observable<Void>
    }
    
    struct Output {
        let noCommentsTextIsHidden: Driver<Bool>
        let commentsAreHidden: Driver<Bool>
        let commentViewModels: Driver<[CommentViewModel]>
    }
    
    func transform(_ input: Input) -> Output {
        input.doneButtonTap.subscribe(onNext: goBack).disposed(by: disposeBag)
        
        return Output(
            noCommentsTextIsHidden: noCommentsTextIsHidden,
            commentsAreHidden: commentsAreHidden,
            commentViewModels: commentViewModels
        )
    }
}

private extension CommentsViewModel {
    func goBack() {
        coordinatorDelegate?.finish()
    }
}
