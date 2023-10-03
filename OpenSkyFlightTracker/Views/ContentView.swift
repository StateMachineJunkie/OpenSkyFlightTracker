//
//  ContentView.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: ViewModel
    @State private var isShowingErrorAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                MapView(viewModel: viewModel)

                if viewModel.isLoadingData {
                    ActivityIndicatorView()
                }
            }
            .onAppear {
                viewModel.loadData()
            }
        }
        .navigationTitle(Text("Regional Flights"))
        .errorAlert(error: $viewModel.error)
    }

}

#Preview {
    ContentView(viewModel: ViewModel(with: CLLocationProvider()))
}

// https://www.avanderlee.com/swiftui/error-alert-presenting/
extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
