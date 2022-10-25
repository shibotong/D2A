//
//  SeriesRowView.swift
//  D2A
//
//  Created by Shibo Tong on 26/10/2022.
//

import SwiftUI

struct SeriesRowView: View {
    
    var series: [LeagueSeries]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Upcoming DPC Series")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(series.sorted(by: { $0.scheduledTime ?? 0 < $1.scheduledTime ?? 0 }), id: \.id) { series in
                        SeriesItem(series: series)
                    }
                }
            }
        }
    }
}

struct SeriesRowView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesRowView(series: [])
    }
}
