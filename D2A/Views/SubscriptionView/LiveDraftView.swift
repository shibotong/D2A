//
//  LiveDraftView.swift
//  D2A
//
//  Created by Shibo Tong on 24/10/2022.
//

import SwiftUI

struct LiveDraftView: View {
    
    var drafts: [BanPick]
    
    @Environment (\.horizontalSizeClass) private var horizontalClass
    
    private var emptyPick: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray, .black], startPoint: .leading, endPoint: .trailing)
            Image("dota_armory_icon")
                .resizable()
                .scaledToFit()
                .padding(10)
                .cornerRadius(5)
                .clipped()
        }
    }
    
    private var emptyBan: some View {
        LinearGradient(colors: [.black, .gray, .black], startPoint: .leading, endPoint: .trailing)
    }
    
    private var compactDraft: some View {
        HStack(spacing: 5) {
            VStack {
                buildHeroes(isRadiant: true, isPicked: false)
            }
            VStack {
                buildHeroes(isRadiant: true, isPicked: true)
            }
            Spacer()
            VStack {
                buildHeroes(isRadiant: false, isPicked: true)
            }
            VStack {
                buildHeroes(isRadiant: false, isPicked: false)
            }
        }
    }
    
    private var regularDraft: some View {
        HStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    buildHeroes(isRadiant: true, isPicked: true)
                }
                HStack(spacing: 0) {
                    buildHeroes(isRadiant: true, isPicked: false)
                }
            }
            Spacer()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    buildHeroes(isRadiant: false, isPicked: true)
                }
                HStack(spacing: 0) {
                    buildHeroes(isRadiant: false, isPicked: false)
                }
            }
        }
    }
    
    var body: some View {
        if horizontalClass == .compact {
            compactDraft
        } else {
            regularDraft
        }
    }
    
    @ViewBuilder private func buildHeroes(isRadiant: Bool, isPicked: Bool) -> some View {
        let heroes = drafts.filter { $0.isRadiant == isRadiant && $0.isPick == isPicked }
        let totalHeroes = isPicked ? 5 : 7
        let horizontal = horizontalClass == .regular
        ForEach(0..<totalHeroes, id:\.self) { slot in
            if slot < heroes.count {
                let hero = heroes[slot]
                if isPicked {
                    HeroImageView(heroID: hero.heroID, type: horizontal ? .vert : .full)
                } else {
                    HeroImageView(heroID: hero.heroID, type: horizontal ? .full : .icon)
                        .grayscale(1)
                }
            } else {
                if isPicked {
                    HeroImageView(heroID: 1, type: horizontal ? .vert : .full)
                        .opacity(0)
                        .overlay(emptyPick)
                } else {
                    HeroImageView(heroID: 1, type: horizontal ? .full : .icon)
                        .opacity(0)
                        .overlay(emptyBan)
                }
            }
        }
    }
}

struct LiveDraftView_Previews: PreviewProvider {
    @State static var drafts: [BanPick] = BanPick.preview
    static var previews: some View {
        LiveDraftView(drafts: [])
    }
}
