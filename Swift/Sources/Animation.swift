import CoreGraphics
import CoreMedia
import Foundation

public struct Animation {
    private let animation: AnimationWrapper

    public var width: Int {
        return animation.width
    }

    public var height: Int {
        return animation.height
    }

    public var numberOfFrames: Int {
        return animation.numberOfFrames
    }

    public var totalDuration: CMTime {
        return animation.totalDuration
    }

    public var framesDuration: CMTime {
        return animation.framesDuration
    }

    private init(animation: AnimationWrapper) {
        self.animation = animation
    }

    internal func render(frameWithIndex frameIndex: Int, in context: CGContext) {
        // it's ok to force unwrap `context.data`. See its docs for details.
        let buffer = context.data!.bindMemory(
            to: UInt32.self,
            capacity: context.height * context.bytesPerRow / MemoryLayout<UInt32>.size
        )

        animation.render(
            frameIndex: frameIndex,
            buffer: buffer,
            width: context.width,
            height: context.height,
            bytesPerRow: context.bytesPerRow
        )
    }
}

public extension Animation {
    init?(data: Data, gradientRecoloringMap: [String: String]) {
        guard let animation = AnimationWrapper(data: data, gradientRecoloringMap: .init(hexColors: gradientRecoloringMap)) else {
            return nil
        }

        self.init(animation: animation)
    }

    init?(string: String, gradientRecoloringMap: [String: String]) {
        guard let animation = AnimationWrapper(string: string, gradientRecoloringMap: .init(hexColors: gradientRecoloringMap)) else {
            return nil
        }

        self.init(animation: animation)
    }
}

extension Dictionary where Key == Color, Value == Color {
    init(hexColors: [String: String]) {
        let colorPairs = hexColors.compactMap { (hex1, hex2) -> (Color, Color)? in
            guard let color1 = Color(hex: hex1), let color2 = Color(hex: hex2) else {
                return nil
            }

            return (color1, color2)
        }

        self = Dictionary(colorPairs, uniquingKeysWith: { $1 })
    }
}
