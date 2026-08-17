//
//  XMLprocessingView.swift
//  moonshot
//
//  Created by Adam on 15/08/2026.
//

import SwiftUI
import libxml2

enum DocID: CaseIterable {
    case a
    case b
    
    var filename: String {
        switch self {
        case .a: return "xml_test.xml"
        case .b: return "xml_testB.xml"
        }
    }
    
    var rawString: String {
        switch self {
        case .a: return "A"
        case .b: return "B"
        }
    }
}
    

struct XMLprocessingView: View {
    @EnvironmentObject var xmlStore: XMLStore
    @State var returnStringA: String = "notyet loaded"
    @State var returnStringB: String = "notyet loaded"
    var body: some View {
//        Text("Hello")
        ScrollView{
            HStack{
//                Text(xmlStore.jsonStrings[.a] ?? "nil")
                Text(returnStringA)
                //        Text("Hello again")
                Text(returnStringB)
//                Text(xmlStore.jsonStrings[.b] ?? "nil")
            }//        let doc = xmlReadFile(xmlFilePath, nil, }0)
        }
        HStack{
            Button {
                returnStringA = xmlStore.xmlToTeiJsonString(.a) ?? "nope"
            } label: {
                Text("Annotate A")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Button {
                returnStringB = xmlStore.xmlToTeiJsonString(.b) ?? "nope"
            } label: {
                Text("Annotate B")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
        }
        Button {
            for docId in DocID.allCases {
                xmlStore.annotateParagraphs(docId)
            }
        } label: {
            Text("Annotate all")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
        }
    }
}

#Preview {
    let previewStore = XMLStore()
    XMLprocessingView().environmentObject(previewStore)
}

