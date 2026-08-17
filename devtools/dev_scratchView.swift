//
//  dev_scratchView.swift
//  moonshot
//
//  Created by Adam on 25/05/2026.
//

import SwiftUI
import PDFKit


import NaturalLanguage

struct TokenSpan {
    let token: String
    let range: Range<String.Index>
}

struct TaggedToken {
    let token: String
    let range: Range<String.Index>
    
    var lexicalClass: String = "_"
    var lemma: String = "_"
    var nameType: String = "_"
}

struct dev_scratchView: View {

    
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var textOut: String = ""
    @State var status: String = "Not yet run"
    @State var returnItem: (String, [String]) = ("",[])
    @State var message1: String = ""
    @State var messageL: String = ""
    @State var message2: String = ""
    @State var message3: String = ""
    @State var message4: String = ""
    @State var message5: String = ""
    @State var message6: String = ""
    @State var message7: String = ""
    @State var message8: String = ""
//    let thisURL = "https://spacepresskit.wordpress.com/wp-content/uploads/2012/08/sts-1.pdf"
    let myURLraw = "/Volumes/ThetaEight/cc/2017/LREC-2026.pdf"

    var mission: Mission { spaceDataStore.missions.filter {$0.displayName.contains("STS")}[10]}

    
    var body: some View {
        Button{
            if mission.urlPressKitRaw != "" {
                Task{
                    do {
                        let start = CFAbsoluteTimeGetCurrent()
                        let mySource = ";std"
                        
                        if mySource == "std"{
                            textOut = try await extractPDFText(from: mission.urlPressKitRaw ?? "error")}
                        else {
                            status = "running alt step1"
                            guard let pdf = PDFDocument(url: myURL) else {return ""}
                            var fullText = ""
                            status = "running alt step2"

                            for pageIndex in 0..<pdf.pageCount {
                                guard let page = pdf.page(at: pageIndex),
                                      let pageText = page.string else {
                                    continue
                                } // guard
                                fullText += pageText + "\n"
                            } // pages in pdf
                        } //else
                        
                        textOut = try await extractPDFText(from: mission.urlPressKitRaw ?? "error")
                        
                        let end = CFAbsoluteTimeGetCurrent()
                        let delta = end - start
                        let unitsPerSecond = Double(textOut.split(separator: " ").count) / delta
                        message1 = String("extractTime: \(delta)")
                        message2 = String("tok extract/sec: \(unitsPerSecond)")
                        
                        
                        let start2 = CFAbsoluteTimeGetCurrent()
                        returnItem = getTextAndTokens(inputText: textOut, lang: "en")
                        let end2 = CFAbsoluteTimeGetCurrent()
                        let delta2 = end2 - start2
                        let unitsPerSecond2 = Double(returnItem.1.count) / delta2
                        messageL = String(returnItem.1.count)
                        message3 = String("tokenise time: \(delta2)")
                        message4 = String("tokenisation speed/sec: \(unitsPerSecond2)")
                        
                        
                        let start3 = CFAbsoluteTimeGetCurrent()
                        let taggedTokens: [TaggedToken] = analyzeText(returnItem.0)
                        let end3 = CFAbsoluteTimeGetCurrent()
                        let delta3 = end3 - start3
                        let step3speed = Double(returnItem.1.count) / delta3
                        message5 = String("tag time: \(delta3)")
                        message6 = String("tag speed : \(step3speed)")
                        
                        
                        let start4 = CFAbsoluteTimeGetCurrent()
                        
                        let annotatedStuff = runWithCustom(text: run_tokeniser_core(thisText: textOut, lang: "en", hyphen_join_value: false))
                        let end4 = CFAbsoluteTimeGetCurrent()
                        let delta4 = end4 - start4
                        let step4speed = Double(returnItem.1.count) / delta4
                        message7 = String("tag time: \(delta4)")
                        message8 = String("tag speed : \(step4speed)")
                        status = "Success"
                        
                    } // do
                    catch {
                        textOut = "Error"
                        status = "Error"
                    } //catch
                return "error"
                } // task
            } // if has url
        
        } //button
        label: {
            VStack{
                Text("Status: \(status)")
//                TextEditor(text: ($returnItem.0))
                Text("PDF getting").foregroundStyle(.black)
                Text(message1)
                Text(message2)

                Text("tokenising").foregroundStyle(.black)
                Text(messageL)
                Text(message3)
                Text(message4)
                Text("tagging_tokInternal").foregroundStyle(.black)
                Text(message5)
                Text(message6)

                Text("taggingTokCustom").foregroundStyle(.black)
                Text(message7)
                Text(message8)

            }
        }
//        VStack{
//            Text("count spacewalkers")
//        }
    }


    func extractPDFText(from rawURLstring: String) async throws -> String {
        
        guard let remoteURL = URL(string: rawURLstring) else {
            throw URLError(.badURL)
        }
        
        let (localURL, _) = try await URLSession.shared.download(from: remoteURL)
        
        guard let pdf = PDFDocument(url: localURL) else {return ""}
        var fullText = ""
        
        for pageIndex in 0..<pdf.pageCount {
            guard let page = pdf.page(at: pageIndex),
                  let pageText = page.string else {
                continue
            }
            fullText += pageText + "\n"
        }
        return fullText
    }
    
    func getTextAndTokens(inputText: String, lang: String)->(String, [String]){
        
        let outputText: String = run_tokeniser_core(thisText: inputText, lang: lang, hyphen_join_value: false)
        let outputTokenList: [String] = getTokensFromText(inputText: outputText)

        
        let returnItem = (outputText, outputTokenList)
        return returnItem
    }
    

    func analyzeText(_ text: String) -> [TaggedToken] {
        
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .lemma, .nameType])
        tagger.string = text
        
        let fullRange = text.startIndex..<text.endIndex
        
        var tokens: [TaggedToken] = []
        
        tagger.enumerateTags(
            in: fullRange,
            unit: .word,
            scheme: .lexicalClass,
            options: [.omitWhitespace, .omitPunctuation]
        ) { lexicalClass, tokenRange in
            
            let tokenString = String(text[tokenRange])
            
            // Build base token (like Stanza "Word")
            var token = TaggedToken(
                token: tokenString,
                range: tokenRange,
                lexicalClass: lexicalClass?.rawValue ?? "_"
            )
            
            // ---- enrich in same pass ----
            
            let lemmaResult = tagger.tag(
                at: tokenRange.lowerBound,
                unit: .word,
                scheme: .lemma
            )
            token.lemma = lemmaResult.0?.rawValue ?? "_"
            
            let nameResult = tagger.tag(
                at: tokenRange.lowerBound,
                unit: .word,
                scheme: .nameType
            )
            token.nameType = nameResult.0?.rawValue ?? "_"
            
            tokens.append(token)
            return true
        }
        
        return tokens
        
    }
    func manualTokenise(_ text: String) -> [TokenSpan] {
        var spans: [TokenSpan] = []
        var position = text.startIndex

        for token in text.split(separator: " ") {
            guard let range = text.range(of: token, range: position..<text.endIndex) else {
                continue
            }
            spans.append(TokenSpan(
                token: String(token),
                range: range
            ))
            position = range.upperBound
            
        }
        
        return spans
    }

    func annotate(tokens: [TokenSpan], text: String) -> [TaggedToken] {

        let tagger = NLTagger(tagSchemes: [.lexicalClass, .lemma, .nameType])
        tagger.string = text

        var results: [TaggedToken] = []

        for t in tokens {

            var out = TaggedToken(token: t.token, range: t.range)

            let pos = tagger.tag(at: t.range.lowerBound, unit: .word, scheme: .lexicalClass)
            out.lexicalClass = pos.0?.rawValue ?? "_"

            let lemma = tagger.tag(at: t.range.lowerBound, unit: .word, scheme: .lemma)
            out.lemma = lemma.0?.rawValue ?? "_"

            let ner = tagger.tag(at: t.range.lowerBound, unit: .word, scheme: .nameType)
            out.nameType = ner.0?.rawValue ?? "_"

            results.append(out)
        }

        return results
    }
    func runWithCustom(text: String) -> [TaggedToken]{
        
        let tokens = manualTokenise(text)
        let annotated = annotate(tokens: tokens, text: text)
        
        return annotated
    }

    
    
    
}



#Preview {
    let previewStore = SpaceDataStore()
    let inputMission = previewStore.missions.filter {$0.displayName.contains("STS")}[10]
    dev_scratchView(//mission: inputMission
    ).environmentObject(previewStore)
}

//let myURL = URL(fileURLWithPath: testFileRaw)
//var inputText: String = ""
//do {
//
//    inputText = try String(contentsOf: myURL, encoding: .utf8)
//
//} catch {
//
//    print(error)
//
//}
//


