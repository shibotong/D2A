//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        SearchResultView(viewModel: viewModel)
        .navigationTitle(LocalizableStrings.search)
            .searchable(
                text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always),
                prompt: LocalizableStrings.searchPageTitle
            )
            .disableAutocorrection(true)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search(searchText: viewModel.searchText)
                }
            }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
        .previewDevice(.iPhone)
        .previewDisplayName("iPhone")
        .environmentObject(ConstantsController.preview)
        
        NavigationView {
            EmptyView()
            SearchView()
        }
        .previewDevice(.iPad)
        .previewDisplayName("iPad")
        .environmentObject(ConstantsController.preview)
    }
}
