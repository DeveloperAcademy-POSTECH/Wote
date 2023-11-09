//
//  CelebrateScean.swift
//  TwoHoSun
//
//  Created by HyunwooPark on 11/9/23.
//

import SpriteKit

class CelebrateScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.background
        scaleMode = .resizeFill

        for node in 0...10 {
            if let particleEmitter = SKEmitterNode(fileNamed: "sprite") {
                particleEmitter.position = CGPoint(x: size.width / 2, y: size.height)
                particleEmitter.particleTexture = SKTexture(imageNamed: "sprite\(node)")
                particleEmitter.particleBirthRate = 1
                addChild(particleEmitter)
            }
        }
    }
}
