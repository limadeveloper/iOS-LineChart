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
    
    fileprivate var pinchGestor = UIPinchGestureRecognizer()
    fileprivate var panGestor = UIPanGestureRecognizer()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinchGestor.addTarget(self, action: #selector(hasPinch(gestor:)))
        
        panGestor.maximumNumberOfTouches = 2
        panGestor.addTarget(self, action: #selector(hasPan(gestor:)))
        
        setupChartView()
    }
    
    // MARK: - Actions
    fileprivate func setupChartView() {
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.drawGridBackgroundEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.drawMarkers = false
        chartView.legend.enabled = true
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.highlightPerDragEnabled = true
        chartView.setExtraOffsets(left: 30, top: 0, right: 30, bottom: 0)
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //chartView.addGestureRecognizer(pinchGestor)
        //chartView.addGestureRecognizer(panGestor)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        xAxis.drawLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.gridLineDashLengths = [10, 10]
        xAxis.gridLineDashPhase = 0
        
        updateChartData()
        
        chartView.animate(xAxisDuration: 2.5)
    }
    
    fileprivate func updateChartData() {
        
        var firstLineValues = [ChartDataEntry]()
        var secondLineValues = [ChartDataEntry]()
        
        for i in 0 ..< 20 {
            let value = arc4random_uniform(30)+50
            let item = ChartDataEntry(x: Double(i), y: Double(value))
            firstLineValues.append(item)
        }
        
        for i in 0 ..< 50 {
            let value = arc4random_uniform(60)+50
            let item = ChartDataEntry(x: Double(i), y: Double(value))
            secondLineValues.append(item)
        }
        
        var firstSet: LineChartDataSet?
        var secondSet: LineChartDataSet?
        
        guard (chartView.data?.dataSetCount ?? 0) > 0 else {
            
            var dataSets = [LineChartDataSet]()
            
            firstSet = setupNew(lineChartDataSet: firstSet, values: firstLineValues, label: "First")
            secondSet = setupNew(lineChartDataSet: secondSet, values: secondLineValues, label: "Second", color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), circleColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), fill: Fill.fillWithColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), valueTextColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
            
            if let firstSet = firstSet {
                dataSets.append(firstSet)
            }
            
            guard dataSets.count > 0 else { return }
            let data = LineChartData(dataSets: dataSets)
            data.setValueFont(.boldSystemFont(ofSize: 10))
            
            chartView.data = data
            
            return
        }
        
        firstSet = chartView.data?.dataSets.first as? LineChartDataSet
        firstSet?.values = firstLineValues
        
        secondSet = chartView.data?.dataSets.last as? LineChartDataSet
        secondSet?.values = secondLineValues
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    fileprivate func setupNew(lineChartDataSet: LineChartDataSet?, values: [ChartDataEntry], label: String, drawCirclesEnabled: Bool = true, axisDependency: YAxis.AxisDependency = .left, color: UIColor = #colorLiteral(red: 0.1091378406, green: 0.6490935683, blue: 0.423900485, alpha: 1), circleColor: UIColor = #colorLiteral(red: 0.1091378406, green: 0.6490935683, blue: 0.423900485, alpha: 1), lineWidth: CGFloat = 2, circleRadius: CGFloat = 3, fillColor: UIColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), highlightColor: UIColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), drawCircleHoleEnabled: Bool = false, lineDashLengths: [CGFloat] = [5, 2.5], highlightLineDashLengths: [CGFloat] = [5, 2.5], formLineDashLengths: [CGFloat] = [5, 2.5], formLineWidth: CGFloat = 2, formSize: CGFloat = 15, fillAlpha: CGFloat = 1, fill: Fill = Fill.fillWithColor(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), drawFilledEnabled: Bool = true, valueTextColor: UIColor = #colorLiteral(red: 0.1091378406, green: 0.6490935683, blue: 0.423900485, alpha: 1)) -> LineChartDataSet? {
        
        var set = lineChartDataSet
        
        set = LineChartDataSet(values: values, label: label)
        set?.drawCirclesEnabled = drawCirclesEnabled
        set?.axisDependency = axisDependency
        set?.setColor(color)
        set?.setCircleColor(circleColor)
        set?.lineWidth = lineWidth
        set?.circleRadius = circleRadius
        set?.fillColor = fillColor
        set?.highlightColor = highlightColor
        set?.drawCircleHoleEnabled = drawCircleHoleEnabled
        set?.lineDashLengths = lineDashLengths
        set?.highlightLineDashLengths = highlightLineDashLengths
        set?.formLineDashLengths = formLineDashLengths
        set?.formLineWidth = formLineWidth
        set?.formSize = formSize
        set?.fillAlpha = fillAlpha
        set?.fill = fill
        set?.drawFilledEnabled = drawFilledEnabled
        set?.valueTextColor = valueTextColor
        
        return set
    }
    
    dynamic fileprivate func hasPinch(gestor: UIPinchGestureRecognizer) {
        print("pinch: \(gestor.scale)")
    }
    
    dynamic fileprivate func hasPan(gestor: UIPanGestureRecognizer) {
        print("pan: \(gestor.location(in: chartView))")
    }
}

// MARK: - ChartView Delegate
extension ViewController: ChartViewDelegate {

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("No data selected")
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        print("Translated")
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        print("Scaled")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Selected: \(entry.y)")
    }
}
