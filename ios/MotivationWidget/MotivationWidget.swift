//
//  MotivationWidget.swift
//  MotivationWidget
//

import WidgetKit
import SwiftUI

private let appGroupId = "group.com.JulienBouin.motivationApp"
private let kBg        = Color(red: 22/255, green: 22/255, blue: 22/255)
private let kGreen     = Color(red: 0.298, green: 0.686, blue: 0.314)
private let kSecondary = Color.white.opacity(0.38)
private let kTrack     = Color.white.opacity(0.12)

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – Shared helpers
// ═══════════════════════════════════════════════════════════════════════════════

struct MiniProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(kTrack).frame(height: 3)
                Capsule().fill(kGreen)
                    .frame(width: max(4, geo.size.width * progress), height: 3)
            }
        }
        .frame(height: 3)
    }
}

func formatValue(_ v: Double, isMrr: Bool) -> String {
    if v >= 1000 {
        let k = (v / 1000 * 10).rounded() / 10
        let s = k.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(k))K" : String(format: "%.1fK", k).replacingOccurrences(of: ".", with: ",")
        return isMrr ? "\(s)€" : s
    }
    return isMrr ? "\(Int(v))€" : "\(Int(v))"
}

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – 1) Affirmation Widget
// ═══════════════════════════════════════════════════════════════════════════════

struct AffirmationEntry: TimelineEntry {
    let date: Date
    let text: String
    let category: String
}

struct AffirmationProvider: TimelineProvider {
    private func read() -> (String, String) {
        let d = UserDefaults(suiteName: appGroupId)
        return (
            d?.string(forKey: "affirmation_text")     ?? "Ship it. Learn it. Iterate.",
            d?.string(forKey: "affirmation_category") ?? "général"
        )
    }
    func placeholder(in c: Context) -> AffirmationEntry {
        AffirmationEntry(date: .now, text: "Ship it. Learn it. Iterate.", category: "général")
    }
    func getSnapshot(in c: Context, completion: @escaping (AffirmationEntry) -> Void) {
        let r = read(); completion(AffirmationEntry(date: .now, text: r.0, category: r.1))
    }
    func getTimeline(in c: Context, completion: @escaping (Timeline<AffirmationEntry>) -> Void) {
        let r = read()
        let e = AffirmationEntry(date: .now, text: r.0, category: r.1)
        completion(Timeline(entries: [e], policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: .now)!)))
    }
}

struct AffirmationSmallView: View {
    let entry: AffirmationEntry
    var body: some View {
        ZStack {
            kBg
            VStack(spacing: 0) { kGreen.frame(height: 2.5); Spacer() }
            VStack(spacing: 0) {
                Spacer()
                Text("« \(entry.text) »")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .lineLimit(5)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 4)
                Spacer()
                Text(entry.category.uppercased())
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(kSecondary)
                    .tracking(1.5)
            }
            .padding(14)
        }
    }
}

struct AffirmationWidget: Widget {
    let kind = "AffirmationWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AffirmationProvider()) { entry in
            AffirmationSmallView(entry: entry)
                .containerBackground(kBg, for: .widget)
        }
        .configurationDisplayName("Affirmation")
        .description("Une affirmation motivante.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – 2) Goal Widget (MRR / Visites)
// ═══════════════════════════════════════════════════════════════════════════════

struct GoalEntry: TimelineEntry {
    let date: Date
    let current: Double
    let target: Double
    let changePct: Double
    let isMrr: Bool
}

struct GoalProvider: TimelineProvider {
    private func read() -> GoalEntry {
        let d = UserDefaults(suiteName: appGroupId)
        let type = d?.string(forKey: "objective_type") ?? "mrr"
        return GoalEntry(
            date: .now,
            current:   d?.double(forKey: "goal_current")    ?? 3400,
            target:    d?.double(forKey: "goal_target")      ?? 5000,
            changePct: d?.double(forKey: "goal_change_pct")  ?? 12,
            isMrr:     type == "mrr"
        )
    }
    func placeholder(in c: Context) -> GoalEntry {
        GoalEntry(date: .now, current: 3400, target: 5000, changePct: 12, isMrr: true)
    }
    func getSnapshot(in c: Context, completion: @escaping (GoalEntry) -> Void) {
        completion(read())
    }
    func getTimeline(in c: Context, completion: @escaping (Timeline<GoalEntry>) -> Void) {
        completion(Timeline(entries: [read()], policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: .now)!)))
    }
}

struct GoalSmallView: View {
    let entry: GoalEntry

    var body: some View {
        let progress = min(max(entry.current / entry.target, 0), 1)
        let sign = entry.changePct >= 0 ? "+" : ""

        ZStack {
            kBg
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Text(entry.isMrr ? "MRR" : "VISITES")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(kSecondary)
                        .tracking(0.6)
                    Spacer()
                    Image(systemName: "arrow.up")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(kGreen)
                }

                Spacer()

                // Valeur
                Text(formatValue(entry.current, isMrr: entry.isMrr))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()

                Spacer().frame(height: 3)

                // Changement
                Text("\(sign)\(Int(entry.changePct))% ce mois")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(kGreen)

                Spacer().frame(height: 10)

                // Barre de progression
                MiniProgressBar(progress: progress)
            }
            .padding(14)
        }
    }
}

struct GoalWidget: Widget {
    let kind = "MrrWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GoalProvider()) { entry in
            GoalSmallView(entry: entry)
                .containerBackground(kBg, for: .widget)
        }
        .configurationDisplayName("Objectif")
        .description("MRR ou visites avec progression.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – 3) Combined Widget (Goal + Affirmation)
// ═══════════════════════════════════════════════════════════════════════════════

struct CombinedEntry: TimelineEntry {
    let date: Date
    let text: String
    let category: String
    let current: Double
    let target: Double
    let changePct: Double
    let isMrr: Bool
}

struct CombinedProvider: TimelineProvider {
    private func read() -> CombinedEntry {
        let d = UserDefaults(suiteName: appGroupId)
        let type = d?.string(forKey: "objective_type") ?? "mrr"
        return CombinedEntry(
            date: .now,
            text:      d?.string(forKey: "affirmation_text")     ?? "Ship it. Learn it. Iterate.",
            category:  d?.string(forKey: "affirmation_category") ?? "général",
            current:   d?.double(forKey: "goal_current")         ?? 3400,
            target:    d?.double(forKey: "goal_target")           ?? 5000,
            changePct: d?.double(forKey: "goal_change_pct")       ?? 12,
            isMrr:     type == "mrr"
        )
    }
    func placeholder(in c: Context) -> CombinedEntry {
        CombinedEntry(date: .now, text: "Ship it. Learn it. Iterate.", category: "général",
                      current: 3400, target: 5000, changePct: 12, isMrr: true)
    }
    func getSnapshot(in c: Context, completion: @escaping (CombinedEntry) -> Void) {
        completion(read())
    }
    func getTimeline(in c: Context, completion: @escaping (Timeline<CombinedEntry>) -> Void) {
        completion(Timeline(entries: [read()], policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: .now)!)))
    }
}

struct CombinedMediumView: View {
    let entry: CombinedEntry

    var body: some View {
        let progress = min(max(entry.current / entry.target, 0), 1)
        let sign = entry.changePct >= 0 ? "+" : ""

        ZStack {
            kBg
            VStack(alignment: .leading, spacing: 0) {
                // Top row: valeur + label
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(formatValue(entry.current, isMrr: entry.isMrr))
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()
                        HStack(spacing: 2) {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(kGreen)
                            Text("\(sign)\(Int(entry.changePct))%")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(kGreen)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(entry.isMrr ? "MRR" : "VISITES")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(kSecondary)
                            .tracking(0.6)
                        MiniProgressBar(progress: progress)
                            .frame(width: 60)
                    }
                }

                Spacer()

                // Citation
                Text("\" \(entry.text) \"")
                    .font(.system(size: 11, weight: .regular))
                    .italic()
                    .foregroundColor(Color.white.opacity(0.8))
                    .lineSpacing(2)
                    .lineLimit(2)

                Spacer().frame(height: 4)

                Text("— \(entry.category)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(kSecondary)
            }
            .padding(16)
        }
    }
}

struct CombinedWidget: Widget {
    let kind = "CombinedWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CombinedProvider()) { entry in
            CombinedMediumView(entry: entry)
                .containerBackground(kBg, for: .widget)
        }
        .configurationDisplayName("MRR + Affirmation")
        .description("Objectif et affirmation combinés.")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – Previews
// ═══════════════════════════════════════════════════════════════════════════════

#Preview(as: .systemSmall) {
    AffirmationWidget()
} timeline: {
    AffirmationEntry(date: .now, text: "Ship it. Learn it. Iterate.", category: "général")
}

#Preview(as: .systemSmall) {
    GoalWidget()
} timeline: {
    GoalEntry(date: .now, current: 3400, target: 5000, changePct: 12, isMrr: true)
}

#Preview(as: .systemMedium) {
    CombinedWidget()
} timeline: {
    CombinedEntry(date: .now, text: "Chaque ligne de code me rapproche de mon objectif.",
                  category: "focus", current: 3400, target: 5000, changePct: 12, isMrr: true)
}
