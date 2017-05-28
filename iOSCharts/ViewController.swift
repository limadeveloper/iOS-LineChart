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
    
    fileprivate let longGesture = UILongPressGestureRecognizer()
    fileprivate let pinchGesture = UIPinchGestureRecognizer()
    fileprivate var selectedEntriesWhenGesture: [ChartDataEntry]?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinchGesture.addTarget(self, action: #selector(pinchInChart(gesture:)))
        
        longGesture.numberOfTouchesRequired = 1
        longGesture.minimumPressDuration = 0.2
        longGesture.addTarget(self, action: #selector(longPressInChart(gesture:)))
        
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
        chartView.legend.enabled = true
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView?.highlightPerTapEnabled = false
        chartView?.highlightPerDragEnabled = false
        chartView.setExtraOffsets(left: 30, top: 0, right: 30, bottom: 0)
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.addGestureRecognizer(longGesture)
        chartView.addGestureRecognizer(pinchGesture)
        
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
        
        var dataSets = [LineChartDataSet]()
        
        firstSet = setupNew(
            lineChartDataSet: firstSet,
            values: firstLineValues,
            label: "First"
        )
        
        secondSet = setupNew(
            lineChartDataSet: secondSet,
            values: secondLineValues,
            label: "Second",
            color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
            circleColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
            valueTextColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        )
        
        if let firstSet = firstSet {
            dataSets.append(firstSet)
        }
        
        guard dataSets.count > 0 else { return }
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.boldSystemFont(ofSize: 10))
        
        chartView.data = data
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    fileprivate func setupNew(lineChartDataSet: LineChartDataSet?, values: [ChartDataEntry], label: String, drawCirclesEnabled: Bool = true, axisDependency: YAxis.AxisDependency = .left, color: UIColor = #colorLiteral(red: 0.1091378406, green: 0.6490935683, blue: 0.423900485, alpha: 1), circleColor: UIColor = #colorLiteral(red: 0.1091378406, green: 0.6490935683, blue: 0.423900485, alpha: 1), lineWidth: CGFloat = 2, circleRadius: CGFloat = 3, fillColor: UIColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), highlightColor: UIColor = #colorLiteral(red: 0.5803921569, green: 0.1294117647, blue: 0.5725490196, alpha: 1), drawCircleHoleEnabled: Bool = false, lineDashLengths: [CGFloat] = [5, 2.5], highlightLineDashLengths: [CGFloat] = [5, 2.5], formLineDashLengths: [CGFloat] = [5, 2.5], formLineWidth: CGFloat = 2, formSize: CGFloat = 15, fillAlpha: CGFloat = 0, fill: Fill = Fill(color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), drawFilledEnabled: Bool = true, valueTextColor: UIColor = #colorLiteral(red: 0.1091378406, green: 0.6490935683, blue: 0.423900485, alpha: 1), drawHorizontalHighlightIndicatorEnabled: Bool = false, highlightLineWidth: CGFloat = 3) -> LineChartDataSet? {
        
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
        set?.highlightLineWidth = highlightLineWidth
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
        set?.drawHorizontalHighlightIndicatorEnabled = drawHorizontalHighlightIndicatorEnabled
        
        let gradientColors = [
            ChartColorTemplates.colorFromString("#D1D613").cgColor,
            ChartColorTemplates.colorFromString("#1E9859").cgColor
        ]
        
        if let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil) {
            set?.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
        }
        
        return set
    }
    
    fileprivate func getDataFromChartToGesture() -> (values: [LineChartDataSet?]?, label: String?, lineData: LineChartData?, defaultSet: ChartDataSet?) {
        return (
            (chartView?.data?.dataSets as? [LineChartDataSet]),
            chartView?.data?.dataSets.first?.label,
            chartView?.lineData,
            chartView?.lineData?.dataSets.first as? ChartDataSet
        )
    }
    
    fileprivate func highlightInChart(when gesture: UIGestureRecognizer, and selectedEntries: [ChartDataEntry]? = nil) {
        
        guard let h1 = self.chartView?.getHighlightByTouchPoint(gesture.location(ofTouch: 0, in: self.chartView)) else { return }
        
        var values = [h1]
        
        if gesture.numberOfTouches == 2, let h2 = self.chartView?.getHighlightByTouchPoint(gesture.location(ofTouch: 1, in: self.chartView)) {
            values = [h1, h2]
        }
        
        chartView?.highlightValues(values)
    }
    
    fileprivate func getCenterIn(pinchGesture: UIPinchGestureRecognizer?) -> CGPoint {
        return pinchGesture?.location(in: chartView) ?? .zero
    }
    
    dynamic fileprivate func longPressInChart(gesture: UILongPressGestureRecognizer) {
        
        chartView?.highlightPerTapEnabled = true
        chartView?.highlightPerDragEnabled = true
        
        switch gesture.state {
        case .began, .changed:
            highlightInChart(when: gesture)
        case .ended:
            chartView?.highlightValues(nil)
            chartView?.highlightPerTapEnabled = false
            chartView?.highlightPerDragEnabled = false
        default:
            break
        }
    }
    
    dynamic private func pinchInChart(gesture: UIPinchGestureRecognizer) {
    
        let dataGesture = getDataFromChartToGesture()
        var lineData = dataGesture.lineData
        
        chartView?.delegate = nil
        
        switch gesture.state {
        case .changed:
            
            guard gesture.numberOfTouches == 2 else { return }
            
            guard let allValues = dataGesture.defaultSet?.values else { break }
            guard let entryA = chartView?.getEntryByTouchPoint(point: gesture.location(ofTouch: 0, in: chartView)) else { break }
            guard let entryB = chartView?.getEntryByTouchPoint(point: gesture.location(ofTouch: 1, in: chartView)) else { break }
            
            if self.selectedEntriesWhenGesture == nil { self.selectedEntriesWhenGesture = [ChartDataEntry]() }
            
            self.selectedEntriesWhenGesture = allValues.filter({ $0.x >= entryA.x && $0.x <= entryB.x })
            
            guard let selectedEntries = self.selectedEntriesWhenGesture, selectedEntries.count > 0 else { return }
            
            func filterEntries(entries: [ChartDataEntry]) -> [ChartDataEntry] { // removing duplicates
                var set = Set<Double>()
                let result = entries.filter({ entry -> Bool in
                    guard !set.contains(entry.x) else { return false }
                    set.insert(entry.x)
                    return true
                })
                return result
            }
            
            self.selectedEntriesWhenGesture = filterEntries(entries: selectedEntries)
            
            let fillSet = LineChartDataSet()
            guard let newSet = setupNew(lineChartDataSet: fillSet, values: self.selectedEntriesWhenGesture ?? [], label: "", drawCirclesEnabled: false, fillAlpha: 1, valueTextColor: .clear) else { return }
            
            guard let defaultSet = dataGesture.defaultSet else { return }
            lineData = LineChartData(dataSets: [defaultSet, newSet])
            
            DispatchQueue.main.async { [weak self] in
                self?.chartView?.data = lineData
                self?.highlightInChart(when: gesture, and: self?.selectedEntriesWhenGesture)
                guard let firstLegend = self?.chartView.legend.entries.first else { return }
                self?.chartView.legend.entries = [firstLegend]
            }
            
        case .ended:
            
            guard let defaultSet = dataGesture.defaultSet else { return }
            
            chartView?.delegate = self
            chartView?.data = LineChartData(dataSets: [defaultSet])
            chartView?.highlightValues(nil)
            
            selectedEntriesWhenGesture = nil
            
        default:
            break
        }
    }
}

// MARK: - ChartView Delegate
extension ViewController: ChartViewDelegate {

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("No data selected")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Selected: \(entry.y)")
    }
}
