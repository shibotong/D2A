//
//  ProfileView.swift
//  App
//
//  Created by Shibo Tong on 3/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View, Equatable {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: ProfileViewModel
    @AppStorage("selectedUser") var selectedUser: String?
    
    @Binding var presentState: PresentationMode
    
    var body: some View {
        if vm.isloading {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.frame(height: 60)
        } else {
            if vm.userProfile == nil {
                VStack {
                    Spacer()
                    Text("Cannot find user profile.")
                        .foregroundColor(Color(.systemGray4))
                    Spacer()
                }.frame(height: 60)
            }
            else {
                HStack {
                    WebImage(url: URL(string: vm.userProfile!.avatarfull))
                        .resizable()
                        .renderingMode(.original)
                        .indicator(.activity)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    VStack(alignment: .leading) {
                        Text("\(vm.userProfile!.personaname)").font(.custom(fontString, size: 20)).bold()
                        if vm.userProfile!.countryCode != nil {
                            Text(vm.userProfile!.countryCode!).font(.custom(fontString, size: 13))
                        } else {
                            Text("ID: \(vm.userProfile!.id.description)").font(.custom(fontString, size: 13))
                        }
                    }
                    Spacer()
                    Button(action: {
                        if selectedUser == nil {
                            selectedUser = "\(vm.userProfile!.id)"
                        }
                        if env.userIDs.count < 1 || env.subscriptionStatus {
                            env.addUser(userid: "\(vm.userProfile!.id)")
                        } else {
                            self.presentState.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                // show subscription after 0.5s
                                self.env.subscriptionSheet = true
                            })
                        }
                    }) {
                        Image(systemName: env.userIDs.contains("\(vm.userProfile!.id)") ? "star.fill" :"star")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(env.userIDs.contains("\(vm.userProfile!.id)") ? .secondaryDota : .primaryDota))
                    }
                }
                .frame(height: 60)
            }
        }
    }
    static func == (lhs: ProfileView, rhs: ProfileView) -> Bool {
        return lhs.vm.userid == rhs.vm.userid
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    @Binding var present: PresentationMode  = .constant(false)
//    static var previews: some View {
//        ProfileView(vm: ProfileViewModel(), presentState: present)
//            .environmentObject(DotaEnvironment.shared)
//        ProfileEmptyView()
//    }
//}
struct ProfileEmptyView: View {
    var body: some View {
        HStack {
            Image("profile")
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            VStack(alignment: .leading) {
                Text("Anonymous").font(.custom(fontString, size: 20)).bold()
                Text(" ").font(.custom(fontString, size: 13))
            }
            Spacer()
        }
        .frame(height: 60)
    }
}
