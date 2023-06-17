//
//  LiveMatchActivity.swift
//  D2A
//
//  Created by Shibo Tong on 17/6/2023.
//

import Foundation
import ActivityKit

@available(iOS 16.1, *)
class LiveMatchActivity {
    
    static var shared = LiveMatchActivity()
    
    private var currentActivity: Activity<LiveMatchActivityAttributes>?
    
    init() {
        
    }
    
    @MainActor
    func startActivity(radiantScore: Int,
                       direScore: Int,
                       time: Int,
                       radiantIcon: String? = nil,
                       direIcon: String? = nil) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Activities are not enabled")
            return
        }
        // Here is your code
        print(radiantIcon)
        print(direIcon)
        do {
            let attributes = LiveMatchActivityAttributes(
                radiantTeam: radiantIcon,
                direTeam: direIcon
            )
            let contentState = LiveMatchActivityAttributes.ContentState(radiantScore: radiantScore, direScore: direScore, time: time)
            let activity = try Activity<LiveMatchActivityAttributes>.request(
                attributes: attributes,
                contentState: contentState
            )
            currentActivity = activity
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
}
