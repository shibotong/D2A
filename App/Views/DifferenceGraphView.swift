//
//  DifferenceGraphView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

struct DifferenceGraphView: View {
    var goldDiff: [Int]?
    var xpDiff: [Int]?
    @State var mins: Double
    init(goldDiff: [Int]?, xpDiff: [Int]?) {
        self.goldDiff = goldDiff
        self.xpDiff = xpDiff
        if goldDiff != nil {
            self.mins = Double(goldDiff!.count - 1)
        } else {
            self.mins = 0
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Difference In Gold/XP Earned").font(.custom(fontString, size: 20)).bold().padding(20)
                Spacer()
            }
            if goldDiff == nil {
                Spacer()
                HStack {
                    Spacer()
                    Text("Gold/XP difference is not available.").foregroundColor(Color(.tertiaryLabel)).font(.custom(fontString, size: 15))
                    Spacer()
                }
                Spacer()
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(Int(mins)):00").font(.custom(fontString, size: 10)).bold().foregroundColor(Color(.secondaryLabel))
                        HStack {
                            Circle().frame(width: 10, height: 10).foregroundColor(.yellow)
                            Text("\(abs(goldDiff![Int(mins)]))").foregroundColor(Color(goldDiff![Int(mins)] >= 0 ? .systemGreen : .systemRed)).font(.custom(fontString, size: 15)).bold()
                        }
                        HStack {
                            Circle().frame(width: 10, height: 10).foregroundColor(.blue)
                            Text("\(abs(xpDiff![Int(mins)]))").foregroundColor(Color(xpDiff![Int(mins)] >= 0 ? .systemGreen : .systemRed)).font(.custom(fontString, size: 15)).bold()
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.bottom, -30)
                Spacer()
                ZStack {
                    BackgroundLine(max: fetchLargestABS())
                    DrawDiffLines(data: xpDiff!, max: fetchLargestABS(), selectedTime: goldDiff!.count - 1).foregroundColor(Color(.secondaryLabel).opacity(0.1)).clipped()
                    DrawDiffLines(data: goldDiff!, max: fetchLargestABS(), selectedTime: goldDiff!.count - 1).foregroundColor(Color(.secondaryLabel).opacity(0.1)).clipped()
                    DrawDiffLines(data: xpDiff!, max: fetchLargestABS(), selectedTime: Int(mins)).foregroundColor(.blue).clipped().shadow(radius: 1)
                    DrawDiffLines(data: goldDiff!, max: fetchLargestABS(), selectedTime: Int(mins)).foregroundColor(.yellow).clipped().shadow(radius: 1)
                    
                    GeometryReader { proxy in
                        Rectangle()
                            .foregroundColor(Color(.secondaryLabel).opacity(0.1))
                            .frame(width: 1)
                            .offset(x: CGFloat(proxy.size.width) * CGFloat(mins) / CGFloat(goldDiff!.count - 1), y: 0)
                    }
                    CurrentPoint(data: xpDiff!, max: fetchLargestABS(), selectedTime: Int(mins)).foregroundColor(.blue)
                    CurrentPoint(data: goldDiff!, max: fetchLargestABS(), selectedTime: Int(mins)).foregroundColor(.yellow)
                    
                }.frame(maxHeight: 300)
                HStack {
                    Text("0:00").font(.custom(fontString, size: 15)).foregroundColor(Color(.secondaryLabel))
                    Slider(value: $mins, in: 0...Double(goldDiff!.count - 1), step: 1)
                        .accentColor(.secondaryDota)
                    Text("\(Int(goldDiff!.count - 1)):00").font(.custom(fontString, size: 15)).foregroundColor(Color(.secondaryLabel))
                }.padding()
                Spacer()
            }
        }
        
    }
    
    private func fetchLargestABS() -> Int{
        var proxyGold = goldDiff!
        var proxyXP = xpDiff!
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
        DifferenceGraphView(goldDiff: nil, xpDiff: nil).previewLayout(.fixed(width: 375, height: 300))
        DifferenceGraphView(goldDiff: Match.sample.goldDiff, xpDiff: Match.sample.xpDiff).previewLayout(.fixed(width: 375, height: 300))
    }
}

struct CurrentPoint: View {
    var data: [Int]
    var max: Int
    var selectedTime: Int
    var body: some View {
        GeometryReader{ proxy in
            Circle()
                .frame(width: 10, height: 10)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 1)
                .offset(x: CGFloat(proxy.size.width) * CGFloat(selectedTime) / CGFloat(data.count - 1) - 5, y: proxy.size.height * CGFloat(CGFloat(max - data[selectedTime]) / CGFloat(max * 2)) - 5)
            
            //                .offset(x: CGFloat(proxy.size.width) * CGFloat(selectedTime) / CGFloat(data.count - 1), y: CGFloat(max - data[selectedTime]) * proxy.size.height)
        }
    }
}

struct DrawDiffLines: View {
    var data: [Int]
    var max: Int
    var selectedTime: Int
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let showedData = Array(data[0...selectedTime])
                path.move(to: CGPoint(x: 0, y: CGFloat(CGFloat(max - showedData[0]) / CGFloat(max * 2)) * CGFloat(proxy.size.height)))
                let halfStep = proxy.size.width / CGFloat(data.count - 1) / 2.0
                showedData.enumerated().forEach { index, item in
                    if showedData.count == 1 {
                        // do nothing
                    } else if index == 0 {
                        // first element
                        let m2 = (showedData[index] + showedData[index + 1]) / 2
                        let x = (proxy.size.width * CGFloat(index) / CGFloat(data.count - 1)) + halfStep
                        let y = (CGFloat(max - m2) / CGFloat(max * 2)) * CGFloat(proxy.size.height)
                        path.addLine(to: CGPoint(x: x, y: y))
                    } else if index == showedData.count - 1 {
                        // last element
                        path.addLine(to: CGPoint(x: (proxy.size.width * CGFloat(index) / CGFloat(data.count - 1)), y: CGFloat(CGFloat(max - item) / CGFloat(max * 2)) * CGFloat(proxy.size.height)))
                    } else {
                        let m2 = (showedData[index] + showedData[index + 1]) / 2
                        let x = (proxy.size.width * CGFloat(index) / CGFloat(data.count - 1)) + halfStep
                        let y = (CGFloat(max - m2) / CGFloat(max * 2)) * CGFloat(proxy.size.height)
                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: CGFloat(proxy.size.width * CGFloat(index) / CGFloat(data.count - 1)), y: CGFloat(CGFloat(max - item) / CGFloat(max * 2)) * CGFloat(proxy.size.height)))
                    }
                }
            }
            .stroke(lineWidth: 3)
        }
        
    }
}

struct BackgroundLine: View {
    var max: Int
    var body: some View {
        VStack {
            //            Rectangle()
            //                .frame(height: 1)
            //                .foregroundColor(Color(.systemGreen).opacity(0.2))
            Spacer()
            Rectangle().frame(height: 1).foregroundColor(Color(.secondaryLabel).opacity(0.2))
            Spacer()
            //            Rectangle().frame(height: 1)
            //                .foregroundColor(Color(.systemRed).opacity(0.2))
        }
    }
    
    private func countLines() -> Int {
        return (max - 1) / 5000
    }
}
