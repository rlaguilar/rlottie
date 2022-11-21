import CoreMedia
import Foundation

import rlottie

class AnimationWrapper {
    let animation: OpaquePointer

    let numberOfFrames: Int
    let framesDuration: CMTime
    let totalDuration: CMTime
    let width: Int
    let height: Int

    let gradientRecoloringMap: [Color: Color]

    private init?(animation: OpaquePointer, gradientRecoloringMap: [Color: Color]) {
        self.animation = animation
        self.gradientRecoloringMap = gradientRecoloringMap

        numberOfFrames = lottie_animation_get_totalframe(animation)

        guard numberOfFrames > 0 else {
            return nil
        }

        let totalDuration = lottie_animation_get_duration(animation)
        self.totalDuration = CMTime(seconds: totalDuration, preferredTimescale: 600)
        framesDuration = CMTime(seconds: totalDuration / Double(numberOfFrames), preferredTimescale: 600)

        var width = 0
        var height = 0
        lottie_animation_get_size(animation, &width, &height)
        self.width = width
        self.height = height
    }

    convenience init?(data: Data, gradientRecoloringMap: [Color: Color]) {
        lottie_configure_model_cache_size(0)

        guard let animation = data.withUnsafeBytes({ bufferPointer in
            lottie_animation_from_data(bufferPointer.bindMemory(to: CChar.self).baseAddress, "", "")
        }) else {
            return nil
        }

        self.init(animation: animation, gradientRecoloringMap: gradientRecoloringMap)
    }

    convenience init?(string: String, gradientRecoloringMap: [Color: Color]) {
        lottie_configure_model_cache_size(0)

        guard let cString = string.cString(using: .utf8),
              let animation = lottie_animation_from_data(cString, "", "") else {
            return nil
        }

        self.init(animation: animation, gradientRecoloringMap: gradientRecoloringMap)
    }

    func render(
        frameIndex: Int,
        buffer: UnsafeMutablePointer<UInt32>,
        width: Int,
        height: Int,
        bytesPerRow: Int
    ) {
        if !gradientRecoloringMap.isEmpty {
            lottie_animation_render_tree(animation, frameIndex, width, height).pointee
                .recolorGradients(colorMap: gradientRecoloringMap)
        }

        lottie_animation_render(animation, frameIndex, buffer, width, height, bytesPerRow)
    }

    deinit {
        lottie_animation_destroy(animation)
    }
}

private extension LOTLayerNode {
    func recolorGradients(colorMap: [Color: Color]) {
        for index in 0 ..< mNodeList.size {
            if let node = mNodeList.ptr.advanced(by: index).pointee {
                node.pointee.recolorGradients(colorMap: colorMap)
            }
        }

        for index in 0 ..< mLayerList.size {
            if let layer = mLayerList.ptr.advanced(by: index).pointee {
                layer.pointee.recolorGradients(colorMap: colorMap)
            }
        }
    }
}

private extension LOTNode {
    func recolorGradients(colorMap: [Color: Color]) {
        guard mGradient.stopCount > 0 else {
            return
        }

        for index in 0 ..< mGradient.stopCount {
            let stop = mGradient.stopPtr.advanced(by: index)
            let stopColor = Color(red: Int(stop.pointee.r), green: Int(stop.pointee.g), blue: Int(stop.pointee.b))

            if let replacement = colorMap[stopColor] {
                stop.pointee.r = UInt8(replacement.red)
                stop.pointee.g = UInt8(replacement.green)
                stop.pointee.b = UInt8(replacement.blue)
            }
        }
    }
}
