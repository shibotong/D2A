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
  let hasBan: Bool
  @Binding var showDetail: Bool

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  private let opacity: CGFloat = 0.5
  private let horizontalIconHeight: CGFloat = 40
  private let horizontalBanIconHeight: CGFloat = 25

  var body: some View {
    VStack {
      Button(
        action: { showDetail.toggle() },
        label: {
          HStack {
            Text("Draft").bold()
              .foregroundColor(.label)
            Spacer()
            Text(showDetail ? "-" : "+").bold()
              .foregroundColor(.label)
          }
        }
      )
      .padding()
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
      if hasBan {
        buildBanHero(heroes: radiantBan)
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
      if hasBan {
        buildBanHero(heroes: direBan)
      }
    }
  }

  private var verticalView: some View {
    VStack {
      if hasBan {
        buildBanHero(heroes: radiantBan)
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
      if hasBan {
        buildBanHero(heroes: direBan)
      }
    }
  }

  @ViewBuilder
  private func buildBanHero(heroes: [Int]) -> some View {
    if horizontalSizeClass == .compact {
      HStack {
        ForEach(heroes, id: \.self) { heroID in
          Spacer()
          HeroImageView(heroID: heroID, type: .icon)
            .grayscale(1)
          Spacer()
        }
        if heroes.count < 7 {
          ForEach(0...(6 - direBan.count), id: \.self) { _ in
            Spacer()
            HeroImageView(heroID: 0, type: .icon)
            Spacer()
          }
        }
      }
    } else {
      VStack {
        ForEach(heroes, id: \.self) { heroID in
          HeroImageView(heroID: heroID, type: .icon)
            .frame(width: horizontalBanIconHeight, height: horizontalBanIconHeight)
            .grayscale(1)
        }
        if heroes.count < 7 {
          ForEach(0...(6 - heroes.count), id: \.self) { _ in
            HeroImageView(heroID: 0, type: .icon)
              .frame(width: horizontalBanIconHeight, height: horizontalBanIconHeight)
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
  @State static var showDetail = true
  static var previews: some View {
    Group {
      ForEach(PreviewDevice.iPhoneDevices, id: \.rawValue) { device in
        LiveMatchDraftView(
          radiantPick: [.init(heroID: 1, pickLevel: "A")], radiantBan: [], direPick: [],
          direBan: [], winRate: 0.5, hasBan: true, showDetail: $showDetail
        )
        .previewDevice(device)
        .previewDisplayName(device.rawValue)
      }
    }
  }
}
