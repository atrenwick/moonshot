//
//  tsvIntegratorView.swift
//  moonshot
//
//  Created by Adam on 11/05/2026.
//

import SwiftUI
import TabularData

struct tsvIntegratorView: View {
    @State var returnedObject: String = ""
    @State var df: DataFrame = DataFrame()
    @State var jsonString: String = ""
    @State var runProgramFilter: Bool = false
    var body: some View {
        let astronautFile = "/Users/Adam/Downloads/T/astro.tsv"
        let missionFile = "/Users/Adam/Downloads/T/missions.tsv"
            
            VStack {
                HStack{
                Button("Add astronauts"){
                    df = parseStep1(targetFile: astronautFile)
                    //                returnedObject = parseFromTSV()
                }
               Button("Add missions"){
                        df = parseStep1(targetFile: missionFile)
                        runProgramFilter = true
                        //                returnedObject = parseFromTSV()
                    }
                }
                
                Text("df rows = \(df.rows.count)")
                Text("df cols = \(df.columns.count)")
                Button("Convert to JSON"){
                    jsonString = dfToJson(df: df)
                }
                Text("JSONString length = \(jsonString.count)")
                //            Text(String(cleanedLines.count))
                //            ForEach(cleanedLines[0]){chunk in
                //                Text(String(chunk))
                //            }
            }

    }
    func parseStep1(targetFile: String) -> DataFrame {
        var cleanedLines: [String] = []
        var df: DataFrame = DataFrame()
        do {
            let url = URL(fileURLWithPath: targetFile)
            let raw = try String(contentsOf: url)
            let lines = raw.components(separatedBy: .newlines)
            var headerCaptured = false
            for line in lines {
                if line.isEmpty { continue }
                if line.hasPrefix("#") {
                    if !headerCaptured {
                        // First # line = headers
                        let header = String(line.dropFirst()).trimmingCharacters(in: .whitespaces)

                        cleanedLines.append(header)
                        headerCaptured = true
                    }
                    // Skip all subsequent # lines
                    continue
                }
                if line.contains("\tAXIOM\t") == false &&  line.contains("\tX-15\t") == false && line.contains("\tBLOR\t") == false && line.contains("\tVG\t") == false && line.contains("\tSCL\t") == false {
                    cleanedLines.append(line)
                }
            }
            
            let cleanedTSV = cleanedLines.joined(separator: "\n")
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("cleaned.tsv")
            try cleanedTSV.write(to: tempURL, atomically: true, encoding: .utf8)
            // Load DataFrame
            df = try DataFrame(
                contentsOfCSVFile: tempURL,
                options: .init(delimiter: "\t")
            )
//            print(df)
            
        }
        catch {
            print("Error")
        }
        return df
    }
    // option 1 is to clean before sending json to decoder ; option 2 is to clean on decoding_out
    func cleanField(_ value: String) -> String{
        value
            .replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: #" {2,}"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    func dfToJson(df: DataFrame) -> String{
        var jsonString: String = ""
        do{
            // Convert rows to dictionaries
                var rows: [[String: Any]] = []
                for row in df.rows {
                    var dict: [String: Any] = [:]
                    for column in df.columns {
                        let name = column.name
                        dict[name] = row[name]
                    }
                    rows.append(dict)
                }
                // Convert to JSON
                let outputfilename = FileManager.default.temporaryDirectory.appendingPathComponent("tempjsonastro.json")
                
                let jsonData = try JSONSerialization.data(
                    withJSONObject: rows,
                    options: [.prettyPrinted]
                )
                jsonString = String(data: jsonData, encoding: .utf8)!
                print(outputfilename)
//            print(jsonString)
            try jsonString.write(to: outputfilename, atomically: true, encoding: .utf8)
                    
        }
        catch{
            print("Error")
            jsonString = "Error"
        }
        
        return jsonString
    }
    
//    func printJSON(jsonString: String) -> String {
//        
//    }
    
}

#Preview {
    tsvIntegratorView()
}
