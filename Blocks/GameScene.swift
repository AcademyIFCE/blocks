import SpriteKit
import Combine

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum BitMask: UInt32 {
        case edges = 1 // 0b01
        case block = 2 // 0b10
        case ceiling = 4 // 0b100
    }
    
    let model: Model
    
    var cancellables = Set<AnyCancellable>()
        
    init(model: Model) {
        self.model = model
        super.init(size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.name = "scene"
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: .init(origin: .zero, size: frame.size))
        physicsBody?.categoryBitMask = BitMask.edges.rawValue
        
        physicsWorld.contactDelegate = self
        
        let ceiling = makeCeiling()
        ceiling.position = CGPoint(x: view.frame.midX, y: frame.maxY)
        addChild(ceiling)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let block = makeBlock()
        block.position = CGPoint(x: location.x, y: frame.maxY - block.size.height/2 - 10)
        addChild(block)
        if !ProcessInfo.processInfo.arguments.contains("DisableColorUpdate") {
            model.updateColor()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        if !ProcessInfo.processInfo.arguments.contains("DisableNodeMatching"), model.match(a: nodeA, b: nodeB) {
            remove(nodeA)
            remove(nodeB)
        }
        if nodeA.name == "ceiling" || nodeB.name == "ceiling" {
            for node in self.children where node.name != "ceiling" {
                remove(node)
            }
            model.finish()
        }
    }
    
    private func makeCeiling() -> SKSpriteNode {
        let ceiling = SKSpriteNode(color: .clear, size: CGSize(width: frame.size.width, height: 1))
        ceiling.name = "ceiling"
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.size.width, height: 1))
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.categoryBitMask = BitMask.ceiling.rawValue
        return ceiling
    }
    
    private func makeBlock() -> SKSpriteNode {
        let size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        let block = SKSpriteNode(color: model.color, size: size)
        block.name = model.color.description
        block.accessibilityLabel = "block"
        block.physicsBody = SKPhysicsBody(rectangleOf: size)
        block.physicsBody?.categoryBitMask = BitMask.block.rawValue
        block.physicsBody!.contactTestBitMask = BitMask.block.rawValue + BitMask.ceiling.rawValue
        return block
    }
    
    private func remove(_ node: SKNode) {
        node.run(.fadeOut(withDuration: 0.25)) {
            node.removeFromParent()
        }
    }
    
}
