import WidgetKit
import SwiftUI

// MARK: - Config
private let appGroupId = "group.com.JulienBouin.motivationApp"

// MARK: - Data Model

struct WidgetData {
    let affirmationText: String
    let affirmationCategory: String
    let goalCurrent: Double
    let goalTarget: Double
    let goalChangePct: Double
    let objectiveType: String

    static let placeholder = WidgetData(
        affirmationText: "Ship it. Learn it. Iterate.",
        affirmationCategory: "général",
        goalCurrent: 1350,
        goalTarget: 5000,
        goalChangePct: 12,
        objectiveType: "mrr"
    )

    static func load() -> WidgetData {
        let d = UserDefaults(suiteName: appGroupId)
        let current = d?.double(forKey: "goal_current") ?? 0
        let target  = d?.double(forKey: "goal_target")  ?? 0
        return WidgetData(
            affirmationText:     d?.string(forKey: "affirmation_text")     ?? placeholder.affirmationText,
            affirmationCategory: d?.string(forKey: "affirmation_category") ?? placeholder.affirmationCategory,
            goalCurrent:         current > 0 ? current : placeholder.goalCurrent,
            goalTarget:          target  > 0 ? target  : placeholder.goalTarget,
            goalChangePct:       d?.double(forKey: "goal_change_pct") ?? placeholder.goalChangePct,
            objectiveType:       d?.string(forKey: "objective_type")  ?? placeholder.objectiveType
        )
    }

    var progress: Double {
        guard goalTarget > 0 else { return 0 }
        return min(goalCurrent / goalTarget, 1.0)
    }

    var currentFormatted: String { formatAmount(goalCurrent) }
    var changeFormatted: String {
        let sign = goalChangePct >= 0 ? "+" : ""
        return "\(sign)\(Int(goalChangePct))%"
    }
    var isMrr: Bool { objectiveType == "mrr" }
    var unit: String { isMrr ? "" : "/mois" }

    private func formatAmount(_ v: Double) -> String {
        if v >= 1000 {
            let k = (v / 1000 * 10).rounded() / 10
            let s = k.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(k))K"
                : String(format: "%.1f", k).replacingOccurrences(of: ".", with: ",") + "K"
            return isMrr ? s + "€" : s
        }
        return isMrr ? "\(Int(v))€" : "\(Int(v))"
    }
}

// MARK: - Timeline Entry & Provider

struct MotivationEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

struct MotivationProvider: TimelineProvider {
    func placeholder(in context: Context) -> MotivationEntry {
        MotivationEntry(date: .now, data: .placeholder)
    }
    func getSnapshot(in context: Context, completion: @escaping (MotivationEntry) -> Void) {
        completion(MotivationEntry(date: .now, data: context.isPreview ? .placeholder : .load()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<MotivationEntry>) -> Void) {
        let entry = MotivationEntry(date: .now, data: .load())
        let next  = Calendar.current.date(byAdding: .minute, value: 30, to: .now)!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

// MARK: - Colors & Helpers

private extension Color {
    static let wBg        = Color(red: 0.086, green: 0.086, blue: 0.086)
    static let wGreen     = Color(red: 0.298, green: 0.686, blue: 0.314)
    static let wSecondary = Color.white.opacity(0.38)
    static let wTrack     = Color.white.opacity(0.12)
}

private struct ProgressBar: View {
    let progress: Double
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.wTrack).frame(height: 3)
                Capsule().fill(Color.wGreen)
                    .frame(width: max(6, g.size.width * progress), height: 3)
            }
        }
        .frame(height: 3)
    }
}

// MARK: - Small Affirmation View

private struct AffirmationView: View {
    let data: WidgetData
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.wBg
            VStack(alignment: .leading, spacing: 0) {
                Text("\u{201C}")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.white.opacity(0.12))
                    .offset(x: -4, y: -6)
                Spacer(minLength: 0)
                Text(data.affirmationText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: false)
                Spacer(minLength: 6)
                Text("— \(data.affirmationCategory)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.wSecondary)
            }
            .padding(14)
        }
    }
}

// MARK: - Small MRR / Goal View

private struct GoalView: View {
    let data: WidgetData
    var body: some View {
        ZStack {
            Color.wBg
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(data.isMrr ? "MRR" : "VISITES")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.wSecondary)
                        .kerning(0.6)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.wGreen)
                }
                Spacer(minLength: 0)
                Text(data.currentFormatted)
                    .font(.system(size: 30, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Spacer(minLength: 4)
                Text("\(data.changeFormatted) ce mois")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.wGreen)
                Spacer(minLength: 10)
                ProgressBar(progress: data.progress)
            }
            .padding(14)
        }
    }
}

// MARK: - Medium Combined View

private struct CombinedView: View {
    let data: WidgetData
    var body: some View {
        ZStack {
            Color.wBg
            VStack(alignment: .leading, spacing: 0) {
                // ── Top row ──────────────────────────────────────────────────
                HStack(alignment: .top, spacing: 0) {
                    // Left: big value + change badge
                    VStack(alignment: .leading, spacing: 4) {
                        Text(data.currentFormatted)
                            .font(.system(size: 34, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                        HStack(spacing: 3) {
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.wGreen)
                            Text(data.changeFormatted)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.wGreen)
                        }
                    }
                    Spacer(minLength: 12)
                    // Right: label + progress
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(data.isMrr ? "MRR" : "VISITES")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.wSecondary)
                            .kerning(0.6)
                        ProgressBar(progress: data.progress)
                            .frame(width: 70)
                    }
                    .padding(.top, 6)
                }
                Spacer(minLength: 0)
                // ── Bottom: quote ────────────────────────────────────────────
                Text("\"\(data.affirmationText)\"")
                    .font(.system(size: 12, weight: .regular).italic())
                    .foregroundColor(.white.opacity(0.80))
                    .lineLimit(2)
                Spacer(minLength: 4)
                Text("— \(data.affirmationCategory)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.wSecondary)
            }
            .padding(16)
        }
    }
}

// MARK: - Widget Wrappers (handle containerBackground iOS 17+)

struct AffirmationWidgetView: View {
    let entry: MotivationEntry
    var body: some View {
        if #available(iOS 17.0, *) {
            AffirmationView(data: entry.data).containerBackground(Color.wBg, for: .widget)
        } else {
            AffirmationView(data: entry.data)
        }
    }
}

struct GoalWidgetView: View {
    let entry: MotivationEntry
    var body: some View {
        if #available(iOS 17.0, *) {
            GoalView(data: entry.data).containerBackground(Color.wBg, for: .widget)
        } else {
            GoalView(data: entry.data)
        }
    }
}

struct CombinedWidgetView: View {
    let entry: MotivationEntry
    var body: some View {
        if #available(iOS 17.0, *) {
            CombinedView(data: entry.data).containerBackground(Color.wBg, for: .widget)
        } else {
            CombinedView(data: entry.data)
        }
    }
}

// MARK: - Widget Definitions

struct AffirmationWidget: Widget {
    let kind = "AffirmationWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MotivationProvider()) { AffirmationWidgetView(entry: $0) }
            .configurationDisplayName("Affirmation")
            .description("Une citation de motivation du jour.")
            .supportedFamilies([.systemSmall])
    }
}

struct MrrWidget: Widget {
    let kind = "MrrWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MotivationProvider()) { GoalWidgetView(entry: $0) }
            .configurationDisplayName("Objectif")
            .description("Ton MRR ou tes visites en un coup d\u{2019}\u{0153}il.")
            .supportedFamilies([.systemSmall])
    }
}

struct CombinedWidget: Widget {
    let kind = "CombinedWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MotivationProvider()) { CombinedWidgetView(entry: $0) }
            .configurationDisplayName("MRR + Affirmation")
            .description("Ton objectif et ta citation du jour.")
            .supportedFamilies([.systemMedium])
    }
}

// MARK: - Bundle

@main
struct MotivationWidgetBundle: WidgetBundle {
    var body: some Widget {
        AffirmationWidget()
        MrrWidget()
        CombinedWidget()
    }
}
