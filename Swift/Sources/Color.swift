import Foundation

struct Color: Hashable {
    let red, green, blue: Int
}

extension Color {
    init?(hex: String) {
        switch hex.count {
        case 4:
            let hexWithoutHash = hex.suffix(3)
            let longFormHex = hexWithoutHash.map { "\($0)\($0)" }.joined()
            self.init(hex: "#\(longFormHex)")
        case 7:
            guard let red = Int(hex[1...2], radix: 16),
                  let green = Int(hex[3...4], radix: 16),
                  let blue = Int(hex[5...6], radix: 16) else {
                return nil
            }

            self.init(red: red, green: green, blue: blue)
        default:
            return nil
        }
    }
}

private extension String {
    subscript(_ range: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
}
