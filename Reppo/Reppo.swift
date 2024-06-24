//
//  Reppo.swift
//  Reppo
//
//  Created by Juan Hernandez Pazos on 23/06/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), emoji: "😀", repo: Repository.placeHolder)
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), emoji: "😀", repo: Repository.placeHolder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RepoEntry] = []

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let repo: Repository
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
 12. Crear Repository
 13. Cambiar SimpleEntry a RepoEntry
 14. let repo: Repository en RepoEntry y corregir errores
 15. Cambiar var entry: Provider.Entry a RepoEntry y actualuzar form
 */

// MARK: UI
struct ReppoEntryView : View {
    var entry: RepoEntry
    
    var body: some View {
        HStack {
            // 9
            VStack(alignment: .leading) {
                HStack {
                   Circle()
                        .frame(width: 50, height: 50)
                    
                    // 5
//                    Text("Datafox iOS") 15
                    Text(entry.repo.name)
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
                    StarLabel(value: entry.repo.watchers, systemImageName: "star.fill")
                    StarLabel(value: entry.repo.forks, systemImageName: "tuningfork")
                    StarLabel(value: entry.repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    
//                    StarLabel(value: 999, systemImageName: "star.fill") // 15
//                    StarLabel(value: 999, systemImageName: "tuningfork") // 15
//                    StarLabel(value: 999, systemImageName: "exclamationmark.triangle.fill") // 15
                    
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
    RepoEntry(date: .now, emoji: "😀", repo: Repository.placeHolder)
    RepoEntry(date: .now, emoji: "🤩", repo: Repository.placeHolder)
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
