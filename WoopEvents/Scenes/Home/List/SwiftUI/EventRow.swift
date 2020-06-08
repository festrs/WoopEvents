//
//  EventRow.swift
//  Components-SwiftUI
//
//  Created by Felipe Dias Pereira on 2020-04-11.
//  Copyright © 2020 Lepus. All rights reserved.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct EventRow: View {
    private let viewModel: HomeCellViewModel

    init(viewModel: HomeCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(
                url: viewModel.imageUrl,
                placeholder: Text("...")
            ).frame(width: 40, height: 40)
            .cornerRadius(5)
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.day)
                    Text(viewModel.month)
                }.font(.callout)
                Text(viewModel.title)
                    .font(.footnote)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationLink(destination: Text("")) {
                EventRow(viewModel: HomeCellViewModel(event: Event.stub(withID: "123")))
            }.previewLayout(.fixed(width: 300, height: 60))
        }
    }
}
#endif
