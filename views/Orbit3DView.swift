//
//  Orbit3DView.swift
//  moonshot
//
//  Created by Adam on 22/06/2026.
//

import SwiftUI
import SceneKit

struct Orbit3DView: UIViewRepresentable {
    
    let altitudeKM: Double
    let inclinationDeg: Double
    
    func makeUIView(context: Context) -> SCNView {
        
        let view = SCNView()
        view.scene = makeScene()
        view.allowsCameraControl = true
        view.backgroundColor = .black
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
    }
    private func makeScene() -> SCNScene {

        let scene = SCNScene()

        //--------------------------------------------------
        // Earth
        //--------------------------------------------------

        let earthRadius: CGFloat = 1.0
        let earth = SCNSphere(radius: earthRadius)
        earth.firstMaterial?.diffuse.contents =
            UIImage(named: "earthTexture")
        let earthNode = SCNNode(geometry: earth)

        scene.rootNode.addChildNode(earthNode)
        if let image = UIImage(named: "earthTexture") {
            print("Loaded Earth texture")
        } else {
            print("FAILED to load Earth texture")
        }
        //--------------------------------------------------
        // Orbit
        //--------------------------------------------------

        let orbitRadius =
            earthRadius * CGFloat((6371.0 + altitudeKM) / 6371.0)
//        let orbitNode = makeOrbitRing(
//            radius: orbitRadius,
//            inclination: inclinationDeg
//        )
        let orbitNode = makeOrbitRing(
            radius: orbitRadius,
            thickness: 0.02,
            inclination: inclinationDeg
        )
        scene.rootNode.addChildNode(orbitNode)

        //--------------------------------------------------
        // Camera

        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 4)
        scene.rootNode.addChildNode(cameraNode)

        //--------------------------------------------------
        // Light

        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(lightNode)

        return scene
    }
    private func makeOrbitRing(
        radius: CGFloat,
        thickness: CGFloat,
        inclination: Double
    ) -> SCNNode {

        let tube = SCNTube(
            innerRadius: radius - thickness,
            outerRadius: radius,
            height: 0.005
        )

        tube.firstMaterial?.diffuse.contents = UIColor.green

        let node = SCNNode(geometry: tube)

        node.eulerAngles.x =
            Float(inclination * .pi / 180.0)

        return node
    }
    
    //    private func makeOrbitRing(
//        radius: CGFloat,
//        inclination: Double
//    ) -> SCNNode {
//        let points = 360
//        var vertices: [SCNVector3] = []
//
//        for n in 0...points {
//            let theta = Double(n) * 2.0 * .pi / Double(points)
//            let x = radius * CGFloat(cos(theta))
//            let y = radius * CGFloat(sin(theta))
//            vertices.append( SCNVector3(x, y, 0) )
//        }
//
//        let source = SCNGeometrySource(vertices: vertices)
//
//        var indices: [Int32] = []
//
//        for i in 0..<points {
//            indices.append(Int32(i))
//            indices.append(Int32(i + 1))
//        }
//
//        let element =
//            SCNGeometryElement(
//                indices: indices,
//                primitiveType: .line
//            )
//
//        let geometry =
//            SCNGeometry(
//                sources: [source],
//                elements: [element]
//            )
//
//        geometry.firstMaterial?.diffuse.contents =
//            UIColor.green
//
//        let node =
//            SCNNode(geometry: geometry)
//
//        node.eulerAngles.x =
//            Float(inclination * .pi / 180.0)
//
//        return node
//    }
}

#Preview {
    Orbit3DView(
        altitudeKM: 550,
        inclinationDeg: 53
    )
}
