///// a builder to make patches for Soyuz missions : uncomment the entire file
//////
////  patchBuilder.swift
////  moonshot
////
////  Created by Adam on 08/05/2026.
////
//
//
//import SwiftUI
//
//struct BottomArcText: View {
//    var inputText: String
//    var text: Array<Character> {
//        Array(
//            inputText.reversed()
//        )
//    }
//    let radius: CGFloat
//    var body: some View {
//
//        ZStack {
//            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
//                let angleStep = 22.0
//                let totalAngle = angleStep * Double(text.count - 1)
//
//                // Center text on bottom (180°)
//                let angle = Double(index) * angleStep - totalAngle / 2 + 90
//
//                Text(String(character))
//                    .rotationEffect(.degrees(angle - 90))
//                    .position(
//                        x: radius + cos(angle * .pi / 180) * radius,
//                        y: radius + sin(angle * .pi / 180) * radius
//                    ).font(.system(size: 70).bold())
//            }
//        }
//        .frame(width: radius * 2, height: radius * 2)
//    }
//}
//struct MissionPatchView: View {
//    let program: String
//    let flight: String
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(lineWidth: 3)
//            BottomArcText(inputText: program, radius: 120)
////            Text(program)
////                .font(.largeTitle)
////                .foregroundStyle(.gray)
//
//            Text(
//                flight.replacing("\(program) ", with:"")
//            )
//            .font(.system(size: 80))
////                .offset(y: 30)
//        }
//        .frame(width: 300, height: 300)
//    }
//}
//
//struct rendererView: View{
//    @Environment(\.displayScale) var displayScale
//    @State var testlocation: String = ""
//    let program: String
//    let flight: String
//    var body: some View{
//        VStack{
//            Text(testlocation)
//        }
//        .onAppear {
//            runSave()
//        }
//    }
//    
//    func renderPatch(program: String, flight: String) -> UIImage {
//        @Environment(\.displayScale) var displayScale
//        let renderer = ImageRenderer(
//            content: MissionPatchView(
//                program: program,
//                flight: flight
//            )
//        )
//        renderer.scale = displayScale
//        return renderer.uiImage ?? UIImage()
//    }
//    
//    func saveImage(_ image: UIImage, named name: String)  throws -> String {
//        guard let data = image.pngData() else { return ""}
//        
//        let url = FileManager.default
//            .urls(for: .documentDirectory, in: .userDomainMask)[0]
//            .appendingPathComponent("\(name).png")
//        
//        try data.write(to: url)
//        return String(url.absoluteString)
//    }
//
//    func runSave() {
//        do {
//            let outputPath = try saveImage(
//                renderPatch(program: program, flight: flight),
//                named: flight
//            )
//                testlocation = outputPath
//        		print(outputPath)
//        } catch {
//            testlocation = "Error"
//        }
//    }
//}
//
//#Preview {
//        rendererView(program: "Союз", flight: "Союз TMA-22")
//}
