//
//  ParticleView.swift
//  TwoHoSun
//
//  Created by HyunwooPark on 11/9/23.
//

import SwiftUI
import SpriteKit

struct ParticleView: View {
    var scene: SKScene {
        let scene = CelebrateScene()
        scene.size = CGSize(width: 300, height: 300)
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(maxWidth: 300, maxHeight:300)
    }
}

#Preview {
    ParticleView()
}
