//
//  UserMatchRefreshHandlerTests.swift
//  D2A
//
//  Created by Codex on 18/10/2026.
//


import Foundation
import Testing
@testable import D2A

struct UserMatchRefreshHandlerTests {

    @Test
    func `first refresh is allowed`() async {
        let handler = makeHandler()

        let canRefresh = await handler.canRefresh(userid: "player")

        #expect(canRefresh)
    }

    @Test
    func `repeated refresh inside interval is rejected`() async {
        let handler = makeHandler()

        #expect(await handler.canRefresh(userid: "player"))
        #expect(!(await handler.canRefresh(userid: "player")))
    }

    @Test
    func `refresh limits are tracked independently per user`() async {
        let handler = makeHandler()

        #expect(await handler.canRefresh(userid: "first-player"))
        #expect(await handler.canRefresh(userid: "second-player"))
        #expect(!(await handler.canRefresh(userid: "first-player")))
    }

    @Test
    func `refresh is allowed after interval has elapsed`() async {
        let clock = TestClock(now: 100)
        let handler = makeHandler(clock: clock)
        #expect(await handler.canRefresh(userid: "player"))

        clock.now = 110
        #expect(!(await handler.canRefresh(userid: "player")))

        clock.now = 110.001
        #expect(await handler.canRefresh(userid: "player"))
    }

    private func makeHandler(clock: TestClock = TestClock(now: 100)) -> UserMatchRefreshHandler {
        UserMatchRefreshHandler(refreshDistance: 10) { clock.now }
    }
}

private final class TestClock: @unchecked Sendable {
    var now: TimeInterval

    init(now: TimeInterval) {
        self.now = now
    }
}
