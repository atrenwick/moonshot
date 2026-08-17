//
//  UDTestView.swift
//
//  A minimal SwiftUI screen for testing the UDPipeline (see UDPipeline.swift)
//  against a hardcoded sentence. Tap "Test" to run both Core ML models and
//  print the resulting CoNLL-U-style lines.
//
//  This is named UDTestView (not ContentView) so it doesn't collide with
//  the ContentView.swift Xcode's app template already created for you --
//  see the README for how to wire this in.
//
import SwiftUI

//
//  ProgressBarStyle.swift
//
//  A picker-selectable choice between the two progress-reporting styles
//  explored in ProgressBarComparisonView, plus reusable views for each so
//  they can be dropped into any view (like a button label) and switched
//  live via the enum.
//

enum ProgressBarStyle: String, CaseIterable, Identifiable {
    case tqdm = "tqdm"
    case apple = "Apple"

    var id: String { rawValue }
}

/// Drop this wherever you want a `Picker` for choosing the style --
/// e.g. above the "Test" button.
struct ProgressBarStylePicker: View {
    @Binding var selection: ProgressBarStyle

    var body: some View {
        Picker("Progress Style", selection: $selection) {
            ForEach(ProgressBarStyle.allCases) { style in
                Text(style.rawValue).tag(style)
            }
        }
        .pickerStyle(.segmented)
    }
}

/// Hand-rolled tqdm-style text line. Needs the caller to track
/// processed/total/startTime itself (see runTest()'s rewrite).
struct TqdmProgressView: View {
    let processed: Int
    let total: Int
    let startTime: Date?

    var body: some View {
        Text(tqdmLine())
            .font(.system(.footnote, design: .monospaced))
            .lineLimit(1)
            .minimumScaleFactor(0.6) // shrinks to fit if space is tight (e.g. inside a button)
    }

    private func tqdmLine(width: Int = 20) -> String {
        let fraction = total > 0 ? Double(processed) / Double(total) : 0
        let filled = Int(fraction * Double(width))
        let bar = String(repeating: "█", count: filled)
            + String(repeating: "-", count: max(0, width - filled))
        let percent = Int(fraction * 100)

        var rateSuffix = ""
        if let startTime, processed > 0 {
            let elapsed = Date().timeIntervalSince(startTime)
            let rate = Double(processed) / max(elapsed, 0.001)
            let remaining = rate > 0 ? Double(total - processed) / rate : 0
            rateSuffix = String(format: ", %.1fit/s, ETA %ds", rate, Int(remaining))
        }

        return "\(percent)%|\(bar)| \(processed)/\(total)\(rateSuffix)"
    }
}

/// Apple's native Progress/ProgressView, still updated manually by the
/// caller every step (see runTest()'s rewrite) -- there's no auto-tracking
/// for a plain processing loop, only the native rendering is "free" here.
struct AppleProgressView: View {
    let progress: Progress

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ProgressView(progress)
            if let description = progress.localizedDescription {
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// The switcher: renders whichever style is currently selected. This is
/// the one you actually place in your view -- pass it both trackers'
/// current state and it picks which to show.
struct PipelineProgressView: View {
    let style: ProgressBarStyle
    let processed: Int
    let total: Int
    let startTime: Date?
    let appleProgress: Progress

    var body: some View {
        switch style {
        case .tqdm:
            TqdmProgressView(processed: processed, total: total, startTime: startTime)
        case .apple:
            AppleProgressView(progress: appleProgress)
        }
    }
}

enum LanguageCode: String, CaseIterable, Identifiable {
    var id: Self {self}
    case FR
    case EN
}



struct UDTestView: View {
    @State private var testSentences = ["Paris est la capitale de la France.", "La capitale de l'Allemagne est Berlin, mais avant, c'était Bonn mais on trouvait que c'était pas bon."]
    @State var pretokSents: [[String]] = [
        ["La"],["capitale"],["italienne"],["est"],["Rome"]
    ]
    @State private var outputLines: [String] = []
    @State private var errorMessage: String?
    @State private var isRunning = false
    @State private var newSentence: String = ""
    @State private var conllRawLines: [String] = []
    @State private var progressBarStyle: ProgressBarStyle = .tqdm
    @State private var processedCount = 0
    @State private var totalCount = 0
    @State private var startTime: Date?
    @State private var appleProgress = Progress(totalUnitCount: 1)
    @State private var hasStarted = false
//    @State private var loadedSents: [String] = Bundle.main.loadText("ENsents.txt", format: "lines").components(separatedBy: "\n")
    @State var newsArticles: [CCNewsArticle] = []
    var ccSents: [String]  {
        var result: [String] = []
        for ccArt in newsArticles {
            // this removes the . >> need to add option to segment result into sentences as some title/heading sentences still attached to body
            let articleText = ccArt.allText
            for sent in articleText.components(separatedBy: ". ") {
                let normalized = sent.replacingOccurrences(of: "\u{2019}", with: "'")
                let trimmed = normalized.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty {
                    result.append(trimmed)
                }
            }
            
        }
        return result

    }
    
    private var visibleSents: [String] {
        Array(testSentences.prefix(5))
    }

    @State var pretokSentsOut: [TokenisedSentence] = []
    @State var predictedSentsOut: [TokenisedSentence] = []
    @State var selectedLanguage: LanguageCode = .FR
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("UD Pipeline Test")
                .font(.title2)
                .bold()

            
            
            ForEach(visibleSents, id:\.self){testSentence in
            Text("Input: \"\(testSentence)\"")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            TextField("Additional sentence", text: $newSentence)

            HStack{
                Button("Add"){
                    if !newSentence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                        testSentences.append(newSentence)
                        newSentence = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: runTest) {
                    HStack {
//                        Spacer()
                        if isRunning {
                            ProgressView()
                        } else {
                            Text("Test")
                        }
//                        Spacer()
                    }
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)
                Button {
//                    pretokSentsOut = tokenisedInputToSents(input: testSentences)
                    
                } label: {
                    //look like this
                    Text("Pretokenised")
                }
                .tint(.orange)
                .buttonStyle(.borderedProminent)
                
                Button {
//                    pretokSentsOut = tokenisedInputToSents(input: testSentences)
//                    testSentences = Bundle.main.loadText("ENsents.txt", format: "lines").components(separatedBy: "\n")
                    
                    let decoded: StructureMap = Bundle.main.decode("20minutes_fr_2016_0000_2016.json")
                    newsArticles = Array(decoded.values)
                    testSentences = ccSents
                    
                } label: {
                    //look like this
                    Text("File")
                }
                .tint(.cyan)
                .buttonStyle(.borderedProminent)

            }

            Picker("Language", selection: $selectedLanguage) {
                ForEach(LanguageCode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .tint(.blue) // Forces the active background capsule to turn blue

            ProgressBarStylePicker(selection: $progressBarStyle)

            
            // get sents to process from file
            
            
//            testSentences = textIn.components(separatedBy: "\n")
            //            let sentsFromLines = textIn.split(separator: "\n")
//            testSentences = textIn
            

            if hasStarted {
                PipelineProgressView(
                    style: progressBarStyle,
                    processed: processedCount,
                    total: totalCount,
                    startTime: startTime,
                    appleProgress: appleProgress
                )
            }

//            Button(action: runTest) {
//                HStack {
//                    Spacer()
//                    if isRunning {
//                        // this is the circle progresswheel thing
//                        ProgressView()
//                            // TODO: change this to view1  either raw conlltextAsXML or view2 with tidyConll
//                    } else {
//                        Text("Test")
//                    }
//                    Spacer()
//                }
//            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            HStack{
                
//                Button{
//                    for (_, sent) in testSentences.enumerated(){
//                    let internalData = try UDPipelinetokenize(sent)
//                    predictedSentsOut = predictedSentsToTokenisedSents(input: testSentences)}
//                } label: {
//                    Text("Raw text block")
//                }
//                .foregroundStyle(.red)
//                .buttonStyle(.borderedProminent)
            }
            PretokenisedSentView(pretokSentsOut: pretokSentsOut)

            OutputLinesView(outputLines: outputLines)
            Spacer()
        }
        .padding()
    }
    
    func writeToFile(_ content: String, _ path: String) throws {
        let url = URL(fileURLWithPath: path)
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
    private func runTest() {
//        print(loadedSents)
//        dumpScalars(loadedSents, maxChars: 500)
        
        errorMessage = nil
        outputLines = []
        conllRawLines = []
        processedCount = 0
        totalCount = 0
        startTime = nil
        isRunning = true
        hasStarted = true   // <-- new: once true, stays true for the rest of the session

        Task {
            do {
                let pipeline = try UDPipeline(languageCode: selectedLanguage.rawValue)

                // Step 1: tokenize everything up front, across all input blocks,
                // so we know the true total sentence count (the progress bar's
                // denominator) before any tagging/parsing starts.
                var allSentences: [TokenisedSentence] = []
                for sentence in testSentences {
                    allSentences.append(contentsOf: try pipeline.tokenize(sentence))
                }

                
                await MainActor.run {
                    totalCount = allSentences.count
                    appleProgress = Progress(totalUnitCount: Int64(max(allSentences.count, 1)))
                    startTime = Date()
                }

                var lines: [String] = []
                var rawLines: [String] = []

                // Step 2: process one detected sentence at a time so the
                // progress bar can tick after each one finishes.
                for sentence in allSentences {
                    let tokens = try pipeline.runOnSentence(sentence, level: 5)
                    lines.append(contentsOf: try pipeline.formatSentence(tokens, mode: "tidy"))
                    rawLines.append(contentsOf: try pipeline.formatSentence(tokens, mode: "raw"))

                    await MainActor.run {
                        processedCount += 1
                        appleProgress.completedUnitCount = Int64(processedCount)
                    }
                }


                let url = try writeStringDump(lines)
                print("Saved CoNLL dump to: \(url.path)")

                let url2 = try writeStringDump(rawLines)
                print("Saved raw dump to: \(url2.path)")

                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let outputPath = docsDir.appendingPathComponent("output.conllu").path
                try writeToFile(rawLines.joined(separator: "\n"), outputPath)
                print("Wrote file to: \(outputPath)")

                await MainActor.run {
                    outputLines.append(contentsOf: lines)
                    conllRawLines.append(contentsOf: rawLines)
                    isRunning = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isRunning = false
                }
            }
        }
    }
    

    
    //    private func runTest() {
//        errorMessage = nil
//        outputLines = []
//        isRunning = true
//        conllRawLines = []
//        
//        Task {
//            do {
//                let pipeline = try UDPipeline(languageCode: selectedLanguage.rawValue)
//                var lines: [String] = []
//                var rawLines: [String] = []
//                for sentence in testSentences {
//                    lines.append(contentsOf: try pipeline.run(text: sentence, level: 5, mode: "tidy"))
//                    rawLines.append(contentsOf: try pipeline.run(text: sentence, level: 5, mode: "raw"))
//                }
//                
////                let rawLines = try pipeline.run(text: testSentences, level: 5, mode: "raw")
////                let lines = try pipeline.run(text: testSentences, mode: "tidy")
////                let rawLines = try pipeline.run(text: testSentences, mode: "raw")
//
//                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let outputPath = docsDir.appendingPathComponent("output.conllu").path
//                try writeToFile(rawLines.joined(separator: "\n"), outputPath)
//                print("Wrote file to: \(outputPath)")
//
//                await MainActor.run {
//                    outputLines.append(contentsOf: lines)
//                    conllRawLines.append(contentsOf: rawLines)
//                    isRunning = false
//                    }
//            }
//            catch {
//                await MainActor.run {
//                    errorMessage = error.localizedDescription
//                    isRunning = false
//                }
//            }
//        }
//    }
}

#Preview {
    UDTestView()
}

func writeStringDump(_ lines: [String]) throws -> URL {
    let content = lines.joined(separator: "\n")
    let fileName = "string_dump_\(Int(Date().timeIntervalSince1970 * 1_000_000_000)).conllu"
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(fileName)

    try content.write(to: fileURL, atomically: true, encoding: .utf8)
    return fileURL
}

struct PretokenisedSentView : View {
    let pretokSentsOut: [TokenisedSentence]
    var body: some View{
        ScrollView{
            ForEach(pretokSentsOut, id:\.self){instance in
                Text("moo")
                ForEach(instance.tokens, id:\.self){tok in
                Text(tok)}
            }
        }

    }
}

struct OutputLinesView: View {
    let outputLines: [String]
    var body: some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(outputLines.enumerated()), id: \.offset) { _, line in
                    Text(line.isEmpty ? " " : line)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
        }
        .background(Color.gray.opacity(0.08))
        .cornerRadius(8)
        

        
    }
}

func dumpScalars(_ text: String, maxChars: Int = 50) {
    for scalar in text.unicodeScalars.prefix(maxChars) {
        print("\(scalar) -> \(scalar.value)")
    }
}

 

