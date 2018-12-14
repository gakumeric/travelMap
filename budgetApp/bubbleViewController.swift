//
//  bubbleViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/22.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class bubbleViewController: UIViewController {

    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height
    
    var Country: [String]! = []
    var unitsbudgets: [Double]! = []
    var budgetArray:NSMutableArray = []
    var moneyArray: NSArray = []
    var countryArray: NSArray = []
    var totalMoney: Int = 0
    var allMoney: [Int]! = []
    
    @IBOutlet weak var totalLabel: UILabel!
    
    
    @IBOutlet weak var horizonbarChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readRealm()
        
        horizonbarChartView.layer.cornerRadius = 10.0
        //horizonbarChartView.animate(yAxisDuration: 2.0)
        horizonbarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeOutQuad)
        // ピンチでズームが可能か
        horizonbarChartView.pinchZoomEnabled = false
        horizonbarChartView.drawBarShadowEnabled = true
        // グリッド線の表示
        horizonbarChartView.drawGridBackgroundEnabled = true
        // 境界線の表示
        horizonbarChartView.drawBordersEnabled = true
        // タップでデータを選択できるか
        horizonbarChartView.highlightPerTapEnabled = true
        // 指を離してもスクロールが続くか
        horizonbarChartView.dragDecelerationEnabled = true
        // バー上にある値の表示(バー内か、バーより上か)
        horizonbarChartView.drawValueAboveBarEnabled = true
        // グラフのタイトル
        //horizonbarChartView.chartDescription?.text = "How much will you spend"
        horizonbarChartView.borderColor = .black
        horizonbarChartView.gridBackgroundColor = .clear
        horizonbarChartView.noDataText = "No chart data available."
        
        let labels = Country
        horizonbarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels!)
        horizonbarChartView.xAxis.granularity = 1
        
        setChart(dataPoints: Country, values: unitsbudgets)
        
        totalLabel.text = "Total :\(totalMoney)円"
        
        //「戻る!」ボタン
        let backBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.08, width: 200, height: 30))
        backBtn.setTitle("Back", for: UIControl.State())
        backBtn.setTitleColor(.orange, for: UIControl.State())
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 10.0
        backBtn.layer.borderColor = UIColor.orange.cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.addTarget(self, action: #selector(onbackClick(_:)), for: .touchUpInside)
        view.addSubview(backBtn)
    }
    
    @objc func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func readRealm() {
        
        //すべて取得
        let realm = try! Realm()
        let result = realm.objects(Mapdata.self)
    
        for i in result {
            budgetArray.add(i) 
        }
        
        moneyArray = budgetArray.value(forKey: "money") as! NSArray
        countryArray = budgetArray.value(forKey: "name") as! NSArray
        unitsbudgets = moneyArray as! [Double]
        Country = countryArray as! [String]
        //print(unitsbudgets)
        //print(Country)
        
        allMoney = moneyArray as! [Int]
        for m in 0..<allMoney.count {
            
            totalMoney += allMoney[m]
        }
        print(totalMoney)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        horizonbarChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "予算額")
        chartDataSet.colors = [UIColor.cyan]
        let chartData = BarChartData(dataSet: chartDataSet)
        horizonbarChartView.data = chartData
    }
}
