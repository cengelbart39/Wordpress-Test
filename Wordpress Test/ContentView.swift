//
//  ContentView.swift
//  Wordpress Test
//
//  Created by Christopher Engelbart on 1/31/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var post: Post? = nil
    
    var body: some View {
        if let post = post {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.system(.largeTitle, design: .serif))
                            .bold()
                            .padding(.bottom, 10)
                        
                        ForEach(0..<post.content.count, id: \.self) { index in
                            Text(post.content[index])
                                .font(.system(.body, design: .serif))
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .textSelection(.enabled)
            
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .task {
                    do {
                        self.post = try await WordpressService().fetchContent()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
