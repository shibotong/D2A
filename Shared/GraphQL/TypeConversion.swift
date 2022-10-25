//
//  TypeConversion.swift
//  D2A
//
//  Created by Shibo Tong on 23/9/2022.
//

import Foundation

public typealias Short = Double
public typealias Byte = Int
public typealias Long = Int
public typealias UShort = Double

public typealias PlayerLive = MatchLiveSubscription.Data.MatchLive.Player
public typealias MatchLive = MatchLiveSubscription.Data.MatchLive
public typealias BuildingEventLive = MatchLiveSubscription.Data.MatchLive.PlaybackDatum.BuildingEvent
public typealias BuildingEventHistory = MatchLiveHistoryQuery.Data.Live.Match.PlaybackDatum.BuildingEvent

public typealias League = LeaguesListQuery.Data.League
public typealias LeagueSeries = LeaguesListQuery.Data.League.NodeGroup.Node
