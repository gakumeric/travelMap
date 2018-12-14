//
//  daysViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/23.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class daysViewController: UIViewController {

    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height
    
    var Country: [String]! = []
    var unitsbudgets: [Double]! = []
    var budgetArray:NSMutableArray = []
    var moneyArray: NSArray = []
    var countryArray: NSArray = []
    var totalDays: Int = 0
    var allDay: [Int]! = []

    @IBOutlet weak var totalDay: UILabel!
    @IBOutlet weak var linebarChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readRealm()
        
        linebarChartView.layer.cornerRadius = 10.0
        //horizonbarChartView.animate(yAxisDuration: 2.0)
        linebarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeOutQuad)
        // ピンチでズームが可能か
        linebarChartView.pinchZoomEnabled = false
        //linebarChartView.drawBarShadowEnabled = true
        // グリッド線の表示
        linebarChartView.drawGridBackgroundEnabled = true
        // 境界線の表示
        linebarChartView.drawBordersEnabled = false
        // タップでデータを選択できるか
        linebarChartView.highlightPerTapEnabled = true
        // 指を離してもスクロールが続くか
        linebarChartView.dragDecelerationEnabled = true
        // バー上にある値の表示(バー内か、バーより上か)
        //linebarChartView.drawValueAboveBarEnabled = true
        //xy軸スケール拡大縮小をできなくする
        //linebarChartView.scaleXEnabled = false
        linebarChartView.scaleYEnabled = false
        // グラフのタイトル
        linebarChartView.chartDescription?.text = "How many days"
        linebarChartView.gridBackgroundColor = .clear
        linebarChartView.noDataText = "No chart data available."
        
        let labels = Country
        linebarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels!)
        linebarChartView.xAxis.granularity = 1
        setChart(dataPoints: Country, values: unitsbudgets)
        
        totalDay.text = "Total :\(totalDays)days"
        
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
        
        let realm = try! Realm()
        let result = realm.objects(Mapdata.self)
        
        for i in result {
            budgetArray.add(i)
        }
        
        moneyArray = budgetArray.value(forKey: "days") as! NSArray
        countryArray = budgetArray.value(forKey: "name") as! NSArray
        unitsbudgets = moneyArray as! [Double]
        Country = countryArray as! [String]
        
        allDay = moneyArray as! [Int]
        for m in 0..<allDay.count {
            
            totalDays += allDay[m]
        }
        print(totalDays)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        linebarChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "日程")
        chartDataSet.colors = [UIColor.red]
        let chartData = LineChartData(dataSet: chartDataSet)
        linebarChartView.data = chartData
    }

}
