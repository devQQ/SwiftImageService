//
//  ImageLoader.swift
//  
//
//  Created by Q Trang on 7/20/20.
//

import Foundation
import Combine
import UIKit
import SwiftUIToolbox

public class ImageLoader: ObservableObject {
    public let url: String?
    public let manualFetch: Bool
    private var cancelBag = CancelBag()
    
    @Published public var image: UIImage? = nil
    
    public var anyObjectWillChange: AnyPublisher<UIImage?, Never> = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
    
    public init(url: String?, manualFetch: Bool = false) {
        self.url = url
        self.manualFetch = manualFetch
        
        if !manualFetch {
            anyObjectWillChange = self.$image.handleEvents(receiveSubscription: { [weak self](subscription) in
               self?.fetchImage()
                }, receiveCancel: {[weak self] in
                    self?.cancelBag.cancel()
            })
                .eraseToAnyPublisher()
        }
    }
    
    public func fetchImage() {
        guard let url = url, image == nil else {
            return
        }
        
        ImageService.shared.fetchImage(url: url)
            .handleEvents(receiveCancel: {[weak self] in
                self?.cancelBag.cancel()
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &cancelBag)
    }
    
    deinit {
        cancelBag.cancel()
        cancelBag.removeAll()
    }
}
