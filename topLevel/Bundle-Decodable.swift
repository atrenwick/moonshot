//
//  Bundle-Decodable.swift
//  moonshot
//
//  Created by Adam on 13/04/2026.
//

import Foundation
import libxml2


// this extension does the same as the one down the bottom, but uses generics :: T replaces Type of thing, and we specify conformity needed, but note that in the view where the func is called, swift will protest that generic param T could not be inferred, IF let declaration didn't specify type
//
extension Bundle {
    
    func loadText(_ file: String, format: String) -> String {
        let normalizedText: String
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in the bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file)")
        }
        guard let text = String(data: data, encoding: .utf8) else {
            fatalError("Failed to decode \(file) as UTF-8 text")
        }
        // BBEdit yields texts with tab = 4 spaces so send to \t here
        if format == "conllu" {
            normalizedText = text.replacingOccurrences(
                of: "  +", with: "\t", options: .regularExpression)
        } else {
            normalizedText = text
        }

        return normalizedText
    }
    
    func decode<T: Codable>(_ file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in the bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file)")
        }

        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
    
        do {
            let localData = Data(data)
            return try decoder.decode(T.self, from: localData)
//            return try decoder.decode(T.self, from: data )
            
        } catch DecodingError.keyNotFound(let key, let context){
            fatalError("Failed to decode \(file) from bundle due to missing key : \(key.stringValue)) - \(context.debugDescription)")
            do {
                let _ = try JSONSerialization.jsonObject(with: data)
            }
            catch {
                printJSONError(error)
            }

        } catch DecodingError.typeMismatch(_, let context){
            print("📍 Coding path:", context.codingPath)
            print("📄 Debug:", context.debugDescription)
            fatalError("Failed to decode file \(file) due to type mismatch : - \(context.codingPath) :: \(context.debugDescription)")
            do {
                let _ = try JSONSerialization.jsonObject(with: data)
            }
            catch {
                printJSONError(error)
            }
            
            /////
        } catch DecodingError.valueNotFound(let type, let context){
            fatalError("Failed to decode file \(file) due to missing \(type )value : - \(context.debugDescription)")
            do {
                let _ = try JSONSerialization.jsonObject(with: data)
            }
            catch {
                printJSONError(error)
            }
        } catch DecodingError.dataCorrupted(let context){
            fatalError("Failed to decode file \(file) : the file is not valid JSON:: \(context)")
            do {
                let _ = try JSONSerialization.jsonObject(with: data)
            }
            catch {
                printJSONError(error)
            }
        } catch {
            fatalError("Failed to decode \(file) : \(error.localizedDescription)")
        }
    }
    
    func decodeXML(_ file: String) -> xmlDocPtr {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let doc = xmlReadFile(url.path, nil, 0) else {
            fatalError("Failed to parse \(file) as XML.")
        }
        return doc
    }

}

func printJSONError(_ error: Error) {
    let nsError = error as NSError

    print("Domain:", nsError.domain)
    print("Code:", nsError.code)

    if let debug = nsError.userInfo["NSDebugDescription"] {
        print("Debug:", debug)
    }

    if let path = nsError.userInfo["NSJSONSerializationErrorIndex"] {
        print("Index:", path)
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
