//
//  Reppo.swift
//  Reppo
//
//  Created by Juan Hernandez Pazos on 23/06/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

/*
 1. Interfaz
 2. Borrar el original
 3. Cambiar el tamaño a mediano
 4. En Widget añadir: .supportedFamilies([.systemMedium])
 5. De vuelta a UI añadir después de Circle()
 6. Colocar las Labels
 7. Pasar las label a su propio struct
 8. Reemplazar los labels por el del struct
 9. Alinear la primera VSTack
 10. Separar y padding
 11. Estilo al nombre y poner días
 */

// MARK: UI
struct ReppoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            // 9
            VStack(alignment: .leading) {
                HStack {
                   Circle()
                        .frame(width: 50, height: 50)
                    
                    // 5
                    Text("Datafox iOS")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                } // HStack
                // 10
                .padding(.bottom, 6)
                
                // 6 no colocar al principio
                HStack {
//                    Label {
//                        Text("999")
//                    } icon: {
//                        Image(systemName: "star.fill")
//                            .foregroundStyle(.green)
//                    } // Label
                    StarLabel(value: 999, systemImageName: "star.fill")
                    StarLabel(value: 999, systemImageName: "tuningfork")
                    StarLabel(value: 999, systemImageName: "exclamationmark.triangle.fill")
                    
                } // HStack
            } // VStack
            
            // 10
            Spacer()
            
            VStack {
                Text("99") 
                // 11
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                
                Text("días")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } // VStack
        } // HStack
        // 10
        .padding()
    }
}

struct Reppo: Widget {
    let kind: String = "Reppo"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ReppoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ReppoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    Reppo()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

// fileprivate es para que sólo se pueda usar en este archivo
fileprivate struct StarLabel: View {
    
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(.green)
        } // Label
        .fontWeight(.medium)
    }
}
