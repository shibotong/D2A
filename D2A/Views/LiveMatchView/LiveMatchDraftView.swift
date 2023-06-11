//
//  LiveMatchDraftView.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import SwiftUI

struct LiveMatchDraftView: View {
    let radiantPick: [Int]
    let radiantBan: [Int]
    let direPick: [Int]
    let direBan: [Int]
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State var showDetail = true
    private let opacity: CGFloat = 0.5
    
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
            if showDetail {
                if horizontalSizeClass == .compact {
                    verticalView
                } else {
                    horizontalView
                }
            }
        }
        .padding()
        .background(Color.secondarySystemBackground)
    }
    
    private var horizontalView: some View {
        HStack {
            if radiantBan.count > 0 {
                VStack {
                    ForEach(radiantBan, id: \.self) { heroID in
                        HeroImageView(heroID: heroID, type: .icon)
                            .frame(width: 30)
                            .grayscale(1)
                    }
                }
            }
            VStack {
                ForEach(radiantPick, id: \.self) { heroID in
                    HStack {
                        HeroImageView(heroID: heroID, type: .full)
                            .frame(height: 50)
                            .cornerRadius(5)
                        Spacer()
                    }
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(5)
                }
                if radiantPick.count < 5 {
                    ForEach(0...(4 - radiantPick.count), id: \.self) { _ in
                        HStack {
                            Image("1_full")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .cornerRadius(5)
                                .foregroundColor(.green.opacity(opacity))
                            Spacer()
                        }
                        .background(Color.secondarySystemBackground)
                        .cornerRadius(5)
                    }
                }
            }
            Spacer()
                .frame(width: 40)
            VStack {
                ForEach(direPick, id: \.self) { heroID in
                    HStack {
                        Spacer()
                        HeroImageView(heroID: heroID, type: .full)
                            .frame(height: 50)
                            .cornerRadius(5)
                    }
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(5)
                }
                if direPick.count < 5 {
                    ForEach(0...(4 - direPick.count), id: \.self) { _ in
                        HStack {
                            Spacer()
                            Image("1_full")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .cornerRadius(5)
                                .foregroundColor(.red.opacity(opacity))
                        }
                        .background(Color.secondarySystemBackground)
                        .cornerRadius(5)
                    }
                }
            }
            if direBan.count > 0 {
                VStack {
                    ForEach(direBan, id: \.self) { heroID in
                        HeroImageView(heroID: heroID, type: .icon)
                            .frame(width: 30)
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
                ForEach(radiantPick, id: \.self) { heroID in
                    HeroImageView(heroID: heroID, type: .full)
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
                ForEach(direPick, id: \.self) { heroID in
                    HeroImageView(heroID: heroID, type: .full)
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
    
}

struct LiveMatchDraftView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchDraftView(radiantPick: [1, 2, 3, 4], radiantBan: [6, 7, 8, 9, 10, 11, 12], direPick: [13, 14, 15], direBan: [18, 19, 20, 21, 22, 23], showDetail: true)
    }
}
