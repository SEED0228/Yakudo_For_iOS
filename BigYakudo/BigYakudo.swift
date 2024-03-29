//
//  BigYakudo.swift
//  BigYakudo
//
//  Created by SEED on 2021/04/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct BigYakudoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("ramen")
                .resizable()
                .frame(maxWidth: .infinity, alignment: .center)
//            Text(entry.date, style: .time)
//                .font(.system(size: 30))
        }
        
    }
}

struct BigYakudo: Widget {
    let kind: String = "BigYakudo"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BigYakudoEntryView(entry: entry)
        }
        .configurationDisplayName("Yakudo ショートカット")
        .description("Yakudoを起動することができます")
    }
}

struct BigYakudo_Previews: PreviewProvider {
    static var previews: some View {
        BigYakudoEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
