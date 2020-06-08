//
//  ImageLoaderView.swift
//  Components-SwiftUI
//
//  Created by Felipe Dias Pereira on 2020-04-08.
//  Copyright © 2020 Lepus. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct ImageLoaderView: View {
  let url = URL(string: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg")!

    var body: some View {
        AsyncImage(
            url: url,
            placeholder: Text("Loading ...")
        ).aspectRatio(contentMode: .fit)
    }

}

@available(iOS 13.0, *)
struct ImageLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderView()
    }
}
