//
//  UIImage+Downloaded.swift
//  iCook
//
//  Created by Alexander Ignatov on 29.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIImage {
    static func imageDownloaded(from url: URL) -> Driver<UIImage?> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                observer.onNext(image)
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }.asDriver(onErrorJustReturn: nil)
    }
    
    static func imageDownloaded(from urlString: String) -> Driver<UIImage?> {
        guard let url = URL(string: urlString) else { return .just(nil) }
        return imageDownloaded(from: url)
    }
}
