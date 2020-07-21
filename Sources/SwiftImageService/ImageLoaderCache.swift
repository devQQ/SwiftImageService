//
//  ImageLoaderCache.swift
//  
//
//  Created by Q Trang on 7/20/20.
//

import Foundation
import SwiftUIToolbox

public class ImageLoaderCache {
    public static let shared = ImageLoaderCache()
    private var cache: Cache<NSString, ImageLoader> = Cache()

    public func load(url: String?, manualFetch: Bool = false) -> ImageLoader {
        let key = NSString(string: "\(url ?? "missing_path")")

        if let loader = cache[key] {
            return loader
        } else {
            let loader = ImageLoader(url: url, manualFetch: manualFetch)
            cache[key] = loader

            return loader
        }
    }
}

