//
//  ImageService.swift
//  
//
//  Created by Q Trang on 7/20/20.
//

import Foundation
import SwiftUI
import Combine

public class ImageService {
    public static let shared = ImageService()
    
    public func fetchImage(url: String) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .tryMap { (data, response) -> UIImage? in
                UIImage(data: data)
        }
        .catch({ (error) -> Just<UIImage?> in
            return Just(nil)
        })
        .eraseToAnyPublisher()
    }
}
