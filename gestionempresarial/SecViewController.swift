//
//  SecViewController.swift
//  gestionempresarial
//
//  Created by admin on 13/04/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Charts
import FirebaseDatabase

class SecViewController: UIViewController {
    var ref : FIRDatabaseReference!
    
    @IBOutlet weak var scView: UIScrollView!
    let buttonPadding:CGFloat = 1
    var xOffset:CGFloat = 10
    
    @IBOutlet weak var charView: BarChartView!
    var global_key=[String]()
    var global_val=[Int]()
    var name:String = ""
    var flag=0
    var flag1=0
    var flag2=0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference(withPath: "ingresos_totales")
        ref.observe(.value, with: {snapshot in
            var date_key = [String]()
            var vals = [String]()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                date_key.append(rest.key)
                vals.append(rest.value! as! String )
            }
            let intArray = vals.map{Int($0)!}
            self.global_key=date_key
            self.global_val=intArray
            self.name="ingresos_totales(FILTER)"
            var dataEntries : [BarChartDataEntry] = []
            for i in 0..<date_key.count{
                let dataEntry = BarChartDataEntry(x: Double(i+5), y: Double(intArray[i]))
                
                dataEntries.append(dataEntry)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "ingresos_totales")
            chartDataSet.colors=ChartColorTemplates.colorful()
            let chartData = BarChartData(dataSet: chartDataSet)
            self.charView.data = chartData
            self.charView.xAxis.labelTextColor=NSUIColor.white
            self.charView.leftAxis.labelTextColor=NSUIColor.white
            self.charView.legend.textColor=NSUIColor.white
            self.charView.animate(yAxisDuration: 2.0)
            self.charView.rightAxis.drawLabelsEnabled=false
            
            
            
        })
        
        view.backgroundColor = UIColor(red: 25/255, green: 46/255, blue: 66/255, alpha: 1)
       
        scView.showsVerticalScrollIndicator = false
        scView.showsHorizontalScrollIndicator=false
        charView.noDataText = "NO Data"
        scView.translatesAutoresizingMaskIntoConstraints = false
        var images = ["ingresos.png","egresos.png","utilidad.png","volumen.png","cuentas_cobrar.png","cuentas_pagar.png","ventas.png","bancos.png"]
        for i in 0 ... 7 {
            let button = UIButton()
            button.tag = i
            //button.backgroundColor = UIColor.darkGray
            button.setImage(UIImage(named: images[i]), for: UIControlState.normal)
            
            button.addTarget(self, action: #selector(btnTouch), for: UIControlEvents.touchUpInside)
            
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 80, height: 94)
            button.autoresizingMask=[.flexibleBottomMargin, .flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin]
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scView.addSubview(button)
            
            
        }
        
        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    @IBAction func logoutAction(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }
    
    func  btnTouch(sender:UIButton){
        
        if(sender.tag == 0){
            ref = FIRDatabase.database().reference(withPath: "ingresos_totales")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="ingresos_totales(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "ingresos_totales")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.legend.textColor=NSUIColor.white
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false
                
                
                
            })
            
        }
        if(sender.tag == 1){
            ref = FIRDatabase.database().reference(withPath: "egresos")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="egresos(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "egresos")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false
                
                
                
            })
            
        }
        if(sender.tag == 2){
            ref = FIRDatabase.database().reference(withPath: "utilidad")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="utilidad(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "utilidad")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.legend.textColor=NSUIColor.white
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false

                
                
            })
            
        }
        if(sender.tag == 3){
            ref = FIRDatabase.database().reference(withPath: "volumen_produccion")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="volumen_produccion(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "volumen_produccion")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.legend.textColor=NSUIColor.white
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false

                
                
            })
            
        }

        if(sender.tag == 4){
            ref = FIRDatabase.database().reference(withPath: "cuentas_cobrar")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="cuentas_cobrar(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "cuentas_cobrar")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.legend.textColor=NSUIColor.white
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false
                

                
                
            })
            
        }

        if(sender.tag == 5){
            ref = FIRDatabase.database().reference(withPath: "cuentas_pagar")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="cuentas_pargar(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "cuentas_pagar")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.legend.textColor=NSUIColor.white                
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false

                
                
            })
            
        }
        
        if(sender.tag == 6){
            ref = FIRDatabase.database().reference(withPath: "ventas")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="ventas(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "ventas")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.legend.textColor=NSUIColor.white
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false

                
                
            })
            
        }
        
        if(sender.tag == 7){
            ref = FIRDatabase.database().reference(withPath: "bancos")
            ref.observe(.value, with: {snapshot in
                var date_key = [String]()
                var vals = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot  {
                    date_key.append(rest.key)
                    vals.append(rest.value! as! String )
                }
                let intArray = vals.map{Int($0)!}
                self.global_key=date_key
                self.global_val=intArray
                self.name="bancos(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                var dataEntries : [BarChartDataEntry] = []
                for i in 0..<date_key.count{
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(intArray[i]))
                    
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "bancos")
                chartDataSet.colors=ChartColorTemplates.colorful()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.charView.data = chartData
                self.charView.xAxis.labelTextColor=NSUIColor.white
                self.charView.leftAxis.labelTextColor=NSUIColor.white
                self.charView.legend.textColor=NSUIColor.white
                self.charView.animate(yAxisDuration: 2.0)
                self.charView.rightAxis.drawLabelsEnabled=false

                
                
            })
            
        }
        
 
    }
    
    @IBAction func yearly(_ sender: Any) {
        var val=[Int]()
        
        
        var dataEntries : [BarChartDataEntry] = []
        if flag==0{
        for i in 0..<self.global_key.count{
            var Timestamp: TimeInterval {
                return NSDate().timeIntervalSince1970 * 1000
            }
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            //let nsDateAsString = formater.stringFromDate(self.global_key[i])
            let nsDateFromString = formater.date(from: self.global_key[i])
            let nsDateConvertedToTimestamp = nsDateFromString!.timeIntervalSince1970*1000
            print(Timestamp-31536000000)
            print(nsDateConvertedToTimestamp)
            if Timestamp-31536000000<nsDateConvertedToTimestamp && nsDateConvertedToTimestamp<Timestamp{
                val.append(self.global_val[i])
                let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(self.global_val[i]))
                dataEntries.append(dataEntry)
            }
        }
            flag += 1
        }else{
            for i in 0..<self.global_key.count{
                val.append(self.global_val[i])
                let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(self.global_val[i]))
                dataEntries.append(dataEntry)
            }
            flag = 0
        }
        if val.isEmpty==true{
            let alertCtrl = UIAlertController(title: "Alert", message: "There are no data matched !", preferredStyle: UIAlertControllerStyle.alert )
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            alertCtrl.addAction(okAction)
            
            self.present(alertCtrl, animated: true, completion: nil)
        }else{
            let chartDataSet = BarChartDataSet(values: dataEntries, label: self.name)
            chartDataSet.colors=ChartColorTemplates.colorful()
            let chartData = BarChartData(dataSet: chartDataSet)
            self.charView.data = chartData
            self.charView.xAxis.labelTextColor=NSUIColor.white
            self.charView.leftAxis.labelTextColor=NSUIColor.white
            self.charView.legend.textColor=NSUIColor.white
            self.charView.animate(yAxisDuration: 2.0)
            self.charView.rightAxis.drawLabelsEnabled=false
        }
    }
    @IBAction func monthly(_ sender: Any) {
        var val=[Int]()
        
        let date = Date()
        
        var dataEntries : [BarChartDataEntry] = []
        if flag1==0{
        for i in 0..<self.global_key.count{
            var Timestamp: TimeInterval {
                return NSDate().timeIntervalSince1970 * 1000
            }
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            //let nsDateAsString = formater.stringFromDate(self.global_key[i])
            let nsDateFromString = formater.date(from: self.global_key[i])
            let nsDateConvertedToTimestamp = nsDateFromString!.timeIntervalSince1970*1000
            
            if Timestamp-2592000000<nsDateConvertedToTimestamp && nsDateConvertedToTimestamp<Timestamp{
                val.append(self.global_val[i])
                let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(self.global_val[i]))
                dataEntries.append(dataEntry)
            }
        }
            flag1 += 1
    }else{
    for i in 0..<self.global_key.count{
    val.append(self.global_val[i])
    let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(self.global_val[i]))
    dataEntries.append(dataEntry)
    }
            flag1 = 0
    }
        if val.isEmpty==true{
            let alertCtrl = UIAlertController(title: "Alert", message: "There are no data matched !", preferredStyle: UIAlertControllerStyle.alert )
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            alertCtrl.addAction(okAction)
            
            self.present(alertCtrl, animated: true, completion: nil)
        }else{
            let chartDataSet = BarChartDataSet(values: dataEntries, label: self.name)
            chartDataSet.colors=ChartColorTemplates.colorful()
            let chartData = BarChartData(dataSet: chartDataSet)
            self.charView.data = chartData
            self.charView.xAxis.labelTextColor=NSUIColor.white
            self.charView.leftAxis.labelTextColor=NSUIColor.white
            self.charView.legend.textColor=NSUIColor.white
            self.charView.animate(yAxisDuration: 2.0)
            self.charView.rightAxis.drawLabelsEnabled=false
        }
    }
    @IBAction func weekly(_ sender: Any) {
        
        var val=[Int]()
        
        
        
        var dataEntries : [BarChartDataEntry] = []
        if flag2==0{
        for i in 0..<self.global_key.count{
            var Timestamp: TimeInterval {
                return NSDate().timeIntervalSince1970 * 1000
            }
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            //let nsDateAsString = formater.stringFromDate(self.global_key[i])
            let nsDateFromString = formater.date(from: self.global_key[i])
            let nsDateConvertedToTimestamp = nsDateFromString!.timeIntervalSince1970*1000
            
            if Timestamp-604800000<nsDateConvertedToTimestamp && nsDateConvertedToTimestamp<Timestamp{
                val.append(self.global_val[i])
                let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(self.global_val[i]))
                dataEntries.append(dataEntry)
            }
            }
            flag2 += 1
        }else{
            for i in 0..<self.global_key.count{
                val.append(self.global_val[i])
                let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(self.global_val[i]))
                dataEntries.append(dataEntry)
            }
            flag2 = 0
        }
        if val.isEmpty==true{
            let alertCtrl = UIAlertController(title: "Alert", message: "There are no data matched !", preferredStyle: UIAlertControllerStyle.alert )
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            alertCtrl.addAction(okAction)
            
            self.present(alertCtrl, animated: true, completion: nil)
        }else{
            let chartDataSet = BarChartDataSet(values: dataEntries, label: self.name)
            chartDataSet.colors=ChartColorTemplates.colorful()
            let chartData = BarChartData(dataSet: chartDataSet)
            self.charView.data = chartData
            self.charView.xAxis.labelTextColor=NSUIColor.white
            self.charView.leftAxis.labelTextColor=NSUIColor.white
            self.charView.legend.textColor=NSUIColor.white
            self.charView.animate(yAxisDuration: 2.0)
            self.charView.rightAxis.drawLabelsEnabled=false
        }
    }
}
