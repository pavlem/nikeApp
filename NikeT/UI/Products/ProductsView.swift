//
//  ProductsView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI

enum ProductsError: LocalizedError, Identifiable {
    case testError
    
    var id: String { errorDescription ?? UUID().uuidString }
    
    var errorDescription: String? {
        switch self {
        case .testError:
            return "This is a test error."
        }
    }
}

protocol ProductsViewModel: ObservableObject {
    var products: [Product] { get set }
    var isLoading: Bool { get set }
    var error: ProductsError? { get set }
    var isFetchNeeded: Bool { get }
    
    func fetchProducts() async
    func reloadProducts() async
}

class ProductsViewModelImpl: ProductsViewModel {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: ProductsError?
    
    var isFetchNeeded: Bool { products.isEmpty }
    
    private let useCase: ProductsUseCase
    
    init(useCase: ProductsUseCase) {
        self.useCase = useCase
    }
    
    @MainActor
    func fetchProducts() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            products = try await useCase.fetchProducts()
        } catch {
            self.error = .testError // Replace with appropriate error handling
        }
    }
    
    @MainActor
    func reloadProducts() async {
        await fetchProducts()
    }
    
}

struct ProductsView: View {
    
    @StateObject var viewModel: ProductsViewModelImpl
    @Environment(\.isLoading) private var isLoading: Binding<Bool>
    
    var body: some View {
        
        List(viewModel.products) { product in
            
            NavigationLink {
                ProductDetailsView(product: product)
            } label: {
                ProductCell(product: product)
            }
        }
        .onReceive(viewModel.$isLoading) {
            isLoading.wrappedValue = $0
        }
        .task {
            guard viewModel.isFetchNeeded else { return }
            await viewModel.fetchProducts()
        }
        .refreshable {
            await viewModel.reloadProducts()
        }
        .navigationTitle(Constants.navigationTitle)
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text(Constants.errorTitleText),
                message: Text(error.errorDescription ?? ""),
                dismissButton: .default(Text(Constants.okText)) {
                    viewModel.error = nil
                }
            )
        }
    }
}

extension ProductsView {
    struct Constants {
        static var navigationTitle: LocalizedStringKey { "Products" }
        static var errorTitleText: LocalizedStringKey { "Error" }
        static var okText: LocalizedStringKey { "Ok" }
    }
}
