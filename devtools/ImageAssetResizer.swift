////
////  ImageAssetResizer.swift
////  moonshot
////
////  Created by Adam on 14/05/2026.
////
//
//import SwiftUI
//import UIKit
//
//struct ImageAssetResizer: View {
//
//    @EnvironmentObject var spaceDataStore: SpaceDataStore
//    // Example input
//    
//    // Width for resized images
//    @State var outputLocation: String = ""
//    @State private var outputWidth: Int = 600
//    @State private var outputSuffix: String = ""
//    @State var assetNames: [String] = []
//    var body: some View {
//        NavigationStack{
//            VStack(spacing: 20) {
//                
//                
//                
//                Text("Choose assets")
//                HStack{
//                    Button("Astronauts"){
//                        // setlect astronauts from cat
//                        assetNames = spaceDataStore.astronauts.keys.map {$0}
//                    }
//                    Button("expeditionPatches"){
//                        // setlect astronauts from cat
//                        assetNames = []
//                        for expedition in spaceDataStore.expeditions{
//                            assetNames.append(expedition.value.name)
//                        }
//                    }
//                    Button("missionPatches"){
//                        // setlect astronauts from cat
//                        assetNames = []
//                        for mission in spaceDataStore.missions{
//                            assetNames.append(mission.name)
//                        }
//                    }
//                    Button("Spacecraft"){
//                        assetNames = []
//                        for spaceship in spaceDataStore.spacecrafts{
//                            assetNames.append(spaceship.key)
//                        }
//                    }
//                    
//                }
//
//                if assetNames != []{
//                    Text("\(assetNames.count) items found")
//                }
//                
//                HStack {
//                    Text("Output Width:")
//                    
//                    TextField("Width", value: $outputWidth, format: .number)
//                        .textFieldStyle(.roundedBorder)
//                        .frame(width: 120)
//                }
//                HStack {
//                    Text("Suffix: ")
//                    TextField("Suffix", text: $outputSuffix)
//                        .textFieldStyle(.roundedBorder)
//                        .frame(width: 120)
//                }
//                
//                Button("Resize Images") {
//                    outputLocation = resizeImages(
//                        assetNames: assetNames,
//                        outputWidth: outputWidth
//                    )
//                    
//                }
//                if (outputLocation != ""){
//                    Text(outputLocation)
//                    
//                }
//            }.navigationTitle("Resize Asset Images")
//        }
//        .padding()
//    }
//    // MARK: - Main Logic
//    
//    func resizeImages(
//        assetNames: [String],
//        outputWidth: Int
//    ) -> String {
//        
//        // Change this to wherever you want exported files
//        let OUTPUT_PATH = FileManager.default.temporaryDirectory.appendingPathComponent("/ResizedAssets")
//        
//        // Create folder if needed
//        try? FileManager.default.createDirectory(
//            at: OUTPUT_PATH,
//            withIntermediateDirectories: true
//        )
//        
//        for assetName in assetNames {
//            
//            resizeAndExportImage(
//                assetName: assetName,
//                outputWidth: outputWidth,
//                outputFolder: OUTPUT_PATH
//            )
//        }
//        
//        print("Finished exporting resized images.")
//        return OUTPUT_PATH.absoluteString
//    }
//    
//    // MARK: - Resize + Export
//    func resizeAndExportImage(
//        assetName: String,
//        outputWidth: Int,
//        outputFolder: URL
//    ) {
//        
//        guard let image = UIImage(named: assetName) else {
//            print("Could not load asset: \(assetName)")
//            return
//        }
//        
//        let originalSize = image.size
//        
//        let scale = CGFloat(outputWidth) / originalSize.width
//        let newHeight = originalSize.height * scale
//        
//        let newSize = CGSize(
//            width: CGFloat(outputWidth),
//            height: newHeight
//        )
//        
//        let renderer = UIGraphicsImageRenderer(size: newSize)
//        
//        let resizedImage = renderer.image { _ in
//            image.draw(in: CGRect(origin: .zero, size: newSize))
//        }
//        
//        // Detect original extension
//        // Defaulting to png if unknown
//        let fileExtension = detectOriginalExtension(assetName: assetName)
//        
//        let outputFileName =
//        "\(assetName)_\(outputSuffix).\(fileExtension)"
//        
//        let outputURL = outputFolder.appendingPathComponent(outputFileName)
//        
//        do {
//            
//            let data: Data?
//            
//            switch fileExtension.lowercased() {
//            case "jpg", "jpeg":
//                data = resizedImage.jpegData(compressionQuality: 1.0)
//                
//            default:
//                data = resizedImage.pngData()
//            }
//            
//            guard let imageData = data else {
//                print("Failed to generate image data for \(assetName)")
//                return
//            }
//            
//            try imageData.write(to: outputURL)
//            
//            print("Exported: \(outputURL.path)")
//            
//        } catch {
//            print("Failed exporting \(assetName): \(error)")
//        }
//    }
//    
//    // MARK: - Extension Detection
//    
//    func detectOriginalExtension(assetName: String) -> String {
//        
//        // If all your assets are PNGs, return "png"
//        // Asset catalogs don't preserve extensions directly,
//        // so this is mainly for naming consistency.
//        
//        return "png"
//    }
//}
//
//#Preview {
//    let previewStore = SpaceDataStore()
//    ImageAssetResizer().environmentObject(previewStore)
//}
//
//
