//
//  MotivationWidget.swift
//  MotivationWidget
//

import WidgetKit
import SwiftUI

private let appGroupId = "group.com.JulienBouin.motivationApp"

// ── Palette (alignée sur AppStyle de l'app) ──────────────────────────────────
private let kBg        = Color(red: 0x12/255, green: 0x12/255, blue: 0x11/255)
private let kInk       = Color(red: 0xF4/255, green: 0xF4/255, blue: 0xF1/255)
private let kDim       = Color(red: 0x8B/255, green: 0x8B/255, blue: 0x87/255)
private let kAccent    = Color(red: 0xE0/255, green: 0xA9/255, blue: 0x6D/255)
private let kHairline  = Color.white.opacity(0.14)

// ── Typographie (Urbanist embarqué dans l'extension) ─────────────────────────
private func urbanistLight(_ size: CGFloat) -> Font { .custom("Urbanist-Light", size: size) }
private func urbanistSemibold(_ size: CGFloat) -> Font { .custom("Urbanist-SemiBold", size: size) }

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – Shared provider
// ═══════════════════════════════════════════════════════════════════════════════

struct AffirmationEntry: TimelineEntry {
    let date: Date
    let text: String
    let category: String
    var id: Int? = nil
    var streak: Int = 0
}

// URL de deep-link ouverte au tap du widget → l'app ouvre cette affirmation.
private func deepLink(for id: Int?) -> URL? {
    guard let id = id else { return nil }
    return URL(string: "curves://affirmation?id=\(id)")
}

struct AffirmationProvider: TimelineProvider {
    // Rotation : nouvelle affirmation toutes les 6h (4×/jour), timeline
    // pré-calculée sur 3 jours pour tourner même app fermée.
    private let slotHours = 6
    private let slotsAhead = 12

    private func read() -> (String, String) {
        let d = UserDefaults(suiteName: appGroupId)
        return (
            d?.string(forKey: "affirmation_text")     ?? "Chaque action me rapproche de mon objectif.",
            d?.string(forKey: "affirmation_category") ?? "général"
        )
    }

    private func readStreak() -> Int {
        UserDefaults(suiteName: appGroupId)?.integer(forKey: "streak") ?? 0
    }

    /// Réservoir poussé par l'app (JSON [{id, text, category}]).
    private func readPool() -> [(id: Int?, text: String, category: String)] {
        let d = UserDefaults(suiteName: appGroupId)
        guard let raw = d?.string(forKey: "affirmation_pool"),
              let data = raw.data(using: .utf8),
              let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: String]]
        else { return [] }
        return arr.compactMap { dict in
            guard let t = dict["text"], let c = dict["category"] else { return nil }
            return (dict["id"].flatMap { Int($0) }, t, c)
        }
    }

    func placeholder(in c: Context) -> AffirmationEntry {
        AffirmationEntry(date: .now, text: "Chaque action me rapproche de mon objectif.", category: "général")
    }

    func getSnapshot(in c: Context, completion: @escaping (AffirmationEntry) -> Void) {
        let streak = readStreak()
        let pool = readPool()
        if let first = pool.first {
            completion(AffirmationEntry(date: .now, text: first.text, category: first.category, id: first.id, streak: streak))
        } else {
            let r = read()
            completion(AffirmationEntry(date: .now, text: r.0, category: r.1, streak: streak))
        }
    }

    func getTimeline(in c: Context, completion: @escaping (Timeline<AffirmationEntry>) -> Void) {
        let streak = readStreak()
        let pool = readPool()
        let now = Date()

        // Fallback : pas de réservoir (ancienne version) → affirmation unique.
        guard !pool.isEmpty else {
            let r = read()
            let e = AffirmationEntry(date: now, text: r.0, category: r.1, streak: streak)
            completion(Timeline(entries: [e], policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: now)!)))
            return
        }

        let interval = TimeInterval(slotHours * 3600)
        let currentSlot = floor(now.timeIntervalSince1970 / interval)
        var entries: [AffirmationEntry] = []
        for i in 0..<slotsAhead {
            let slot = currentSlot + Double(i)
            let idx = ((Int(slot) % pool.count) + pool.count) % pool.count
            let item = pool[idx]
            // Première entrée à "maintenant" pour un rendu immédiat.
            let date = i == 0 ? now : Date(timeIntervalSince1970: slot * interval)
            entries.append(AffirmationEntry(date: date, text: item.text, category: item.category, id: item.id, streak: streak))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – 1) Affirmation Widget (écran d'accueil, 2×2) — éditorial citation
// ═══════════════════════════════════════════════════════════════════════════════

struct AffirmationSmallView: View {
    let entry: AffirmationEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Guillemet ocre en filigrane + série en cours à droite
            HStack(alignment: .top) {
                Text("\u{201C}")
                    .font(urbanistSemibold(52))
                    .foregroundColor(kAccent.opacity(0.28))
                    .frame(height: 26, alignment: .top)
                    .clipped()
                Spacer()
                if entry.streak > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                        Text("\(entry.streak)")
                            .font(urbanistSemibold(11))
                    }
                    .foregroundColor(kAccent)
                }
            }

            Spacer(minLength: 8)

            // Affirmation
            Text(entry.text)
                .font(urbanistLight(15))
                .foregroundColor(kInk)
                .lineSpacing(3)
                .lineLimit(4)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 10)

            // Filet fin
            Rectangle()
                .fill(kHairline)
                .frame(width: 34, height: 1)

            Spacer().frame(height: 9)

            // Catégorie en overline avec point ocre
            HStack(spacing: 6) {
                Circle()
                    .fill(kAccent)
                    .frame(width: 4, height: 4)
                Text(entry.category.uppercased())
                    .font(urbanistSemibold(9))
                    .tracking(2.4)
                    .foregroundColor(kDim)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
    }
}

struct AffirmationWidget: Widget {
    let kind = "AffirmationWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AffirmationProvider()) { entry in
            AffirmationSmallView(entry: entry)
                .containerBackground(kBg, for: .widget)
                .widgetURL(deepLink(for: entry.id))
        }
        .configurationDisplayName("Affirmation")
        .description("Une affirmation motivante.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: – 2) Lock Screen Widget (accessoryRectangular) — monochrome système
// ═══════════════════════════════════════════════════════════════════════════════

struct LockScreenView: View {
    let entry: AffirmationEntry

    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            Text("\u{201C}")
                .font(urbanistSemibold(22))
                .foregroundStyle(.tertiary)
                .frame(height: 12, alignment: .top)
                .clipped()
            Text(entry.text)
                .font(urbanistLight(13))
                .lineSpacing(1)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct LockScreenWidget: Widget {
    let kind = "LockScreenWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AffirmationProvider()) { entry in
            LockScreenView(entry: entry)
                .containerBackground(.clear, for: .widget)
                .widgetURL(deepLink(for: entry.id))
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
    AffirmationEntry(date: .now, text: "Les obstacles sont des opportunités déguisées.", category: "focus", streak: 5)
}

#Preview(as: .accessoryRectangular) {
    LockScreenWidget()
} timeline: {
    AffirmationEntry(date: .now, text: "Chaque action me rapproche de mon objectif.", category: "focus")
}
