//
//  ContentView.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 24.03.2022.
//

import SwiftUI
import Combine

struct MainView: View {
    // MARK: - Properties
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        Text(viewModel.answer ?? "")
            .padding()
        
        HStack {
            TextField( "Type a question", text: $viewModel.question)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("Ask", action: {
                viewModel.sendRequestTrigger = ()
            })
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
        }
    }
}

