//
//  PlayerRowView.swift
//  App
//
//  Created by Shibo Tong on 6/6/2022.
//

import SwiftUI

struct PlayerListRowView: View {
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var profile: FetchedResults<UserProfile>
    private var userid: String
    
    init(userid: String) {
        self.userid = userid
        _profile = FetchRequest<UserProfile>(sortDescriptors: [], predicate: NSPredicate(format: "id == %@", userid))
    }
    
    var body: some View {
        ZStack {
            if let profile = profile.first {
                VStack(spacing: 0) {
                    ProfileAvartar(profile: profile, sideLength: 50, cornerRadius: 25)
                    Spacer().frame(height: 10)
                    HStack(spacing: 0) {
                        if profile.name != nil {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption2)
                        }
                        Text(profile.name ?? profile.personaname ?? "")
                            .font(.custom(fontString, size: 12))
                            .bold()
                            .lineLimit(1)
                            .foregroundColor(Color(UIColor.label))
                    }
                    
                    HStack(spacing: 0) {
                        Image("rank_\((profile.rank) / 10)")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(DataHelper.transferRank(rank: Int(profile.rank)))
                            .font(.custom(fontString, size: 10))
                            .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                    }
                    Text(profile.id ?? "")
                        .font(.custom(fontString, size: 9))
                        .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                }
                .padding()
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            env.delete(userID: profile.id ?? "")
                        } label: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.primaryDota)
                                .font(.caption)
                        }
                        Spacer()
                    }
                }
                .padding(6)
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            await loadProfile()
                        }
                    }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private func loadProfile() async {
        let user = try? await OpenDotaController.shared.loadUserData(userid: userid)
        user?.favourite = true
        try? viewContext.save()
    }
}

struct PlayerListRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListRowView(userid: "153041957")
            .previewLayout(.fixed(width: 100, height: 150))
            .environmentObject(DotaEnvironment.preview)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
