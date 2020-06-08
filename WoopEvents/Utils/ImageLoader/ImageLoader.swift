//
//  ImageLoader.swift
//  Components-SwiftUI
//
//  Created by Felipe Dias Pereira on 2020-04-07.
//  Copyright © 2020 Lepus. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

@available(iOS 13.0, *)
class ImageLoader: ObservableObject {
  @Published var image: UIImage?
  private let url: URL

  init(url: URL) {
    self.url = url
  }
  
  private var cancellable: AnyCancellable?

  deinit {
    cancellable?.cancel()
  }

  func load() {
    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .map { UIImage(data: $0.data) }
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .assign(to: \.image, on: self)
  }

  func cancel() {
    cancellable?.cancel()
  }
}
