//
//  MainViewController.swift
//  gestionempresarial
//
//  Created by admin on 13/04/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase
import Charts

class MainViewController: UIViewController {
    
    @IBOutlet weak var scView: UIScrollView!
    
    let buttonPadding:CGFloat = 1
    var xOffset:CGFloat = 10
    var ref: FIRDatabaseReference!

    let circles:Bool = false
   // var scView:UIScrollView!
    @IBOutlet weak var chartBarView: BarChartView!
   
    @IBOutlet weak var lineChartView: LineChartView!
    
    var global_key=[String]()
    var global_val=[Int]()
    var name:String = ""
    var flag=0
    var flag1=0
    var flag2=0
    override func viewDidLoad() {
        super.viewDidLoad()
       

        view.backgroundColor = UIColor(red: 25/255, green: 46/255, blue: 66/255, alpha: 1)

        
        chartBarView.noDataText = "NO Data"
        
       
        scView.translatesAutoresizingMaskIntoConstraints = false
       var images = ["dolares.png","euros.png","libras.png","tasa.png","inflacion.png","ipc.png","cetes.png","petroleo.png","cresimiento.png"]
        for i in 0 ... 8 {
            let button = UIButton()
            button.tag = i
            
            //button.backgroundColor = UIColor.darkGray
            button.setImage(UIImage(named: images[i]), for: UIControlState.normal)
            //button.setTitle("\(i)", for: .normal)
            button.addTarget(self, action: #selector(btnTouch), for: UIControlEvents.touchUpInside)
            
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 80, height: 94)
            button.autoresizingMask=[.flexibleBottomMargin,.flexibleLeftMargin,.flexibleRightMargin]
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scView.addSubview(button)
            
        }
        
        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
        
        
        ref = FIRDatabase.database().reference(withPath: "usd_to_mxn")
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
            self.name="usd_to_mxn(FILTER)"
            let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
            
            
            let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
            
            
            let data = LineChartData()
            let ds1 = LineChartDataSet(values: yse1, label: "usd_to_mxn")
            
            ds1.drawCirclesEnabled=false;
            ds1.circleRadius=3
                ds1.lineWidth=3
            ds1.lineWidth=3
            ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
            ds1.mode = .cubicBezier
            ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
            let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            
            ds1.drawFilledEnabled = true // Draw the Gradient
            
            
            
            ds1.valueTextColor=NSUIColor.white
            
            data.addDataSet(ds1)
            
            
            self.lineChartView.data = data
            self.lineChartView.gridBackgroundColor = NSUIColor.white
            //self.lineChartView.widthAnchor
            self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
            self.lineChartView.xAxis.labelTextColor=NSUIColor.white
            
            self.lineChartView.legend.textColor=NSUIColor.white
            self.lineChartView.rightAxis.drawLabelsEnabled=false
            self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
            self.lineChartView.chartDescription?.text = ""
            self.lineChartView.xAxis.drawGridLinesEnabled=false
            
            let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)

            self.lineChartView.marker = marker
            
            
        })

        
        
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
            ref = FIRDatabase.database().reference(withPath: "usd_to_mxn")
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
                self.name="usd_to_mxn(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray)
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "usd_to_mxn")
                
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3                
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient

                
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)
                
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
               
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
              
                
            })
            
        }
        if(sender.tag == 1){
            ref = FIRDatabase.database().reference(withPath: "eur_to_mxn")
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
                self.name="eur_to_mxn(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "eur_to_mxn")
               
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient

                
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)
                
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
                
                
            })
            
        }
        if(sender.tag == 2){
            ref = FIRDatabase.database().reference(withPath: "gbp_to_mxn")
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
                self.name="gbp_to_mxn(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "gbp_to_mxn")
                ds1.colors = [NSUIColor.red]
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient

                
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)
                
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
                
                
            })
            
        }
        if(sender.tag == 3){
            ref = FIRDatabase.database().reference(withPath: "tasa_interes")
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
                self.name="tasa_interes(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "tasa_interes")
                ds1.colors = [NSUIColor.red]
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient

                
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)
                
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                
                
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
            })
            
        }

        if(sender.tag == 4){
            ref = FIRDatabase.database().reference(withPath: "inflacion")
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
                self.name="inflacion(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "inflacion")
                ds1.colors = [NSUIColor.red]
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient

                
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)
                
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
                
            })
            
        }
        if(sender.tag == 5){
            ref = FIRDatabase.database().reference(withPath: "ipc")
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
                self.name="ipc(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "ipc")
                ds1.colors = [NSUIColor.red]
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient

                
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)
                
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
                
            })
            
        }

        if(sender.tag == 6){
            ref = FIRDatabase.database().reference(withPath: "cetes_28_dias")
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
                self.name="cetes_28_dias(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "cetes_28_dias")
                ds1.colors = [NSUIColor.red]
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient
                
                
                ds1.valueTextColor=NSUIColor.white
                data.addDataSet(ds1)
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
            })
            
        }
        

        
        if(sender.tag == 7){
            ref = FIRDatabase.database().reference(withPath: "petroleo")
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
                self.name="petroleo(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
        
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "petroleo")
                ds1.colors = [NSUIColor.red]
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

                ds1.drawFilledEnabled = true // Draw the Gradient

                
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)
                
                
                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
                
            })
            
        }
        if(sender.tag == 8){
            ref = FIRDatabase.database().reference(withPath: "crecimiento_economia")
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
                self.name="crecimiento_economia(FILTER)"
                self.flag=0
                self.flag1=0
                self.flag2=0
                print(date_key,intArray[0])
                let ys1 = Array(0..<date_key.count).map { x in return intArray[x] }
                
                let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
                
                let data = LineChartData()
                let ds1 = LineChartDataSet(values: yse1, label: "crecimiento_economia")
                ds1.colors = [NSUIColor.red]
                ds1.drawFilledEnabled=true;
                ds1.drawCirclesEnabled=false;
                ds1.circleRadius=3
                ds1.lineWidth=3
                ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
                ds1.mode = .cubicBezier
                ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
                
                let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
                
                ds1.drawFilledEnabled = true // Draw the Gradient
                
                ds1.valueTextColor=NSUIColor.white
                
                data.addDataSet(ds1)

                self.lineChartView.data = data
                self.lineChartView.gridBackgroundColor = NSUIColor.white
                self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
                self.lineChartView.xAxis.labelTextColor=NSUIColor.white
                
                self.lineChartView.legend.textColor=NSUIColor.white
                self.lineChartView.rightAxis.drawLabelsEnabled=false
                
                self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                self.lineChartView.chartDescription?.text = ""
                self.lineChartView.xAxis.drawGridLinesEnabled=false
                let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
                
                self.lineChartView.marker = marker
            })
            
        }
    }
    
    @IBAction func yearly(_ sender: Any) {
        var val=[Int]()
        var date_key=[String]()
        
        if flag==0{
        
        for i in 0..<self.global_key.count{
            //let year1=Int(self.global_key[i].components(separatedBy: "-")[0])
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
            if Timestamp-31536000000<nsDateConvertedToTimestamp && nsDateConvertedToTimestamp<Timestamp {
                val.append(self.global_val[i])
                date_key.append(self.global_key[i])
            }
            }
            flag += 1
        }else{
            for i in 0..<self.global_key.count{
                val.append(self.global_val[i])
                date_key.append(self.global_key[i])
            }
            flag=0
        }
        
        if val.isEmpty==true {
            let alertCtrl = UIAlertController(title: "Alert", message: "There are no data matched !", preferredStyle: UIAlertControllerStyle.alert )
            
            // create button action
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            
            // add action to controller
            alertCtrl.addAction(okAction)
            
            
            // show alert
            self.present(alertCtrl, animated: true, completion: nil)
        }else{
        let ys1 = Array(0..<val.count).map { x in return val[x] }
        
        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(values: yse1, label: self.name)
        ds1.colors = [NSUIColor.red]
        ds1.drawFilledEnabled=true;
        ds1.drawCirclesEnabled=false;
        ds1.circleRadius=3
        ds1.lineWidth=3
        ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
        ds1.mode = .cubicBezier
        ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
        
        let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        
        ds1.drawFilledEnabled = true // Draw the Gradient
        
        ds1.valueTextColor=NSUIColor.white
        
        data.addDataSet(ds1)
        
        self.lineChartView.data = data
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
        self.lineChartView.xAxis.labelTextColor=NSUIColor.white
        
        self.lineChartView.legend.textColor=NSUIColor.white
        self.lineChartView.rightAxis.drawLabelsEnabled=false
        
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        self.lineChartView.chartDescription?.text = ""
            self.lineChartView.xAxis.drawGridLinesEnabled=false
            let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
            
            self.lineChartView.marker = marker
        }
    }
    @IBAction func monthly(_ sender: Any) {
        var val=[Int]()
        var date_key=[String]()
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
            
            if Timestamp-2592000000<nsDateConvertedToTimestamp && nsDateConvertedToTimestamp<Timestamp {
                val.append(self.global_val[i])
                date_key.append(self.global_key[i])
            }
        }
            flag1 += 1
        }else{
            for i in 0..<self.global_key.count{
                val.append(self.global_val[i])
                date_key.append(self.global_key[i])
            }
            flag1=0
        }
        if val.isEmpty==true {
            let alertCtrl = UIAlertController(title: "Alert", message: "There are no data matched !", preferredStyle: UIAlertControllerStyle.alert )
            
            // create button action
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            
            // add action to controller
            alertCtrl.addAction(okAction)
            
            
            // show alert
            self.present(alertCtrl, animated: true, completion: nil)
        }else{
            let ys1 = Array(0..<val.count).map { x in return val[x] }
            
            let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
            
            let data = LineChartData()
            let ds1 = LineChartDataSet(values: yse1, label: self.name)
            ds1.colors = [NSUIColor.red]
            ds1.drawFilledEnabled=true;
            ds1.drawCirclesEnabled=false;
            ds1.circleRadius=3
            ds1.lineWidth=3
            ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
            ds1.mode = .cubicBezier
            ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
            
            let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            
            ds1.drawFilledEnabled = true // Draw the Gradient
            
            ds1.valueTextColor=NSUIColor.white
            
            data.addDataSet(ds1)
            
            self.lineChartView.data = data
            self.lineChartView.gridBackgroundColor = NSUIColor.white
            self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
            self.lineChartView.xAxis.labelTextColor=NSUIColor.white
            
            self.lineChartView.legend.textColor=NSUIColor.white
            self.lineChartView.rightAxis.drawLabelsEnabled=false
            
            self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
            self.lineChartView.chartDescription?.text = ""
            self.lineChartView.xAxis.drawGridLinesEnabled=false
            let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
            
            self.lineChartView.marker = marker
        }

    }
    @IBAction func weekly(_ sender: Any) {
        var mondaysDate: Date {
            return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        }
        
        print(String(describing: mondaysDate).components(separatedBy: " ")[0])
        var val=[Int]()
        var date_key=[String]()
        
        
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
            
            if Timestamp-604800000<nsDateConvertedToTimestamp && nsDateConvertedToTimestamp<Timestamp {
                val.append(self.global_val[i])
                date_key.append(self.global_key[i])
            }
        }
            flag2 += 1
        }else{
            for i in 0..<self.global_key.count{
                val.append(self.global_val[i])
                date_key.append(self.global_key[i])
            }
            flag2=0
        }
        if val.isEmpty==true {
            let alertCtrl = UIAlertController(title: "Alert", message: "There are no data matched !", preferredStyle: UIAlertControllerStyle.alert )
            
            // create button action
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            
            // add action to controller
            alertCtrl.addAction(okAction)
            
            
            // show alert
            self.present(alertCtrl, animated: true, completion: nil)
        }else{
            let ys1 = Array(0..<val.count).map { x in return val[x] }
            
            let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y)) }
            
            let data = LineChartData()
            let ds1 = LineChartDataSet(values: yse1, label: self.name)
            ds1.colors = [NSUIColor.red]
            ds1.drawFilledEnabled=true;
            ds1.drawCirclesEnabled=false;
            ds1.circleRadius=3
            ds1.lineWidth=3
            ds1.setColors(NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1))
            ds1.mode = .cubicBezier
            ds1.fillColor=NSUIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1)
            
            let gradientColors = [UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 1).cgColor, UIColor(red: 80/255, green: 223/255, blue: 193/255, alpha: 0.1).cgColor] as CFArray // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            ds1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            
            ds1.drawFilledEnabled = true // Draw the Gradient
            
            ds1.valueTextColor=NSUIColor.white
            
            data.addDataSet(ds1)
            
            self.lineChartView.data = data
            self.lineChartView.gridBackgroundColor = NSUIColor.white
            self.lineChartView.leftAxis.labelTextColor=NSUIColor.white
            self.lineChartView.xAxis.labelTextColor=NSUIColor.white
            
            self.lineChartView.legend.textColor=NSUIColor.white
            self.lineChartView.rightAxis.drawLabelsEnabled=false
            
            self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
            self.lineChartView.chartDescription?.text = ""
            self.lineChartView.xAxis.drawGridLinesEnabled=false
            let marker:BalloonMarker = BalloonMarker(color: UIColor.gray, font: UIFont(name: "Helvetica", size: 12)!,textColor:UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0),dateKey: date_key)
            
            self.lineChartView.marker = marker
        }
        


    }
}

