//
//  LiveMatchDraftView.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import SwiftUI

struct LiveMatchPickHero: Identifiable, Hashable {
    var id: Int {
        return heroID
    }
    let heroID: Int
    let pickLevel: String
}

struct LiveMatchDraftView: View {
    let radiantPick: [LiveMatchPickHero]
    let radiantBan: [Int]
    let direPick: [LiveMatchPickHero]
    let direBan: [Int]
    let winRate: Double
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State var showDetail = true
    private let opacity: CGFloat = 0.5
    private let horizontalIconHeight: CGFloat = 40
    private let horizontalBanIconHeight: CGFloat = 25
    
    var body: some View {
        VStack {
            Button(action: { showDetail.toggle() }, label: {
                HStack {
                    Text("Draft").bold()
                        .foregroundColor(.label)
                    Spacer()
                    Text(showDetail ? "-" : "+").bold()
                        .foregroundColor(.label)
                }
            })
            .frame(height: 67)
            .padding(.horizontal)
            if showDetail {
                winRateView
                if horizontalSizeClass == .compact {
                    verticalView
                        .padding([.horizontal, .bottom])
                } else {
                    horizontalView
                        .padding([.horizontal, .bottom])
                }
            }
        }
        .background(Color.secondarySystemBackground)
    }
    
    private var winRateView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(winRate.description)%")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.green)
                Spacer()
                Text("\((100 - winRate).description)%")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.red)
            }
            ProgressView(value: winRate, total: 100)
                .progressViewStyle(.linear)
                .tint(.green)
                .background(.red)
                
        }.padding([.horizontal, .bottom])
    }
    
    private var horizontalView: some View {
        HStack {
            if radiantBan.count > 0 {
                VStack {
                    ForEach(radiantBan, id: \.self) { heroID in
                        HeroImageView(heroID: heroID, type: .icon)
                            .frame(width: horizontalBanIconHeight)
                            .grayscale(1)
                    }
                }
            }
            VStack {
                ForEach(radiantPick) { hero in
                    HStack {
                        HeroImageView(heroID: hero.heroID, type: .full)
                            .frame(height: horizontalIconHeight)
                            .cornerRadius(5)
                        Spacer()
                        Text(hero.pickLevel)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                            .foregroundColor(pickLevelColor(letter: hero.pickLevel))
                    }
                    .background(Color.tertiarySystemBackground)
                    .cornerRadius(5)
                }
                if radiantPick.count < 5 {
                    ForEach(0...(4 - radiantPick.count), id: \.self) { _ in
                        HStack {
                            Image("1_full")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: horizontalIconHeight)
                                .cornerRadius(5)
                                .foregroundColor(.green.opacity(opacity))
                            Spacer()
                            Text(" ")
                                .font(.caption)
                                .bold()
                                .padding(.horizontal)
                        }
                        .background(Color.tertiarySystemBackground)
                        .cornerRadius(5)
                    }
                }
            }
            Spacer()
                .frame(width: 20)
            VStack {
                ForEach(direPick) { hero in
                    HStack {
                        Text(hero.pickLevel)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                            .foregroundColor(pickLevelColor(letter: hero.pickLevel))
                        Spacer()
                        HeroImageView(heroID: hero.heroID, type: .full)
                            .frame(height: horizontalIconHeight)
                            .cornerRadius(5)
                    }
                    .background(Color.tertiarySystemBackground)
                    .cornerRadius(5)
                }
                if direPick.count < 5 {
                    ForEach(0...(4 - direPick.count), id: \.self) { _ in
                        HStack {
                            Text(" ")
                                .font(.caption)
                                .bold()
                                .padding(.horizontal)
                            Spacer()
                            Image("1_full")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: horizontalIconHeight)
                                .cornerRadius(5)
                                .foregroundColor(.red.opacity(opacity))
                        }
                        .background(Color.tertiarySystemBackground)
                        .cornerRadius(5)
                    }
                }
            }
            if direBan.count > 0 {
                VStack {
                    ForEach(direBan, id: \.self) { heroID in
                        HeroImageView(heroID: heroID, type: .icon)
                            .frame(width: horizontalBanIconHeight)
                            .grayscale(1)
                    }
                }
            }
        }
    }
    
    private var verticalView: some View {
        VStack {
            if radiantBan.count > 0 {
                HStack {
                    ForEach(radiantBan, id: \.self) { heroID in
                        Spacer()
                        HeroImageView(heroID: heroID, type: .icon)
                            .frame(width: 40)
                            .grayscale(1)
                        Spacer()
                    }
                }
            }
            HStack {
                ForEach(radiantPick) { hero in
                    HeroImageView(heroID: hero.heroID, type: .full)
                        .cornerRadius(5)
                }
                if radiantPick.count < 5 {
                    ForEach(0...(4 - radiantPick.count), id: \.self) { _ in
                        Image("1_full")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                            .foregroundColor(.green.opacity(opacity))
                    }
                }
            }
            HStack {
                ForEach(direPick) { hero in
                    HeroImageView(heroID: hero.heroID, type: .full)
                        .cornerRadius(5)
                }
                if direPick.count < 5 {
                    ForEach(0...(4 - direPick.count), id: \.self) { _ in
                        Image("1_full")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                            .foregroundColor(.red.opacity(opacity))
                    }
                }
            }
            if direBan.count > 0 {
                HStack {
                    ForEach(direBan, id: \.self) { heroID in
                        Spacer()
                        HeroImageView(heroID: heroID, type: .icon)
                            .frame(width: 40)
                            .grayscale(1)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func pickLevelColor(letter: String) -> Color {
        switch letter {
        case "S":
            return .purple
        case "A":
            return .green
        case "B":
            return .yellow
        case "C":
            return .orange
        case "D":
            return .red
        case "F":
            return .gray
        default:
            return .black
        }
    }
}

struct LiveMatchDraftView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchDraftView(radiantPick: [
            .init(heroID: 1, pickLevel: "A"),
            .init(heroID: 2, pickLevel: "S"),
            .init(heroID: 3, pickLevel: "C"),
            .init(heroID: 4, pickLevel: "D"),
            .init(heroID: 5, pickLevel: "F")],
                           radiantBan: [6, 7, 8, 9, 10, 11, 12],
                           direPick: [],
                           direBan: [18, 19, 20, 21, 22, 23],
                           winRate: 50, showDetail: true)
        .previewLayout(.fixed(width: 700, height: 500))
        .preferredColorScheme(.dark)
    }
}
