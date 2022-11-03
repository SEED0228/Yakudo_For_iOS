//
//  LockYakudo.swift
//  YakudoForiOS
//
//  Created by 多根直輝 on 2022/11/03.
//

import WidgetKit
import SwiftUI
import Intents

struct LockYakudoEntryView : View {
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

@available(iOS 16.0, *)
struct LockYakudo: Widget {
    let kind: String = "LockYakudo"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LockYakudoEntryView(entry: entry)
        }
        .configurationDisplayName("Yakudo ショートカット")
        .description("Yakudoを起動することができます")
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}

@available(iOS 16.0, *)
struct LockYakudo_Previews: PreviewProvider {
    static var previews: some View {
        LockYakudoEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}

