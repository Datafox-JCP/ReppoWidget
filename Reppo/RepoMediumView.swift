//
//  RepoMediumView.swift
//  ReppoWidget
//
//  Created by Juan Hernandez Pazos on 02/07/24.
//

import SwiftUI
import WidgetKit

struct RepoMediumView: View {

    let repo: Repository
    let formatter = ISO8601DateFormatter()
    
    var daysSinceLastActivty: Int{
        calculateDaysSinceLastActivity(from: repo.pushedAt)
    }
    
    var body: some View {
        HStack {
            // 9
            VStack(alignment: .leading) {
                HStack {
                    //                   Circle()
//                    Image(uiImage: UIImage(named: "avatar")!)
                    // 29
                    Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    // 5
                    //                    Text("Datafox iOS") 15
                    Text(repo.name)
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
                    StarLabel(value: repo.watchers, systemImageName: "star.fill")
                    StarLabel(value: repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues {
                        StarLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    }
                    
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
    }
    
    
    // 16
    func calculateDaysSinceLastActivity(from dateString: String) -> Int {
        let lastActivityDate = formatter.date(from: dateString) ?? .now
        let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
        
        return daysSinceLastActivity
    }
}

#Preview {
    RepoMediumView(repo: MockData.repoOne)
        .containerBackground(.fill.tertiary, for: .widget)
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
