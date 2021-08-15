//
//  DifferenceGraphView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

struct DifferenceGraphView: View {
    var goldDiff: [Int]
    var xpDiff: [Int]
    var body: some View {
        HStack {
            ZStack {
                BackgroundLine(max: fetchLargestABS())
                DrawDiffLines(data: goldDiff, max: fetchLargestABS()).foregroundColor(.yellow)
                DrawDiffLines(data: xpDiff, max: fetchLargestABS()).foregroundColor(.blue)
            }
            VStack(alignment: .leading) {
                Text("+\(fetchLargestABS().description)").foregroundColor(Color(.systemGreen))
                Spacer()
                Text("0")
                Spacer()
                Text("+\(fetchLargestABS().description)").foregroundColor(Color(.systemRed))
            }.font(.caption2)
        }.frame(height: 250)
    }
    
    private func fetchLargestABS() -> Int{
        var proxyGold = goldDiff
        var proxyXP = xpDiff
        for i in 0..<proxyGold.count {
            if proxyGold[i] < 0 {
                proxyGold[i] = -proxyGold[i]
            }
            if proxyXP[i] < 0 {
                proxyXP[i] = -proxyXP[i]
            }
        }
        proxyGold.append(contentsOf: proxyXP)
        let largest = proxyGold.max()!
        let max = (largest / 5000) * 5000 + 5000
        return max
    }
}


struct DifferenceGraphView_Previews: PreviewProvider {
    static var previews: some View {
        DifferenceGraphView(goldDiff: Match.sample.goldDiff, xpDiff: Match.sample.xpDiff)
    }
}

struct DrawDiffLines: View {
    var data: [Int]
    var max: Int
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                path.move(to: CGPoint(x: 0, y: proxy.size.height / 2))
                data.enumerated().forEach { index, item in
                    path.addLine(to: CGPoint(x: CGFloat(proxy.size.width) * CGFloat(index) / CGFloat(data.count - 1), y: (CGFloat(max - item) / CGFloat(max * 2)) * CGFloat(proxy.size.height)))
                }
            }.stroke()
        }
        
    }
}

struct BackgroundLine: View {
    var max: Int
    var body: some View {
        VStack {
            Group {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(.systemGreen))
                Spacer()
                ForEach(0..<countLines(), id: \.self) { count in
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.systemGray6))
                    Spacer()
                }
            }
            Rectangle().frame(height: 1).foregroundColor(Color(.systemGray4))
            
            Group {
                ForEach(0..<countLines(), id: \.self) { count in
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.systemGray6))
                }
                Spacer()
                Rectangle().frame(height: 1)
                    .foregroundColor(Color(.systemRed))
            }
        }
    }
    
    private func countLines() -> Int {
        return (max - 1) / 5000
    }
}
