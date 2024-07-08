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
 25. Mover el view y ajustarlo e RepoMediumView
 26. Añadir la familia
 27. Añadir la segunda entrada
 28. Ajustar reposotory añadiendo extensión
 29. Ajustar RepoMeidumView
 30. Ajustar RepoEntry: TimelineEntry y corregir los errores borrando avatarImageData
 31. Modificar timlineprovider para preparar para extender el widget
 32. Corregir los errores 
 33. Crear el struct MockData y ajustar errores
 34. Ajustar getTileline
 35. Ajustar el body
 */

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
//        RepoEntry(date: Date(), repo: Repository.placeHolder)
//        RepoEntry(date: Date(), repo: Repository.placeHolder, avatarImageData: Data())
        //30
//        RepoEntry(date: Date(), repo: Repository.placeHolder)
        // 31
        RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
//        let entry = RepoEntry(date: Date(), repo: Repository.placeHolder)
//        let entry = RepoEntry(date: Date(), repo: Repository.placeHolder, avatarImageData: Data())
        // 30
        let entry = RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping
                     (Timeline<Entry>) -> ()) {
        // Para volverla una función asincrona ponerla en Task
        Task {
            let nextUpdate = Date().addingTimeInterval(42000) // 12 horas en segs.
            
            do {
                // 30
//                let repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftNews)
                // Obtener top repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftNews)
                // 21 esto va después
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
//                let entry = RepoEntry(date: .now, repo: repo)
//                let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatarImageData ?? Data())
                // 30
                repo.avatarData = avatarImageData ?? Data()
                
                // Obtener bottomRepo si es large widget
                var bottomRepo: Repository?
                
                if context.family == .systemLarge {
                    bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.google)
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    bottomRepo!.avatarData = avatarImageData ?? Data()
                }
                
                
                // Crear entry & timeline
                let entry = RepoEntry(date: .now, repo: repo, bottomRepo: nil)
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
//    let avatarImageData: Data // 23
    // 33
    let bottomRepo: Repository?
}

// MARK: UI
struct ReppoEntryView : View {
    // 26
    @Environment(\.widgetFamily) var family
    
    var entry: RepoEntry
    
    var body: some View {
        // 26
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
//            RepoMediumView(repo: entry.repo)
            // 27
            VStack(spacing: 36) {
                RepoMediumView(repo: entry.repo)
                // 35
                if let bottomRepo = entry.bottomRepo {
                    RepoMediumView(repo: bottomRepo)
                }
            }
        case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
        
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
        .configurationDisplayName("Repo Widget")
        .description("Mantenerse al tanto de uno o dos repositorios en GitHub")
        .supportedFamilies([.systemMedium, .systemLarge]) // 26 añadir .systemLarge
    }
}

// 25 cambiar a .systemLarge
#Preview(as: .systemLarge) {
    Reppo()
} timeline: {
//    RepoEntry(date: .now, repo: Repository.placeHolder)
    RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
//    RepoEntry(date: .now, repo: Repository.placeHolder)
    RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
}
