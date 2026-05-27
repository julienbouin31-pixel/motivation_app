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
        ZStack(alignment: .topLeading) {
            kBg
            VStack(alignment: .leading, spacing: 0) {
                // Grand guillemet fané
                Text("\u{201C}")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(Color.white.opacity(0.08))
                    .frame(height: 36)
                Spacer()
                // Texte de l'affirmation
                Text(entry.text)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
                Spacer().frame(height: 6)
                // Catégorie
                Text("— \(entry.category)")
                    .font(.system(size: 10))
                    .foregroundColor(kSecondary)
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
