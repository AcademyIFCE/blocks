import XCTest

@MainActor
final class BlocksUITests: XCTestCase {
    
    func testPlayAndMatch() async throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["DisableColorUpdate"]
        app.launch()
        
        let scene = app.otherElements.containing(.other, identifier: "scene").firstMatch
        let blocks = app.otherElements.matching(identifier: "block")
        let score = app.staticTexts["score"]
        
        XCTAssertEqual(score.label, "0")
        XCTAssertEqual(blocks.count, 0)
        
        scene.tap()
        try await Task.sleep(for: .seconds(1))
        XCTAssertEqual(blocks.count, 1)
        
        scene.tap()
        XCTAssertEqual(blocks.count, 2)
        try await Task.sleep(for: .seconds(1))
        XCTAssertEqual(blocks.count, 0)
        
        XCTAssertEqual(score.label, "1")
    }
    
    func testGameOver() async throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["DisableNodeMatching"]
        app.launch()
        
        let scene = app.otherElements.containing(.other, identifier: "scene").firstMatch
        let blocks = app.otherElements.matching(identifier: "block")
        
        scene.tap()
        
        while blocks.count != 0 {
            try await Task.sleep(for: .seconds(0.5))
            scene.tap()
        }
        
        let label = app.staticTexts["GAME OVER"]
        let button = app.buttons["PLAY AGAIN"]
        
        XCTAssertTrue(label.exists)
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        XCTAssertFalse(label.exists)
        XCTAssertFalse(button.exists)
        
    }
    
}
