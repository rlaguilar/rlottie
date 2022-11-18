import Foundation
import XCTest
@testable import slottie

final class AnimationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let url = Bundle.module.url(forResource: "gradient", withExtension: "json")!
        var data = try Data(contentsOf: url)
        data.append(contentsOf: [0])

        guard let _ = Animation(data: data) else {
            XCTFail()
            return
        }
    }
}
