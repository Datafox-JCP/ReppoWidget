//
//  Reppo.swift
//  Reppo
//
//  Created by Juan Hernandez Pazos on 23/06/24.
//

import WidgetKit
import SwiftUI

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
 15. Cambiar var entry: Provider.Entry a RepoEntry y actualizar form
 16. Caluclar días desde la última actividad, el formatter se coloca fuera de la función porque se va a usar varias veces
 17. Crrar el network manager
 18. Ajustar getTimeline
 19. Añadir la función downloadImageData en repository
 20. Poner imagen en assets
 21. Usar la función para cargar la imagen en getTimeline
 22. Añadir la variable en RepoEntry
 23. y corregir los errores
 24. Finalmente en el view usar la imagen en vez del circle
 */

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
//        RepoEntry(date: Date(), repo: Repository.placeHolder)
        RepoEntry(date: Date(), repo: Repository.placeHolder, avatarImageData: Data())
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
//        let entry = RepoEntry(date: Date(), repo: Repository.placeHolder)
        let entry = RepoEntry(date: Date(), repo: Repository.placeHolder, avatarImageData: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping
                     (Timeline<Entry>) -> ()) {
        // Para volverla una función asincrona ponerla en Task
        Task {
            let nextUpdate = Date().addingTimeInterval(42000) // 12 horas en segs.
            
            do {
                let repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftNews)
                // 21 esto va después
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
//                let entry = RepoEntry(date: .now, repo: repo)
                let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatarImageData ?? Data())
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let avatarImageData: Data // 23
}

// MARK: UI
struct ReppoEntryView : View {
    var entry: RepoEntry
    
    // 16
    let formatter = ISO8601DateFormatter() // "updated_at": "2024-05-19T01:36:56Z" pushedAt: "2024-06-24T18:19:30Z"
    var daysSinceLastActivty: Int{
        calculateDaysSinceLastActivity(from: entry.repo.pushedAt)
    }
    
    var body: some View {
        HStack {
            // 9
            VStack(alignment: .leading) {
                HStack {
//                   Circle()
                    Image(uiImage: UIImage(data: entry.avatarImageData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
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
                // 17 usar función
                Text("\(daysSinceLastActivty)")
                // 11
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(daysSinceLastActivty >= 30 ? .pink : .green)
                
                Text("días")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } // VStack
        } // HStack
        // 10
        .padding()
    }
    
    // 16
    func calculateDaysSinceLastActivity(from dateString: String) -> Int {
        let lastActivityDate = formatter.date(from: dateString) ?? .now
        let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
        
        return daysSinceLastActivity
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
//    RepoEntry(date: .now, repo: Repository.placeHolder)
    RepoEntry(date: .now, repo: Repository.placeHolder, avatarImageData: Data())
//    RepoEntry(date: .now, repo: Repository.placeHolder)
    RepoEntry(date: .now, repo: Repository.placeHolder, avatarImageData: Data())
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
