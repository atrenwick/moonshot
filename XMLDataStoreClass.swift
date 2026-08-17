//
//  XMLDataStoreClass.swift
//  
//
//  Created by Adam on 16/08/2026.
//

import Foundation
import libxml2
import Combine

// class for xml
// separate class, observable, published var inside, to facilitate
// getting ,manipulating and destroying XMLdocs :: for these
// memory management is NOT automatic


  

class XMLStore: ObservableObject {
    // create a private var called doc, optional, of type xmlDocument pointer
    // xmlDocPtr is a raw C pointer, thus no Equatable protocol conformance conformant
    // -> so can't `diff` to update views easily
    // it will be the behind the scenes object that will be manipulated
    // For viewing, a string representation of it will be used : xmlString
    // To make the latest string representation of the content of the behind-the-scenes object, the class method `refreshString` is used to take the current form of behind-the-scenes XMLdoc and make a front-of-house view of its current content
    private var docs: [DocID: xmlDocPtr] = [:]
    @Published var xmlStrings: [DocID: String] = [:]
    @Published var jsonStrings: [DocID: String] = [:]
    
    // initialiser for this class, loading specified xml from path with xmlReadFile method added in bundle-decodable extension
    
    init() {
          print("Instantiating class")
          for id in DocID.allCases {
              guard let url = Bundle.main.url(forResource: id.filename, withExtension: nil),
                    let doc = xmlReadFile(url.path, nil, 0) else {
                  fatalError("Failed to load/parse \(id.filename)")
              }
              docs[id] = doc
          }
          for id in docs.keys {
              refreshString(id)
          }
        print("Class instantiated")
      }
    // swiftside only helper
    func annotateParagraphs(_ name: DocID) {
        guard let doc = docs[name], let root = xmlDocGetRootElement(doc) else { return }
//        print("xmlString is \(xmlString)")
        var index = 1
        var node = root.pointee.children
        while node != nil {
            if let n = node, String(cString: n.pointee.name) == "p" {
                xmlSetProp(n, "n", "\(index)")
                index += 1
            }
            node = node?.pointee.next
        }

        refreshString(name)
        print("\(name) updated")
    }
    // swiftside only helper
    private func refreshString(_ name: DocID) {
        /*
         xmlDocDumpMemory happens in C
         in Swift, if we pass a buffer to a function, the function gets a copy of the buffer's content
         --> it can't reach through and change the variable
         BUT `xmlDocDumpMemory` happens in C, wheer `&tempXML` passes  actual address of the variable & the value, so these can be modified
         +----------+------------------+------------------------------+----------------------------+----------------------------+
         | Variable | Variable's own   | BEFORE call                  | DURING call                | AFTER call                 |
         |          | address (fixed)  | (value stored there)         | (what happens)             | (value stored there)       |
         +----------+------------------+------------------------------+----------------------------+----------------------------+
         | doc      | address0         | address20001                 | unchanged -- doc is passed | address20001               |
         |          |                  | (points to the already-      | as a plain argument, not   | (unchanged; doc was never  |
         |          |                  | parsed tree, sitting         | via &, so the function     | passed with & here)        |
         |          |                  | somewhere past address10000) | only READS this value      |                            |
         +----------+------------------+------------------------------+----------------------------+----------------------------+
         | tempXML  | address7         | nil                          | function allocates a fresh | address3                   |
         |          |                  | (points to nothing)          | 1MB chunk (say address3),  | (points to newly-allocated |
         |          |                  |                              | writes serialized XML text | memory holding the         |
         |          |                  |                              | bytes into it, then writes | serialized XML bytes)      |
         |          |                  |                              | address3 into address7,    |                            |
         |          |                  |                              | i.e. into tempXML's storage|                            |
         |          |                  |                              | (possible because &tempXML |                            |
         |          |                  |                              | gave the function address7 |                            |
         |          |                  |                              | itself, not just its value)|                            |
         +----------+------------------+------------------------------+----------------------------+----------------------------+
         | size     | address8         | 0                            | function computes the byte-| 10                         |
         |          |                  |                              | length of the serialized   | (the actual byte count of  |
         |          |                  |                              | text (say 10 bytes) and    | the XML text now sitting   |
         |          |                  |                              | writes that number directly| at address3)               |
         |          |                  |                              | into address8, i.e. into   |                            |
         |          |                  |                              | size's own storage         |                            |
         |          |                  |                              | (possible because &size    |                            |
         |          |                  |                              | gave the function address8 |                            |
         |          |                  |                              | itself, not just its value)|                            |
         +----------+------------------+----------------------------+----------------------------+------------------------------+
         address3 is then released back with xmlFree()
         */
        //make a constant, which has a label doc to make it easy for the human to remember. it's a pointer to an xml tree structure. Check that this thing actually exists, otherwise, bale out.
        guard let doc = docs[name] else { return }
        var tempXML: UnsafeMutablePointer<xmlChar>?
        //get ready to write down a variable which the human wants to label as buffer. it will contain an XML char string (dunno how big yet), or nothing.
        var size: Int32 = 0
        xmlDocDumpMemory(doc, &tempXML, &size)
        // defer actually freeing the memory used the buffer until the refreshString() method finishes running
        defer { xmlFree(tempXML) }
        // if there's actually somethign in the buffer, turn it into a string and assign it to the xml string var
        if let tempXML = tempXML {
            // assign to xmlStrings[name] the Swift string
            // which is made from the C String in the buffer
            xmlStrings[name] = String(cString: tempXML)
        }
    }
    // swiftside only helper
    func getAttr(_ node: xmlNodePtr, _ name: String, namespace: String? = nil) -> String? {
        let cString: UnsafeMutablePointer<xmlChar>?
        if let namespace = namespace {
            cString = xmlGetNsProp(node, name, namespace)
        } else {
            cString = xmlGetProp(node, name)
        }
        guard let cString = cString else { return nil }
        defer { xmlFree(cString) }
        return String(cString: cString)
    }

    // equivalent of xml_to_tei_json
    func xmlToTeiJsonString(_ id: DocID) -> String? {
        guard let doc = docs[id] else { return "error1" }
//        print("guard let1 passed")
        
        guard let context = xmlXPathNewContext(doc) else { return "error2" }
//        print("guard let2 passed")
        defer { xmlXPathFreeContext(context) }


        // Equivalent of matching tei:w, while respecting the emptied
        // tei:teiHeader and tei:head templates from the XSLT
//        let xpath = "//*"
//        let nsResult = xmlXPathRegisterNs(context, "tei", "http://www.tei-c.org/ns/1.0")
//        print("namespace registration result (0 = success): \(nsResult)")
//        guard let result = xmlXPathEvalExpression(xpath, context) else { return "error3" }
//        print("guard let3 passed, result type: \(result.pointee.type.rawValue)")
//        print("nodesetval is nil: \(result.pointee.nodesetval == nil)")
//        if let ns = result.pointee.nodesetval {
//            print("nodeNr: \(ns.pointee.nodeNr)")
//        } else {
//            print("nodesetval genuinely nil despite type == 1")
//        }
//        if let err = xmlGetLastError() {
//            print("libxml2 last error: \(String(cString: err.pointee.message))")
//        } else {
//            print("no libxml2 error logged")
//        }


        // Explicitly set the context node -- libxml2 doesn't default this
        // automatically the way lxml's tree.xpath() does
        guard let root = xmlDocGetRootElement(doc) else { return "error2b" }
        context.pointee.node = root

        xmlXPathRegisterNs(context, "tei", "http://www.tei-c.org/ns/1.0")
        let xpath = "descendant::tei:w[not(ancestor::tei:teiHeader) and not(ancestor::tei:head)]"
        
        guard let result = xmlXPathEvalExpression(xpath, context) else { return "error3" }
//        print("guard let3 passed, result type: \(result.pointee.type.rawValue)")
//        print("nodesetval is nil: \(result.pointee.nodesetval == nil)")
        defer { xmlXPathFreeObject(result) }

        guard let nodeSet = result.pointee.nodesetval else { return "guard let4 failed" }
//        print("guard let4 passed")

        let count = Int(nodeSet.pointee.nodeNr)
        var items: [[String: String]] = []
        for i in 0..<count {
            guard let node = nodeSet.pointee.nodeTab[i] else { continue }

            // "text" field -- equivalent of <xsl:apply-templates/> falling through
            // to the built-in template, which just outputs the node's text content
            let text: String
            if let contentC = xmlNodeGetContent(node) {
                text = String(cString: contentC)
                xmlFree(contentC)
            } else {
                text = ""
            }
            // "id" field -- @xml:id
            let idAttr = getAttr(node, "id", namespace: "http://www.w3.org/XML/1998/namespace") ?? ""

            // "lemme" field -- @lemma, with the first '+' removed if present
            let lemma = getAttr(node, "lemma") ?? ""
            let lemme: String
            if let plusIndex = lemma.firstIndex(of: "+") {
                let before = lemma[lemma.startIndex..<plusIndex]
                let after = lemma[lemma.index(after: plusIndex)...]
                lemme = String(before) + String(after)
            } else {
                lemme = lemma
            }

            // pos-msd fields
            let pos = getAttr(node, "pos") ?? ""
            let msd = getAttr(node, "msd") ?? ""

            items.append([
                "text": text,
                "id": idAttr,
                "lemme": lemme,
                "pdd": pos,
                "msd": msd
            ])
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: items) else { return nil }
//        print("guard let passed")
        // assign to xmlStrings[name] the Swift string which is made from the C String in the buffer
//        print("string set")
        jsonStrings[id] = String(data: jsonData, encoding: .utf8)
        let returnItem = String(data: jsonData, encoding: .utf8)
//        print("string returned")
        return returnItem
    }

    func alignBlock(){
        let iDiv = "123"// placeholder
        let iDivEz = "123"// placeholder
        let i = 2
//        guard let pNode = getTextAParas(from: .a, divID: iDiv) else { return nil }
//            let jsonString = transformParaToCollatexJsonString(pNode, doc: docs[.a]!)
//           fpor para in paras:
//                para_as_dict = getTextAParas()
//                A_toplevelList.append(para_as_dict)
//        guard let pNode2 = getTextBParas(from: .b, divID: iDivEz, n: i) else {return nil}
//            let jsonString2 = transformParaToCollatexJsonString(pNode2, doc: docs[.b]!)
//        }
    }
    
    // alignBlock funciton parts::
    func getTextAParas(from id: DocID, divID: String) -> [String: xmlNodePtr?] {
        
        guard let doc = docs[id] else { return [id.rawString: nil] }
        guard let context = xmlXPathNewContext(doc) else { return [id.rawString: nil] }
        defer { xmlXPathFreeContext(context) }

        guard let root = xmlDocGetRootElement(doc) else { return [id.rawString: nil] }
        context.pointee.node = root

        let xpath = "//text//div[@xml:id='\(divID)']/p"
        guard let result = xmlXPathEvalExpression(xpath, context) else { return [id.rawString: nil] }
        defer { xmlXPathFreeObject(result) }

        guard let nodeSet = result.pointee.nodesetval, nodeSet.pointee.nodeNr > 0 else { return [id.rawString: nil] }
        let returnDict: [String: xmlNodePtr?] = [id.rawString: nodeSet.pointee.nodeTab[0]]
        //return nodeSet.pointee.nodeTab[0]
        return returnDict
    }
    // get para for textB
    //Second lookup (file 2): get the p block via iDivEz and n
    func getTextBParas(from id: DocID, divID: String, n: Int) -> [String: xmlNodePtr?] {
        //part of AlignBlock
        guard let doc = docs[id] else { return [id.rawString: nil] }
        guard let context = xmlXPathNewContext(doc) else { return [id.rawString: nil] }
        defer { xmlXPathFreeContext(context) }

        guard let root = xmlDocGetRootElement(doc) else { return [id.rawString: nil] }
        context.pointee.node = root

        let xpath = "//text//div[@xml:id='\(divID)']/p[@n='\(n)']"
        guard let result = xmlXPathEvalExpression(xpath, context) else { return [id.rawString: nil] }
        defer { xmlXPathFreeObject(result) }

        guard let nodeSet = result.pointee.nodesetval, nodeSet.pointee.nodeNr > 0 else { return [id.rawString: nil] }
        let returnDict: [String: xmlNodePtr?] = [id.rawString: nodeSet.pointee.nodeTab[0]]
        //return nodeSet.pointee.nodeTab[0]
        return returnDict
    }

    func transformParaToCollatexJsonString(_ pNode: xmlNodePtr, doc: xmlDocPtr) -> String? {
        guard let context = xmlXPathNewContext(doc) else { return nil }
        defer { xmlXPathFreeContext(context) }

        // Context node is the specific <p>, not the document root
        context.pointee.node = pNode

        let xpath = "descendant::w"  // or ".//w" -- relative to pNode
        guard let result = xmlXPathEvalExpression(xpath, context) else { return nil }
        defer { xmlXPathFreeObject(result) }

        guard let nodeSet = result.pointee.nodesetval else { return nil }
        let count = Int(nodeSet.pointee.nodeNr)

        var items: [[String: String]] = []
        for i in 0..<count {
            guard let node = nodeSet.pointee.nodeTab[i] else { continue }

            let text: String
            if let contentC = xmlNodeGetContent(node) {
                text = String(cString: contentC)
                xmlFree(contentC)
            } else {
                text = ""
            }

            let idAttr = getAttr(node, "id", namespace: "http://www.w3.org/XML/1998/namespace") ?? ""
            let lemma = getAttr(node, "lemma") ?? ""
            let pos = getAttr(node, "pos") ?? ""
            items.append(["text": text, "i": idAttr, "t": lemma, "pos": pos])
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: items) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }

    // w libxml2, memory is NOT MANAGED AUTOMATICALLY, thus `de-init` to free up memory,
    //using xmlFreeDoc method, when the class is destroyed
    deinit {
        for doc in docs.values {
            xmlFreeDoc(doc)
        }
    }
}
enum Paths: CaseIterable {
    // enum rather than @dataclass from Py :: just need to tweak actual paths pointed to
    
    case outputDir
    case logDir
    case tempDir
    
    var fullString: String {
        switch self {
        case .outputDir: return "x/output/"
        case .tempDir: return "x/temp/"
        case .logDir: return "x/logs/"
        }
    }
}
