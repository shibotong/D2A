//
//  LiveMatchActivity.swift
//  D2A
//
//  Created by Shibo Tong on 17/6/2023.
//

import Foundation
import ActivityKit
import UIKit

@available(iOS 16.1, *)
class LiveMatchActivity {
    
    static var shared = LiveMatchActivity()
    
    private var currentActivity: Activity<LiveMatchActivityAttributes>?
    
    init() {
        
    }
    
    func startActivity(radiantScore: Int,
                       direScore: Int,
                       time: Int,
                       radiantIcon: String?,
                       direIcon: String?,
                       league: String?,
                       leagueName: String?) async {
        await loadTeamIcon(iconURL: radiantIcon, key: "liveActivity.radiantTeam")
        await loadTeamIcon(iconURL: direIcon, key: "liveActivity.direTeam")
        if let league {
            await loadTeamIcon(iconURL: "https://cdn.stratz.com/images/dota2/leagues/\(league).png", key: "liveActivity.league")
        } else {
            await loadTeamIcon(iconURL: nil, key: "liveActivity.league")
        }
    
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Activities are not enabled")
            return
        }
        // Here is your code
        do {
            let attributes = LiveMatchActivityAttributes(leagueName: leagueName)
            let contentState = LiveMatchActivityAttributes.ContentState(radiantScore: 0, direScore: 0, time: 0)
            let activity = try Activity<LiveMatchActivityAttributes>.request(
                attributes: attributes,
                contentState: contentState
            )
            self.currentActivity = activity
            print("start activity")
        } catch {
            print("LiveActivityManager: Error in LiveActivityManager: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func updateActivity(radiantScore: Int,
                        direScore: Int,
                        time: Int) async {
        print("update activity")
        let contentState = LiveMatchActivityAttributes.ContentState(radiantScore: radiantScore, direScore: direScore, time: time)
        await currentActivity?.update(using: contentState)
    }
    
    @MainActor
    func endActivity() async {
        print("end activity")
        await currentActivity?.end(dismissalPolicy: .immediate)
    }
    
    func activityState() -> ActivityState? {
        return currentActivity?.activityState
    }
    
    private func loadTeamIcon(iconURL: String?, key: String) async {
        if let iconURL {
            let url = URL(string: iconURL)!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data), let imageData = image.pngData() else {
                    print("Error converting image data")
                    return
                }
                UserDefaults(suiteName: GROUP_NAME)?.set(imageData, forKey: key)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            UserDefaults(suiteName: GROUP_NAME)?.set(nil, forKey: key)
        }
    }
}
