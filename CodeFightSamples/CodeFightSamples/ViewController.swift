//
//  ViewController.swift
//  testCode
//
//  Created by Prasanna Naik on 9/22/16.
//  Copyright © 2016 Prasanna Naik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //smartAssigning("01/01/2015", repeats: "2", outputs: "4", repeatsOn:["Monday","Thursday"])
        //ancientTempleLocation(radius:3, rectangle:[-1,-1,-1,100], parameters:[-1,2,-4,5,-6])
        //delivery(order: [100, 4, 3], shoppers: [[100,33,1]])
        isAdmissibleOverpayment(prices: [110, 95, 70],
                                notes: ["10.0% higher than in-store",
                                        "5.0% lower than in-store",
                                        "Same as in-store"],
                                x: 5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     After recently joining Instacart's beta testing developer group, you decide to experiment with their new API. You know that the API returns item-specific display-ready strings like 10.0% higher than in-store or 5.0% lower than in-store that inform users when the price of an item is different from the one in-store. But you want to extend this functionality by giving people a better sense of how much more they will be paying for their entire shopping cart.
     
     Your app lets a user decide the total amount x they are willing to pay via Instacart over in-store prices. This you call their price sensitivity.
     
     Your job is to determine whether a given customer will be willing to pay for the given items in their cart based on their stated price sensitivity x.
     
     Example
     
     For
     prices = [110, 95, 70],
     
     notes = ["10.0% higher than in-store",
     "5.0% lower than in-store",
     "Same as in-store"]
     and x = 5, the output should be
     isAdmissibleOverpayment(prices, notes, x) = true.
     
     In-store prices of the first and the second items are 100, and the price of the third item is 70, which means the customer is overpaying 10 - 5 + 0 = 5, which they are willing to do based on their price sensitivity.
     
     For
     prices = [48, 165],
     
     notes = ["20.00% lower than in-store",
     "10.00% higher than in-store"]
     and x = 2, the output should be
     isAdmissibleOverpayment(prices, notes, x) = false.
     
     The in-store price of the first item is 60, and the second item is 150. The overpayment equals 15 - 12 = 3, which is too much for the customer to be willing to pay.
     
     Input/Output
     
     [time limit] 20000ms (swift)
     [input] array.float prices
     
     Positive numbers, representing prices of the items in the shopping cart.
     
     Constraints:
     1 ≤ prices.length ≤ 10,
     20.0 ≤ prices[i] ≤ 35.0 · 103.
     
     [input] array.string notes
     
     Array of the same length as prices. For each valid i notes[i] has one of the following forms:
     
     "x% higher than in-store", which means that Instacart price of the ith item is x% higher than the local one;
     "x% lower than in-store", which means that Instacart price of the ith item is x% lower than the local one;
     "Same as in-store", which means that the ith item costs the same in Instacart and in the local store,
     where x is a positive float number with the decimal point and at least one digit after it.
     
     Constraints:
     notes.length = prices.length,
     16 ≤ notes[i].length ≤ 30.
     
     [input] float x
     
     A non-negative integer, the maximum amount of money the customer is willing to overpay.
     
     Constraints:
     0 ≤ x ≤ 150.0.
     
     [output] boolean
     
     true if the overpayment is admissible, false otherwise.
     */
    func isAdmissibleOverpayment(prices: [Double], notes: [String], x: Double) -> Bool {
        var customerOverpayment:[Double] = []
        var result:Bool = false
        var i:Int = 0
        for x in prices{
            let discount = notes[i]
            var splitNotes = discount.characters.split{$0 == " "}.map(String.init)
            //splitNotes[0] as NSString
            if(splitNotes[0].contains("%")){
                var new = splitNotes[0].characters.split{$0 == "%"}.map(String.init)
                var discountValue = Double(new[0])
                
                var instoreproductprice = 0.0
                
                if(splitNotes[1] == "higher"){
                    instoreproductprice = x / (1 + ((discountValue! / 100)))
                }else if(splitNotes[1] == "lower"){
                    instoreproductprice = x / (1 - ((discountValue! / 100)))
                }
                let roundinstoreproductprice = Double(round(100*instoreproductprice)/100)
                customerOverpayment.append((x - roundinstoreproductprice))
            }else{
                customerOverpayment.append(0.00)
            }
            i += 1
        }
        var totalSentmentValue = 0.0
        for x in customerOverpayment{
            totalSentmentValue = totalSentmentValue + x
        }
        if(totalSentmentValue <= x){
            result = true
        }else{
            result = false
        }
        return result
    }
    
    /*
     Instacart customers are able to set the delivery window during which they want to receive their groceries. There are always plenty of shoppers in the area ready to take a customer's order, but unfortunately they can't always do it right away. Before taking an order a shopper wants to ensure they will make it in time. They also don't want to stay idle, so arriving early isn't an option either.
     
     Our task is to implement an algorithm that determines whether shoppers should take the given order or not.
     
     For each shopper you know their travel speed, distance to the store and the estimated amount of time they will spend there. Figure out which of them can take the order, assuming it is known when the customer wants to receive the groceries and the distance between their house and the store.
     
     Example
     
     For order = [200, 20, 15] and shoppers = [[300, 40, 5], [600, 40, 10]], the output should be
     delivery(order, shoppers) = [false, true].
     
     The store is located 200 m away from the customer's house.
     The customer will be ready to receive the groceries in 20 minutes, but they shouldn't be delivered more than 15 minutes late.
     The first shopper is 300 m away from the store, his speed is 40 m/min, and he will spend 5 minutes in the store, which means that he will need (300 + 200) / 40 + 5 = 17.5 minutes to fulfill the order. This will leave him with 20 - 17.5 = 2.5 idle minutes, so he shouldn't take the order.
     The second shopper is 600 m away from the store, his speed is 40 m/min, and he will spend 10 minutes in the store, which means it will take him (600 + 200) / 40 + 10 = 30 minutes to fulfill the order. The customer can wait for 20 + 15 = 35 minutes, which means that the shopper will make it in time.
     
     Input/Output
     
     [time limit] 20000ms (swift)
     [input] array.integer order
     
     The order is given as an array of 3 positive integers. order[0] is the distance from the customer's home to the store in meters, order[1] is the time by which the customer will be ready to receive the delivery in minutes, and order[2] is the number of minutes they are willing to wait.
     
     Constraints:
     1 ≤ order[i] ≤ 1000.
     
     [input] array.array.integer shoppers
     
     Each element of this array represents a shopper. For each shopper three positive integers are stored in the exact given order: their distance from the shop in meters, their speed in meters per minute and the estimated time they will spend in the store in minutes.
     
     Constraints:
     1 ≤ shoppers.length ≤ 5,
     1 ≤ shoppers[i][j] ≤ 1000.
     
     [output] array.boolean
     
     For each shopper return if they should take the order or not.
     */
    func delivery(order: [Int], shoppers: [[Int]]) -> [Bool] {
        var result:[Bool] = []
        let customerDistanceToShop = order[0]
        let customerTimeToBeReadyToReceiveGrocery = order[1]
        let customerTimeLatestByWhichToReceiveGrocery = order[2] + order[1]
        for x in shoppers{
            var shopperDistanceToShop = x[0]
            var shopperSpeed = x[1]
            var shopperTimeToSpendAtShop = x[2]
            var calculateTotalDistaceBtwShopperAndCustomer = shopperDistanceToShop + customerDistanceToShop
            var timeByWhichTheShopperWillBeDoneShopping = (Float(calculateTotalDistaceBtwShopperAndCustomer) / Float(shopperSpeed)) + Float(shopperTimeToSpendAtShop)
            if(timeByWhichTheShopperWillBeDoneShopping >= Float(customerTimeToBeReadyToReceiveGrocery) && timeByWhichTheShopperWillBeDoneShopping <= Float(customerTimeLatestByWhichToReceiveGrocery)){
                result.append(true)
            }else{
                result.append(false)
            }
        }
        
        print(result)
        return result
    }
    
    func ancientTempleLocation(radius: Int, rectangle: [Int], parameters: [Int]) -> [Int] {
        let xleft = rectangle[0]
        let ybottom = rectangle[1]
        let xright = rectangle[2]
        let ytop = rectangle[3]
        var centerOfCircles:[(Int,Int)] = []
        var powerAtOrigins:[Int] = []
        var areaOfCircleWithOrigins:[Int] = []
        var areaOfCircleInsideRectangle = 0
        var powerForOrigin = 0
        var result:[Int] = []
        for x in xleft...xright{
            for y in ybottom...ytop {
                print("Value of x: " + String(x) + " and y: " + String(y))
                centerOfCircles.append((x,y))
                areaOfCircleInsideRectangle = getAreaInsideRectangle(Xleft:xleft, YBottom:ybottom, Xright:xright, YTop:ytop, Center:(x,y),Radius:radius)
                areaOfCircleWithOrigins.append(areaOfCircleInsideRectangle)
                powerForOrigin = getPowerAtCoOrdinates(center:(x,y),parameters:parameters)
                powerAtOrigins.append(powerForOrigin)
            }
        }
        print("Centers ",centerOfCircles)
        print("Powers ",powerAtOrigins)
        print("area of circles ",areaOfCircleWithOrigins)
        var maxpower = powerAtOrigins[0]
        var resultingArrFromComparison:[Int] = []
        resultingArrFromComparison.append(0)
        for index in 0...(powerAtOrigins.count - 1){
            if(resultingArrFromComparison .contains(index)){
                continue
            }else{
                if(powerAtOrigins[index] > maxpower){
                    maxpower = powerAtOrigins[index];
                    resultingArrFromComparison.removeAll(keepingCapacity: true)
                    resultingArrFromComparison.append(index)
                }else if(powerAtOrigins[index] == maxpower){
                    if(areaOfCircleWithOrigins[index] > areaOfCircleWithOrigins[resultingArrFromComparison[0]]){
                        maxpower = powerAtOrigins[index];
                        resultingArrFromComparison.removeAll(keepingCapacity: true)
                        resultingArrFromComparison.append(index)
                    }else if(areaOfCircleWithOrigins[index] == areaOfCircleWithOrigins[resultingArrFromComparison[0]]){
                        resultingArrFromComparison.append(index)
                    }
                }
            }
        }
        if(resultingArrFromComparison.count == 1){
            let value:(Int, Int) = centerOfCircles[resultingArrFromComparison[0]]
            result.append(value.0)
            result.append(value.1)
        }else{
            var valuePicked:Int = resultingArrFromComparison[0]
            let value:(Int, Int) = centerOfCircles[valuePicked]
            let maxCount = value.0 + value.1
            for index in 0...(resultingArrFromComparison.count - 1){
                let pickValueFromcenterOfCircles:(Int, Int) = centerOfCircles[resultingArrFromComparison[index]]
                let comparisonResult = pickValueFromcenterOfCircles.0 + pickValueFromcenterOfCircles.1
                if(comparisonResult > maxCount){
                    valuePicked = resultingArrFromComparison[index]
                }
            }
            result.append(centerOfCircles[valuePicked].0)
            result.append(centerOfCircles[valuePicked].1)
        }
        //print("Resukt: ",result)
        return result
    }
    func getAreaInsideRectangle(Xleft:Int, YBottom:Int, Xright:Int, YTop:Int, Center:(Int,Int),Radius:Int)->Int{
        let circleleftx:Int = Center.0-Radius
        print("circlebottomx ",circleleftx)//start x index
        let circlelefty:Int = Center.1-Radius//start y index
        print("circlebottomy ",circlelefty)
        let circlerightx:Int = Center.0+Radius//end x index
        print("circletopx ",circlerightx)
        let circlerighty:Int = Center.1+Radius//end y index
        print("circletopy ",circlerighty)
        /**************************************/
        //Calculate total lenght
        var length = circlerightx - circleleftx
        print("length ",length)
        var height = circlerighty - circlelefty
        print("height ",height)
        /**************************************/
        let xleftoffset = Xleft - circleleftx
        if(xleftoffset > 0){
            length -= xleftoffset
            print("adjusted length x left ",length)
        }
        let xrightoffset = Xright - circlerightx
        if(xrightoffset < 0){
            length += xrightoffset
            print("adjusted length x right ",length)
        }
        /**************************************/
        let ybottomoffset = YBottom - circlelefty
        if(ybottomoffset > 0){
            height -= ybottomoffset
            print("adjusted length y bottom ",height)
        }
        let ytopoffset = YTop - circlerighty
        if(ytopoffset < 0){
            height += ytopoffset
            print("adjusted length y top ",height)
        }
        /**************************************/
        return (length*height)
    }
    func getPowerAtCoOrdinates(center:(Int,Int),parameters: [Int])->Int{
        return ((parameters[0]*center.0) + (parameters[1]*center.1) + (parameters[2]*center.0*center.1) + (parameters[3] * center.0 * center.0) + (parameters[4] * center.1 * center.1))
    }
    /*
     func smartAssigning(dateString: String, repeats: String, outputs: String, repeatsOn:[String]){
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "dd/mm/yyyy"
     //let date = dateFormatter.dateFromString(dateString)!
     let cal = NSCalendar.current
     let components = cal.components([.Weekday,.Day,.Month,.Year], fromDate: date)
     let weekDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
     
     let year = components.year
     let month = components.month
     let day = components.day
     var startWeekDay:Int = components.weekday
     startWeekDay -= 1
     let isLeapYear = isYearLeapYearCheck(year)
     var finalindex:Int = NSInteger(outputs)!
     finalindex -= 1
     var resultOfDates:[String] = []
     for index in 0...finalindex {
     
     }
     
     
     }
     func isYearLeapYearCheck(year:Int)->Bool{
     var result:Bool = false
     if((year % 100 != 0 && year%4 == 0)||(year%400 == 0)){
     result = true
     }
     return result
     }
     */
    
}

