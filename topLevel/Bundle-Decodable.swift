//
//  Bundle-Decodable.swift
//  moonshot
//
//  Created by Adam on 13/04/2026.
//

import Foundation


// this extension does the same as the one down the bottom, but uses generics :: T replaces Type of thing, and we specify conformity needed, but note that in the view where the func is called, swift will protest that generic param T could not be inferred, IF let declaration didn't specify type
//
extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate that file in the bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load that file")
        }

        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
    
        do {
            return try decoder.decode(T.self, from: data )
            
        } catch DecodingError.keyNotFound(let key, let context){
            fatalError("Failed to decode \(file) from bundle due to missing key : \(key.stringValue)) - \(context.debugDescription)")
            
        } catch DecodingError.typeMismatch(_, let context){
            fatalError("Failed to decode file \(file) due to type mismatch : - \(context.debugDescription)")
            
        } catch DecodingError.valueNotFound(let type, let context){
            fatalError("Failed to decode file \(file) due to missing \(type )value : - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_){
            fatalError("Failed to decode file \(file) : the file is not valid JSON:: ")
        } catch {
            fatalError("Failed to decode \(file) : \(error.localizedDescription)")
        }
    }
}


// make a bundle extension to retyrn list of dicts
//extension Bundle {
//    func decodeExplicit(_ file: String) -> [String: Astronaut] {
//        
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Failed to locate that file in the bundle")
//        }
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load that file")
//        }
//
//        let decoder = JSONDecoder()
//    
//        do {
//            return try decoder.decode([String: Astronaut].self, from: data )
//            
//        } catch DecodingError.keyNotFound(let key, let context){
//            fatalError("Failed to decode \(file) from bundle due to missing key : \(key.stringValue)) - \(context.debugDescription)")
//            
//        } catch DecodingError.typeMismatch(_, let context){
//            fatalError("Failed to decode file \(file) due to type mismatch : - \(context.debugDescription)")
//            
//        } catch DecodingError.valueNotFound(let type, let context){
//            fatalError("Failed to decode file \(file) due to missing \(type )value : - \(context.debugDescription)")
//        } catch DecodingError.dataCorrupted(_){
//            fatalError("Failed to decode file \(file) : the file is not valid JSON")
//        } catch {
//            fatalError("Failed to decode \(file) : \(error.localizedDescription)")
//        }
//    }
//}
