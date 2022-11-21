import Foundation
import XCTest
@testable import slottie

final class ColorTests: XCTestCase {
    private let validHexValues = [
        "#000000",
        "#7C7FEB",
        "#FFFFFF"
    ]

    private let expectedColors = [
        Color(red: 0, green: 0, blue: 0),
        Color(red: 124, green: 127, blue: 235),
        Color(red: 255, green: 255, blue: 255)
    ]

    func testDecodeHexColor_WhenUppercaseLetters_DecodesColor() {
        let hexValues = validHexValues.map { $0.uppercased() }

        zip(hexValues, expectedColors).forEach { (hex, expectedColor) in
            let color = Color(hex: hex)
            XCTAssertEqual(color, expectedColor)
        }
    }

    func testDecodeHexColor_WhenLowercaseLetters_DecodesColor() {
        let hexValues = validHexValues.map { $0.lowercased() }

        zip(hexValues, expectedColors).forEach { (hex, expectedColor) in
            let color = Color(hex: hex)
            XCTAssertEqual(color, expectedColor)
        }
    }

    func testDecodeHex_WhenShortFormHex_DecodesColor() {
        let shortFormHexValues = [
            "#000",
            "#7Ca",
            "#FFF"
        ]

        let expectedColors = [
            Color(red: 0, green: 0, blue: 0),
            Color(red: 119, green: 204, blue: 170),
            Color(red: 255, green: 255, blue: 255)
        ]

        zip(shortFormHexValues, expectedColors).forEach { (hex, expectedColor) in
            let color = Color(hex: hex)
            XCTAssertEqual(color, expectedColor)
        }
    }
}
