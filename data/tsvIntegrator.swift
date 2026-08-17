//
//  tsvIntegrator.swift
//  moonshot
//
//  Created by Adam on 11/05/2026.
//

import Foundation
import SwiftUI
import TabularData
let missionTSVsource = "https://planet4589.org/space/astro/tsv/missions.tsv"
let astronautTSVsource = "https://planet4589.org/space/astro/tsv/astro.tsv"

func parseFromTSV() -> String {
    var returnObject: String = ""
    let url = URL(fileURLWithPath: "/Users/Adam/Downloads/T/astro.tsv")
    
    do {
        let df = try DataFrame(
            contentsOfCSVFile: url,
            options: .init(delimiter: "\t")
        )
        
        print(df)
        
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
        let jsonData = try JSONSerialization.data(
            withJSONObject: rows,
            options: [.prettyPrinted]
        )
        
        let jsonString = String(data: jsonData, encoding: .utf8)!
        returnObject = jsonString
        
    } catch {
        print(error)
        returnObject = "errorrrr"
    }
    return returnObject
}
