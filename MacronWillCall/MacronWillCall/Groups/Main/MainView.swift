//
//  ContentView.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 24.03.2022.
//

import SwiftUI

struct MainView: View {
    // MARK: - Properties
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        Text(viewModel.question)
            .padding()
        Text(viewModel.answer ?? "")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
