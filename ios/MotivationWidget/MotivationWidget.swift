//
//  MotivationWidget.swift
//  MotivationWidget
//

import WidgetKit
import SwiftUI

private let appGroupId  = "group.com.JulienBouin.motivationApp"
private let kBg         = Color(red: 22/255,  green: 22/255,  blue: 22/255)
private let kCard       = Color(red: 30/255,  green: 30/255,  blue: 30/255)
private let kGreen      = Color(red: 0.20,    green: 0.85,    blue: 0.40)
private let kSecondary  = Color.white.opacity(0.38)

// ─── Entry ────────────────────────────────────────────────────────────────────

struct AffirmationEntry: TimelineEntry {
    let date: Date
    let text: String
    let category: String
}

// ─── Provider ─────────────────────────────────────────────────────────────────

struct AffirmationProvider: TimelineProvider {
    private func readData() -> (text: String, category: String) {
        let defaults = UserDefaults(suiteName: appGroupId)
        let text     = defaults?.string(forKey: "affirmation_text")     ?? "Ship it. Learn it. Iterate."
        let category = defaults?.string(forKey: "affirmation_category") ?? "général"
        return (text, category)
    }

    func placeholder(in context: Context) -> AffirmationEntry {
        AffirmationEntry(date: Date(), text: "Ship it. Learn it. Iterate.", category: "général")
    }

    func getSnapshot(in context: Context, completion: @escaping (AffirmationEntry) -> Void) {
        let d = readData()
        completion(AffirmationEntry(date: Date(), text: d.text, category: d.category))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AffirmationEntry>) -> Void) {
        let d    = readData()
        let entry = AffirmationEntry(date: Date(), text: d.text, category: d.category)
        let next  = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

// ─── Small widget ─────────────────────────────────────────────────────────────

struct SmallWidgetView: View {
    let entry: AffirmationEntry

    var body: some View {
        ZStack {
            kBg
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(spacing: 5) {
                    Circle()
                        .fill(kGreen)
                        .frame(width: 5, height: 5)
                    Text("MOTIVATION")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(kSecondary)
                        .tracking(1.0)
                    Spacer()
                }

                Spacer()

                // Affirmation
                Text(entry.text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .lineSpacing(2.5)
                    .lineLimit(5)
                    .fixedSize(horizontal: false, vertical: false)

                Spacer().frame(height: 8)

                // Catégorie
                Text("— \(entry.category)")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundColor(kSecondary)
            }
            .padding(14)
        }
    }
}

// ─── Medium widget ────────────────────────────────────────────────────────────

struct MediumWidgetView: View {
    let entry: AffirmationEntry

    var body: some View {
        ZStack {
            kBg
            HStack(alignment: .top, spacing: 0) {
                // Barre verte verticale
                Rectangle()
                    .fill(kGreen)
                    .frame(width: 3)
                    .clipShape(Capsule())
                    .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 5) {
                        Text("MOTIVATION")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(kSecondary)
                            .tracking(1.0)
                        Spacer()
                    }

                    Spacer()

                    Text(entry.text)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: false)

                    Spacer().frame(height: 8)

                    Text("— \(entry.category)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(kSecondary)
                }
                .padding(.leading, 12)
                .padding(.vertical, 4)
            }
            .padding(14)
        }
    }
}

// ─── Entry view dispatcher ────────────────────────────────────────────────────

struct MotivationWidgetEntryView: View {
    let entry: AffirmationEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// ─── Widget ───────────────────────────────────────────────────────────────────

struct MotivationWidget: Widget {
    let kind: String = "MotivationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AffirmationProvider()) { entry in
            MotivationWidgetEntryView(entry: entry)
                .containerBackground(kBg, for: .widget)
        }
        .configurationDisplayName("Affirmation du jour")
        .description("Une affirmation motivante sur votre écran d'accueil.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// ─── Previews ─────────────────────────────────────────────────────────────────

#Preview(as: .systemSmall) {
    MotivationWidget()
} timeline: {
    AffirmationEntry(date: .now, text: "Pose une brique aujourd'hui. Encore une demain. C'est tout.", category: "action")
}

#Preview(as: .systemMedium) {
    MotivationWidget()
} timeline: {
    AffirmationEntry(date: .now, text: "Chaque ligne de code me rapproche de mon objectif.", category: "focus")
}
