//Tip Calculator 클래스 선언
class TipCalculator {
    //상수 선언 : Initializer 에서 초기값을 가지므로 Error 사라짐
    let total: Double       //post-tax total
    let taxPct: Double      //tax percentage
    let subtotal: Double    //pre-tax subtotal
    
    //class property 는 선언할 때 혹은 initializer 에서 초기값을 지정해야 함
    //초기값을 가지지 않기 위해서는 optional로 선언해야 함
    init(total: Double, taxPct: Double) {
        self.total = total
        self.taxPct = taxPct
        subtotal = total / (taxPct + 1)
    }
    //tip 계산 함수: tip은 pre-tax subtotal에서 계산해야 함
    func calcTipWithTipPct(tipPct: Double) -> Double {
        return subtotal * tipPct
    }
    //Dictionary (key/value 쌍을 갖는 자료구조)를 반환하는 함수
    func returnPossibleTips()->[Int: Double] {
        //Inferred array 팁 퍼센트 배열 선언
        let possibleTipsInferred = [0.15, 0.18, 0.20]
        
        //빈 Dictionary 변수 선언
        var retval = [Int: Double]()
        
        //for 루프에서 3개 팁 퍼센트에 대한 팁을 계산하고 Dictionary에 추가
        for possibleTip in possibleTipsInferred {
            //배열에서 꺼낸 Double 타입의 possibleTip을 Int로 타입 변환
            let intPct = Int(possibleTip*100)
            //팁 계산한 value값을 Dictionary에 key는 intPct 에 맞춰서 삽입
            retval[intPct] = calcTipWithTipPct(tipPct: possibleTip)
        }
        return retval
    }
    /*
    //15% 18% 20% 팁을 포함한 가격을 리스트 프린트하는 함수
    //array와 for 루프를 이용해서 다시 작성
    func printPossibleTips() {
        //Inferred와 Explicit array 변수 선언: 워닝 무시!
        let possibleTipsInferred = [0.15, 0.18, 0.20]
        let possibleTipsExplicit: [Double] = [0.15, 0.18, 0.20]
        
        //for 루프 : possibletipsInferred 배열에서 하나씩 꺼내서 루프 실행
        for possibleTip in possibleTipsInferred {
            print("\(possibleTip*100)%: \(calcTipWithTipPct(tipPct: possibleTip))")
        }
        //다른 스타일의 for 루프
        //..< 연산자는 상한은 포함안함. 반면에 ... 연산자는 상한 포함함
        //배열의 원소 개수 연산자: .count, 배열 원소 추출 연산자 : [index]
        for i in 0..<possibleTipsExplicit.count {
            let possibleTip = possibleTipsExplicit[i]
            print("\(possibleTip*100)%: \(calcTipWithTipPct(tipPct: possibleTip))")
        }
    } */
}

//클래스 바깥에 인스턴스 생성 및 멤버함수 호출
//레스토랑 계산서 total 이 팁을 포함하지 않고 tax만 포함한 것임
//팁은 따로 subtotal(tax 포함하지 않는)에서 15~20% 정도 계산해서 테이블 위에 온다고 가정!!
let tipCalc = TipCalculator(total: 33.25, taxPct: 0.06)
//tipCalc.printPossibleTips()
tipCalc.returnPossibleTips()
