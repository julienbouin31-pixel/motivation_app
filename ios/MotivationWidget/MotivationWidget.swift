//
//  MotivationWidget.swift
//  MotivationWidget
//

import WidgetKit
import SwiftUI

private let appGroupId = "group.com.JulienBouin.motivationApp"
private let kBg        = Color(red: 22/255, green: 22/255, blue: 22/255)
private let kSecondary = Color.white.opacity(0.38)

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – Shared provider
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

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – 1) Affirmation Widget (écran d'accueil, 2×2)
// ═══════════════════════════════════════════════════════════════════════════════

struct AffirmationSmallView: View {
    let entry: AffirmationEntry
    var body: some View {
        ZStack {
            kBg
            VStack(spacing: 0) { Color(red: 0.298, green: 0.686, blue: 0.314).frame(height: 2.5); Spacer() }
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
// MARK: – 2) Lock Screen Widget (écran de verrouillage)
// ═══════════════════════════════════════════════════════════════════════════════

struct LockScreenView: View {
    let entry: AffirmationEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(entry.text)
                .font(.system(size: 12, weight: .medium))
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct LockScreenWidget: Widget {
    let kind = "LockScreenWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AffirmationProvider()) { entry in
            LockScreenView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Affirmation")
        .description("Une affirmation sur l'écran de verrouillage.")
        .supportedFamilies([.accessoryRectangular])
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

#Preview(as: .accessoryRectangular) {
    LockScreenWidget()
} timeline: {
    AffirmationEntry(date: .now, text: "Chaque action me rapproche de mon objectif.", category: "focus")
}
