//
//  ProgressBarComparisonView.swift
//
//  Side-by-side comparison of two progress-reporting approaches, both
//  driven by the same plain counting loop (1...1000, no actual pipeline
//  work) so the UI behaviour can be compared directly:
//
//    TOP    -- hand-rolled tqdm-style text line, fully manual: we track
//              processed count and start time ourselves, and format the
//              bar/percentage/rate string ourselves. This is exactly the
//              approach used in UDBatchProcessingView.
//    BOTTOM -- Apple's Foundation `Progress` object bound to SwiftUI's
//              native `ProgressView(_ progress:)`. Still NOT auto-tracking
//              (we still set `.completedUnitCount` manually every step --
//              there's no free lunch for a plain counting loop, only for
//              things like URLSession downloads where the OS itself is
//              the one moving the bytes) but you get the native blue bar
//              and a system-generated description string for free.
//
//  ASSUMPTION: the delay input box takes an Int number of MILLISECONDS
//  (default 2, i.e. 0.002s), not seconds -- an Int field can't represent
//  0.002 directly, so milliseconds is what reconciles "delay is an Int"
//  with "default delay is 0.002 seconds".
//
import SwiftUI

struct ProgressBarComparisonView: View {
    private let totalSteps = 1000

    @State private var delayMilliseconds: Double = 2.0
    @State private var isRunning = false

    // --- Top: hand-rolled tqdm-style state ---
    @State private var tqdmProcessed = 0
    @State private var tqdmStartTime: Date?

    // --- Bottom: Apple Progress-object state ---
    @State private var appleProgress = Progress(totalUnitCount: 1000)

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Progress Bar Comparison")
                .font(.title2)
                .bold()

            HStack {
                Text("Delay per step (ms):")
                TextField("ms", value: $delayMilliseconds, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 80)
            }

            Button(action: runBoth) {
                HStack {
                    Spacer()
                    Text(isRunning ? "Running…" : "Run Both")
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isRunning)

            Divider()

            // MARK: Top half -- hand-rolled tqdm-style
            VStack(alignment: .leading, spacing: 6) {
                Text("tqdm-style (hand-rolled)")
                    .font(.headline)
                Text(tqdmLine())
                    .font(.system(.body, design: .monospaced))
            }

            Divider()

            // MARK: Bottom half -- Apple's Progress / ProgressView
            VStack(alignment: .leading, spacing: 6) {
                Text("Apple Progress (native)")
                    .font(.headline)
                ProgressView(appleProgress)
                Text("\(appleProgress.completedUnitCount)/\(appleProgress.totalUnitCount) "
                     + "(\(Int(appleProgress.fractionCompleted * 100))%)")
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(.secondary)
                // `appleProgress.localizedDescription` is a system-generated
                // string Foundation builds for you from fractionCompleted --
                // shown here so you can see exactly what you get "for free"
                // versus the fully custom line above.
                if let description = appleProgress.localizedDescription {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Run both concurrently

    private func runBoth() {
        guard !isRunning else { return }
        isRunning = true
        tqdmProcessed = 0
        tqdmStartTime = Date()
        // Fresh Progress instance each run -- reusing one that's already
        // reached isFinished can behave oddly if you try to "rewind" it.
        appleProgress = Progress(totalUnitCount: Int64(totalSteps))

        let delayNanoseconds = UInt64(max(0, delayMilliseconds)) * 1_000_000

        Task {
            // `async let` runs both loops as genuinely concurrent child
            // tasks -- they interleave in real time rather than one
            // finishing before the other starts, so this is a fair race
            // between the two update styles under the same delay.
            async let tqdmTask: Void = runCounter(delayNanoseconds: delayNanoseconds) { i in
                await MainActor.run { tqdmProcessed = i }
            }
            async let appleTask: Void = runCounter(delayNanoseconds: delayNanoseconds) { i in
                await MainActor.run { appleProgress.completedUnitCount = Int64(i) }
            }
            _ = await (tqdmTask, appleTask)

            await MainActor.run { isRunning = false }
        }
    }

    /// Shared counting loop, parameterised by an update callback so both
    /// halves can reuse the same timing logic rather than duplicating it.
    private func runCounter(delayNanoseconds: UInt64, update: @escaping (Int) async -> Void) async {
        for i in 1...totalSteps {
            try? await Task.sleep(nanoseconds: delayNanoseconds)
            await update(i)
        }
    }

    // MARK: - tqdm-style text readout

    private func tqdmLine(width: Int = 24) -> String {
        let fraction = totalSteps > 0 ? Double(tqdmProcessed) / Double(totalSteps) : 0
        let filled = Int(fraction * Double(width))
        let bar = String(repeating: "█", count: filled)
            + String(repeating: "-", count: max(0, width - filled))
        let percent = Int(fraction * 100)

        var rateSuffix = ""
        if let tqdmStartTime, tqdmProcessed > 0 {
            let elapsed = Date().timeIntervalSince(tqdmStartTime)
            let rate = Double(tqdmProcessed) / max(elapsed, 0.001)
            let remaining = rate > 0 ? Double(totalSteps - tqdmProcessed) / rate : 0
            rateSuffix = String(format: ", %.1fit/s, ETA %ds", rate, Int(remaining))
        }

        return "\(percent)%|\(bar)| \(tqdmProcessed)/\(totalSteps)\(rateSuffix)"
    }
}

#Preview {
    ProgressBarComparisonView()
}
