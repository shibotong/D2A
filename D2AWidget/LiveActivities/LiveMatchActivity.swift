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
                       direIcon: String?) async {
        
        await loadTeamIcon(iconURL: radiantIcon, isRadiant: true)
        await loadTeamIcon(iconURL: direIcon, isRadiant: false)
    
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Activities are not enabled")
            return
        }
        // Here is your code
        do {
            let attributes = LiveMatchActivityAttributes()
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
    
    private func loadTeamIcon(iconURL: String?, isRadiant: Bool) async {
        let key = isRadiant ? "radiantTeam" : "direTeam"
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
