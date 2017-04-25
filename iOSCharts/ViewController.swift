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
    
    var pinchGestor: UIPinchGestureRecognizer! {
        didSet {
            pinchGestor.addTarget(self, action: #selector(hasPinch))
        }
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinchGestor = UIPinchGestureRecognizer()
        setupChartView()
    }
    
    // MARK: - Actions
    fileprivate func setupChartView() {
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.drawGridBackgroundEnabled = false
        chartView.pinchZoomEnabled = true
        chartView.drawMarkers = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.setExtraOffsets(left: 30, top: 0, right: 30, bottom: 0)
        chartView.backgroundColor = .white
        chartView.addGestureRecognizer(pinchGestor)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .purple
        xAxis.drawLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        
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
            firstSet?.fillColor = .purple
            firstSet?.highlightColor = #colorLiteral(red: 0, green: 0.5843137255, blue: 0.3254901961, alpha: 1)
            firstSet?.drawCircleHoleEnabled = false
            
            var dataSets = [LineChartDataSet]()
            
            guard let firstSet = firstSet else { return }
            dataSets.append(firstSet)
            
            let data = LineChartData(dataSets: dataSets)
            data.setValueTextColor(.black)
            data.setValueFont(.boldSystemFont(ofSize: 10))
            
            chartView.data = data
            
            return
        }
        
        firstSet = chartView.data?.dataSets.first as? LineChartDataSet
        firstSet?.values = firstLineValues
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    dynamic fileprivate func hasPinch() {
        print("has been pinch")
    }
}

// MARK: - ChartView Delegate
extension ViewController: ChartViewDelegate {

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("No data selected")
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        print("Translated")
        print("dx: \(dX)")
        print("dy: \(dY)")
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        print("Scaled")
        print("scale x: \(scaleX)")
        print("scale y: \(scaleY)")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Selected")
        print("Entry x: \(entry.x)")
        print("Entry y: \(entry.y)")
    }
}
