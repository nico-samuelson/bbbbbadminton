//
//  VideoPlaybackView.swift
//  MC3
//
//  Created by Nico Samuelson on 29/07/24.
//

import SwiftUI
import AVFoundation
import AVKit
//import _AVKit_SwiftUI

struct VideoPlaybackView: View {
    @State var url: String
    @State var player: AVPlayer? = nil
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        GeometryReader { gr in
            VideoPlayer(player: player)
                .frame(maxWidth: gr.size.height, maxHeight: gr.size.width)
                .onAppear {
                    player = AVPlayer(url: URL(string: url)!)
                    player?.play()
                }
        }
        
    }
}

//#Preview {
////    VideoPlaybackView()
//}
