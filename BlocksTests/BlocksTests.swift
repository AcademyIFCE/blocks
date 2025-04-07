import XCTest
import SpriteKit
@testable import Blocks

final class BlocksTests: XCTestCase {
    
    let model = Model()

    func testMatchSameName() throws {

        let a = SKNode()
        a.name = "red"
        
        let b = SKNode()
        b.name = "red"
        
        XCTAssertTrue(model.match(a: a, b: b))
        XCTAssertEqual(model.score, 1)
    }
    
    func testMatchDifferentName() throws {
        
        let a = SKNode()
        a.name = "red"
        
        let b = SKNode()
        b.name = "blue"
        
        XCTAssertFalse(model.match(a: a, b: b))
        XCTAssertEqual(model.score, 0)
    }
    
    func testMatchRepeatedPair() throws {
        
        let a = SKNode()
        a.name = "red"
        
        let b1 = SKNode()
        b1.name = "red"
        
        let b2 = SKNode()
        b2.name = "red"
        
        XCTAssertTrue(model.match(a: a, b: b1))
        XCTAssertEqual(model.score, 1)
        
        XCTAssertFalse(model.match(a: a, b: b1))
        XCTAssertEqual(model.score, 1)
        
        XCTAssertTrue(model.match(a: a, b: b2))
        XCTAssertEqual(model.score, 2)
    }
    
    func testFinish() throws {
        
        XCTAssertTrue(model.isPlaying)
        model.finish()
        XCTAssertFalse(model.isPlaying)
    }
    
    func testUpdateColor() throws {

        var color: UIColor
        
        repeat {
            color = model.color
            model.updateColor()
        } while color == model.color
        
        XCTAssertNotEqual(model.color, color)
    }

}
