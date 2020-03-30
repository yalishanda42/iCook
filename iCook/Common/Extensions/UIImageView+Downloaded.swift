//
//  UIImageView+Downloaded.swift
//  iCook
//
//  Created by Alexander Ignatov on 29.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

extension UIImageView {
    func imageDownloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func imageDownloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        imageDownloaded(from: url, contentMode: mode)
    }
}
