//
//  CalendarMatchListView.swift
//  App
//
//  Created by Shibo Tong on 12/6/2022.
//

import SwiftUI

struct CalendarMatchListView: View {
    @StateObject var vm: CalendarMatchListViewModel
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $vm.selectDate, in: PartialRangeThrough(Date()), displayedComponents: [.date])
                .datePickerStyle(.graphical)
            if vm.isLoading {
                ProgressView()
            } else {
                if vm.matchesOnDate.isEmpty {
                    Text("No Result")
                        .foregroundColor(.secondaryLabel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.secondarySystemBackground)
                } else {
                    ScrollView {
                        VStack(spacing: 1) {
                            ForEach(vm.matchesOnDate) { match in
                                NavigationLink(destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)"))) {
                                    MatchListRowView(vm: MatchListRowViewModel(match: match))
                                        .background(Color.systemBackground)
                                }
                            }
                        }
                    }
                    .background(Color.secondarySystemBackground)
                }
            }
        }
    }
}

struct CalendarMatchListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMatchListView(vm: CalendarMatchListViewModel(userid: "153041957"))
    }
}
