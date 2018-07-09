//
//  AnalyzeViewController.swift
//  LexicalAnalyzer
//
//  Created by Nusret Özateş on 24.05.2018.
//  Copyright © 2018 Nusret Özateş. All rights reserved.
//

import Foundation
import UIKit
import Charts

class AnalyzeViewController : UIViewController,ChartViewDelegate
{
    
    var dict1  : [String:[String]]? = [:]
    var dict2  : [String:[String]]? = [:]
    var dict3  : [String:[String]]? = [:]
    var dict4  : [String:[String]]? = [:]
    var dict5  : [String:[String]]? = [:]
    var dict6  : [String:[String]]? = [:]
    var dict7  : [String:[String]]? = [:]
    var dict8  : [String:[String]]? = [:]
    var dict9  : [String:[String]]? = [:]
    var dict10 :[String:[String]]? = [:]
    var luckynumber : Int?
    var secilenler : [[String:[String]]] = []
    var values : [BarChartDataEntry] = []
    
    
    
    @IBOutlet weak var words: UITextView!
    @IBOutlet weak var Chart: BarChartView!
    
    var numberofwords = 0
    var numberofuniquewords = 0
    
    var leftwords : [String:[String]]? = [:]
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(dict1?.values.count)
        print(dict2?.values.count)
        print(dict3?.values.count)
        print(dict4?.values.count)
        print(dict5?.count)
        print(dict6?.values.count)
        print(dict7?.values.count)
        print(dict8?.values.count)
        print(dict9?.values.count)
        print(dict10?.values.count)
        print(numberofuniquewords)
        print(numberofwords)

        Chart.delegate = self
        switch luckynumber {
        case 0:
            AWL()
        case 1:
            PhrasalVerbs()
        case 2:
            AcademicVocabularyList()
        case 3:
            AcademicCollocations()
        case 4:
            DiscourseConnectors()
        case 5:
            NewGSL()
        case 6 :
            NGSL()
        default:
            print("nothing to see")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dict1  = [:]
        dict2  = [:]
        dict3  = [:]
        dict4  = [:]
        dict5  = [:]
        dict6  = [:]
        dict7  = [:]
        dict8  = [:]
        dict9  = [:]
        dict10 = [:]
        leftwords = [:]
    }

    func NGSL()
    {
        secilenler = [dict1,dict2,dict3,dict4,leftwords] as! [[String : [String]]]
        let i = secilenler.count

        for index in 0...i-1 {
            var countofvalues = 0
            for (key,value) in secilenler[index]
            {
                for val in value
                {
                    countofvalues = countofvalues + 1
                }
            }
            values.append(BarChartDataEntry(x:Double(index) , y: Double(countofvalues)))
        }
        let piedataset = BarChartDataSet(values: values, label: "General Service List")
        piedataset.colors = ChartColorTemplates.joyful()
        piedataset.formSize = 7
        piedataset.valueFont = .systemFont(ofSize: 15)

        let labels : [String] = ["Sublist1","Sublist2","Sublist3","Sublist4","Offlist"]

        let dataset = BarChartData()
        dataset.addDataSet(piedataset)
        dataset.barWidth = 1


        let desc = Description()
        desc.text = "General Service List"
        Chart.chartDescription = desc
        Chart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        words.text = "You use \(numberofwords) words from General Service List and \(numberofuniquewords) unique words "
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        let xAxis = Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        Chart.noDataText = "There isnt any words in this dictionary"
        Chart.data = dataset
    }
    func NewGSL() {
        
        secilenler = [dict1,dict2,dict3,leftwords] as! [[String : [String]]]

        if (dict1!["undefined"]?.count) != nil
        {
            values.append(BarChartDataEntry(x: 0, y: Double((dict1!["undefined"]?.count)!)))
        }
        if (dict2!["undefined"]?.count) != nil
        {
            values.append(BarChartDataEntry(x: 1, y: Double((dict2!["undefined"]?.count)!)))
        }
        if (dict3!["undefined"]?.count) != nil
        {
            values.append(BarChartDataEntry(x: 2, y: Double((dict3!["undefined"]?.count)!)))
        }

        if (leftwords!["undefined"]?.count)! != nil
        {
            values.append(BarChartDataEntry(x: 3, y: Double((leftwords!["undefined"]?.count)!)))
        }


        let piedataset = BarChartDataSet(values: values, label: "New-GSL")
        piedataset.colors = ChartColorTemplates.joyful()
        piedataset.formSize = 7
        piedataset.valueFont = .systemFont(ofSize: 15)
        
        let labels : [String] = ["First 500","500-1000","1000-2500","Offlist"]
        
        let dataset = BarChartData()
        dataset.addDataSet(piedataset)
        dataset.barWidth = 1
        
        
        
        let desc = Description()
        desc.text = "New-GSL"
        Chart.chartDescription = desc
        Chart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        words.text = "You use \(numberofwords) words from New-GSL and \(numberofuniquewords) unique words "
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        let xAxis = Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        Chart.data = dataset
    }
    func AcademicCollocations() {
        secilenler = [dict1, leftwords] as! [[String : [String]]]
        if (dict1!["undefined"]?.count) != nil
        {
            values.append(BarChartDataEntry(x: 0, y: Double((dict1!["undefined"]?.count)!)))
        }
        if (leftwords!["undefined"]?.count)! != nil
        {
        values.append(BarChartDataEntry(x: 1, y: Double((leftwords!["undefined"]?.count)!)))
        }

        let piedataset = BarChartDataSet(values: values, label: "Academic Collocations")
        piedataset.colors = ChartColorTemplates.joyful()
        piedataset.formSize = 7
        piedataset.valueFont = .systemFont(ofSize: 15)

        let labels : [String] = ["Academic Collocations","Offlist"]

        let dataset = BarChartData()
        dataset.addDataSet(piedataset)
        dataset.barWidth = 1


        let desc = Description()
        desc.text = "Academic Collocations"
        Chart.chartDescription = desc
        Chart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        words.text = "You use \(numberofwords) words from Academic Collocations List and \(numberofuniquewords) unique words "
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        let xAxis = Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        Chart.noDataText = "There isnt any words in this dictionary"
        Chart.data = dataset



    }
    func AWL() {

        secilenler = [dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8,dict9,dict10,leftwords] as! [[String : [String]]]
        let i = secilenler.count



        for index in 0...i-1 {
          var countofvalues = 0
           for (key,value) in secilenler[index]
           {
               for val in value
           {
             countofvalues = countofvalues + 1
           }
           }
                values.append(BarChartDataEntry(x:Double(index) , y: Double(countofvalues)))
        }
        let piedataset = BarChartDataSet(values: values, label: "Academic Word List")
        piedataset.colors = ChartColorTemplates.joyful()
        piedataset.formSize = 7
        piedataset.valueFont = .systemFont(ofSize: 15)

        let labels : [String] = ["Sublist1","Sublist2","Sublist3","Sublist4","Sublist5","Sublist6",
                                 "Sublist7","Sublist8","Sublist9","Sublist10","Offlist"]

        let dataset = BarChartData()
        dataset.addDataSet(piedataset)
        dataset.barWidth = 1


        let desc = Description()
        desc.text = "Academic Word List"
        Chart.chartDescription = desc
        Chart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        words.text = "You use \(numberofwords) words from Academic Word List and \(numberofuniquewords) unique words "
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        let xAxis = Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        Chart.noDataText = "There isnt any words in this dictionary"
        Chart.data = dataset

    }
    func DiscourseConnectors() {
      secilenler = [dict1, leftwords] as! [[String : [String]]]
        if (dict1!["undefined"]?.count) != nil
        {
            values.append(BarChartDataEntry(x: 0, y: Double((dict1!["undefined"]?.count)!)))
        }
        if (leftwords!["undefined"]?.count)! != nil
        {
        values.append(BarChartDataEntry(x: 1, y: Double((leftwords!["undefined"]?.count)!)))
        }

        let piedataset = BarChartDataSet(values: values, label: "Discourse Connectors")
        piedataset.colors = ChartColorTemplates.joyful()
        piedataset.formSize = 7
        piedataset.valueFont = .systemFont(ofSize: 15)

        let labels : [String] = ["Discourse Connectors","Offlist"]

        let dataset = BarChartData()
        dataset.addDataSet(piedataset)
        dataset.barWidth = 1


        let desc = Description()
        desc.text = "Discourse Connectors"
        Chart.chartDescription = desc
        Chart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        words.text = "You use \(numberofwords) words from Discourse Connectors List and \(numberofuniquewords) unique words "
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        let xAxis = Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        Chart.noDataText = "There isnt any words in this dictionary"
        Chart.data = dataset
    }
    func AcademicVocabularyList() {
        secilenler = [dict1, leftwords] as! [[String : [String]]]
        if (dict1?.count)! != nil || (dict1?.count)! > 0
        {
            var countofvalues = 0
            for (key,value) in secilenler[0]
            {
                for val in value
                {
                    countofvalues = countofvalues + 1
                }
            }
            values.append(BarChartDataEntry(x: 0, y: Double(countofvalues)))
        }
        if (leftwords!["undefined"]?.count)! != nil || (leftwords?.count)! > 0
        {
        values.append(BarChartDataEntry(x: 1, y: Double((leftwords!["undefined"]?.count)!)))
        }

        let piedataset = BarChartDataSet(values: values, label: "Academic Vocabulary List")
        piedataset.colors = ChartColorTemplates.joyful()
        piedataset.formSize = 7
        piedataset.valueFont = .systemFont(ofSize: 15)

        let labels : [String] = ["Academic Vocabulary List","Offlist"]

        let dataset = BarChartData()
        dataset.addDataSet(piedataset)
        dataset.barWidth = 1


        let desc = Description()
        desc.text = "Academic Vocabulary List"
        Chart.chartDescription = desc
        Chart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        words.text = "You use \(numberofwords) words from Academic Vocabulary List and \(numberofuniquewords) unique words "
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        let xAxis = Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        Chart.noDataText = "There isnt any words in this dictionary"
        Chart.data = dataset
    }

     func PhrasalVerbs()
     {
      secilenler = [dict1, leftwords] as! [[String : [String]]]
        if (dict1!["undefined"]?.count) != nil || (dict1?.count)! > 0
        {
            var countofvalues = 0
            for (key,value) in secilenler[0]
            {
                for val in value
                {
                    countofvalues = countofvalues + 1
                }
            }
            values.append(BarChartDataEntry(x: 0, y: Double(countofvalues)))
        }
        if (leftwords!["undefined"]?.count)! != nil || (leftwords?.count)! > 0
        {
        values.append(BarChartDataEntry(x: 1, y: Double((leftwords!["undefined"]?.count)!)))
        }

        let piedataset = BarChartDataSet(values: values, label: "Phrasal Verb List")
        piedataset.colors = ChartColorTemplates.joyful()
        piedataset.formSize = 7
        piedataset.valueFont = .systemFont(ofSize: 15)

        let labels : [String] = ["Phrasal Verbs","Offlist"]

        let dataset = BarChartData()
        dataset.addDataSet(piedataset)
        dataset.barWidth = 1


        let desc = Description()
        desc.text = "Phrasal Verb List"
        Chart.chartDescription = desc
        Chart.animate(xAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        words.text = "You use \(numberofwords) words from Phrasal Verb List  and \(numberofuniquewords) unique words "
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        let xAxis = Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        Chart.noDataText = "There isnt any words in this dictionary"
        Chart.data = dataset

   }


     @objc func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
     {
        words.text = ""
         var valueset : Set<String> = [] // Daha sonra kullanırım sanırım bunu undefinedlar için aklımda kalsın!
      for (key,value) in secilenler[Int(highlight.x)]
      {
            if(key != "undefined")
          {
              words.text.append("\(key) :")
              for val in value
              {
                  if(val !=  ".")
                  {
                      words.text.append(" \(val)  ")

                  }
              }
              words.text.append("\n")
          }else
            {
                for val in value
                {
                    if(val !=  ".")
                    {
                        words.text.append(" \(val)  ")
                        words.text.append("\n")
                    }
                }
            }

      }
        
    }
        
 }
