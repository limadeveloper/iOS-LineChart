//
//  ViewController.swift
//  iOSCharts
//
//  Created by John Lima on 23/04/17.
//  Copyright © 2017 John Lima. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet fileprivate weak var chartView: LineChartView!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartView()
    }
    
    // MARK: - Actions
    fileprivate func setupChartView() {
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.drawGridBackgroundEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.drawMarkers = false
        chartView.backgroundColor = .white
        
        let legend = chartView.legend
        legend.form = .line
        legend.textColor = .darkGray
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        
        updateChartData()
        
        chartView.animate(xAxisDuration: 2.5)
    }
    
    fileprivate func updateChartData() {
        
        var firstLineValues = [ChartDataEntry]()
        
        for i in 0 ..< 20 {
            let value = arc4random_uniform(30)+50
            let item = ChartDataEntry(x: Double(i), y: Double(value))
            firstLineValues.append(item)
        }
        
        var firstSet: LineChartDataSet?
        
        guard (chartView.data?.dataSetCount ?? 0) > 0 else {
            
            firstSet = LineChartDataSet(values: firstLineValues, label: "First DataSet")
            firstSet?.axisDependency = .left
            firstSet?.setColor(.purple)
            firstSet?.setCircleColor(.black)
            firstSet?.lineWidth = 2
            firstSet?.circleRadius = 3
            firstSet?.fillAlpha = 65/255.0
            firstSet?.fillColor = .purple
            firstSet?.highlightColor = .black
            firstSet?.drawCircleHoleEnabled = false
            
            var dataSets = [LineChartDataSet]()
            
            guard let firstSet = firstSet else { return }
            dataSets.append(firstSet)
            
            let data = LineChartData(dataSets: dataSets)
            data.setValueTextColor(.purple)
            data.setValueFont(.systemFont(ofSize: 10))
            
            chartView.data = data
            
            return
        }
        
        firstSet = chartView.data?.dataSets.first as? LineChartDataSet
        firstSet?.values = firstLineValues
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
}

// MARK: - ChartView Delegate
extension ViewController: ChartViewDelegate {

}
