//
//  NewsTableViewCellViewModel.swift
//  NewsApp
//
//  Created by Admin on 07/09/22.
//

import Foundation

class NewsTableViewCellViewModel {
    
    let title: String
    let subTitle: String
    var imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subTitle: String, imageURL: URL?) {
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
    }
}
