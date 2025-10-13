//
//  MusicButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/19/25.
//

import SwiftUI

struct MusicButtonView: View {
    @State private var isPlaying = true
    
    var body: some View {
        Button {
            isPlaying.toggle()
        } label: {
            Image(isPlaying ? "music" : "stop-music")
                .resizable()
                .frame(width: 48, height: 48)
        }
    }
}

#Preview {
    MusicButtonView()
}
