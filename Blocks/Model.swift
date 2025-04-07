import Combine
import UIKit
import SpriteKit

class Model: ObservableObject {
    
    private struct MatchPair: Hashable {
        let a: ObjectIdentifier
        let b: ObjectIdentifier
    }
    
    @Published private(set) var score = 0
    
    @Published private(set) var isPlaying = true
    
    @Published private(set) var color: UIColor = .systemRed
    
    private var matches: Set<MatchPair> = []

    func play() {
        score = 0
        matches = []
        isPlaying = true
    }
    
    func finish() {
        isPlaying = false
    }
    
    func updateColor() {
        color = [.systemRed, .systemGreen, .systemBlue, .systemYellow, .systemPurple].randomElement()!
    }
    
    func match(a: SKNode, b: SKNode) -> Bool {
        let match = MatchPair(a: ObjectIdentifier(a), b: ObjectIdentifier(b))
        if a.name == b.name {
            if matches.contains(match) {
                return false
            }
            score += 1
            matches.insert(match)
            return true
        } else {
            return false
        }
    }
    
}
