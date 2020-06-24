//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by kpugame on 2020/04/04.
//  Copyright © 2020 kpugame. All rights reserved.
//

import Foundation
import UIKit

class TestDataSource: NSObject, UITableViewDataSource {
    let tipCalc = TipCalculatorModel(total: 33.25, taxPct: 0.06)
    var possibleTips = [Int: (tipAmt: Double, total:Double)] ()
    var sortedKey:[Int] = []
    
    override init() {
        possibleTips = tipCalc.returnPossibleTips()
        sortedKey = Array(possibleTips.keys).sorted()
        super.init()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedKey.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: nil)
        
        let tipPct = sortedKey[indexPath.row]
        let tipAmt = possibleTips[tipPct]!.tipAmt
        let total = possibleTips[tipPct]!.total
        
        cell.textLabel?.text = "\(tipPct)&:"
        cell.detailTextLabel?.text = String(format: "Tip: $%0.2f, total: $%0.2f", tipAmt, total)
        return cell
    }
}

class TipCalculatorModel {

var total: Double       //post-tax total
var taxPct: Double      //tax percentage
    var subtotal: Double    {//pre-tax subtotal
        get {
            return total / (taxPct + 1)
        }
    }

//class property 는 선언할 때 혹은 initializer 에서 초기값을 지정해야 함
//초기값을 가지지 않기 위해서는 optional로 선언해야 함
init(total: Double, taxPct: Double) {
    self.total = total
    self.taxPct = taxPct
    // subtotal = total / (taxPct + 1)
}
//tip 계산 함수: tip은 pre-tax subtotal에서 계산해야 함
    func calcTipWithTipPct(tipPct: Double) -> (tipAmt:Double, total:Double) {
        let tipAmt = subtotal * tipPct
        let finalTotal = total + tipAmt
        return (tipAmt, finalTotal)
}
//Dictionary (key/value 쌍을 갖는 자료구조)를 반환하는 함수
    func returnPossibleTips()->[Int: (tipAmt:Double, total:Double)] {
    //Inferred array 팁 퍼센트 배열 선언
    let possibleTipsInferred = [0.15, 0.18, 0.20]
    
    //빈 Dictionary 변수 선언
    var retval = [Int: (tipAmt:Double, total:Double)]()
    
    //for 루프에서 3개 팁 퍼센트에 대한 팁을 계산하고 Dictionary에 추가
    for possibleTip in possibleTipsInferred {
        //배열에서 꺼낸 Double 타입의 possibleTip을 Int로 타입 변환
        let intPct = Int(possibleTip*100)
        //팁 계산한 value값을 Dictionary에 key는 intPct 에 맞춰서 삽입
        retval[intPct] = calcTipWithTipPct(tipPct: possibleTip)
    }
    return retval
}
}

let testDataSource = TestDataSource()
let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 320), style: .plain)
tableView.dataSource = testDataSource
tableView.reloadData()
