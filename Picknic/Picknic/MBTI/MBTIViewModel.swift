//
//  MBTIViewModel.swift
//  MVVMBasic
//
//  Created by Lee on 8/13/25.
//

import Foundation

final class MBTIViewModel {

    var input: Input
    var output: Output

    private var selectedIndexDictionary: [Int:Int] = [:]
    private let buttonTitleArr = ButtonTitle.e.horizontalArray

    struct Input {
        let textFieldValue: Observable<String?> = Observable(value: nil)
        let textResult: Observable<String?> = Observable(value: nil)
        let selectedMBTI: Observable<Int?> = Observable(value: nil)
        let completedButtonTapped: Observable<Void> = Observable(value: ())
    }

    // 유저 이벤트랑 튜플 타입인지와 별개인거 같고 다시 생각해봐야 함
    // 모델로 정의, enum으로 정의, 튜플, 배열
    // enum case로 정의를 하고, Observable(value: enum)
    struct Output {
        let validateLabel: Observable<String> = Observable(value: "")
        let checkValidate: Observable<Bool> = Observable(value: false)
        let reloadIndex: Observable<[Int]> = Observable(value: [])
        let checkButtonState: Observable<(txtCon: Bool, btnCon: Bool)> = Observable(value: (false, false))
    }

    init() {
        input = Input()
        output = Output()

        transform()
    }

    private func transform() {
        input.textFieldValue.lazyBind { text in
            self.checkUserInput(text)
        }

        input.textResult.lazyBind { text in
            self.output.checkValidate.value = self.checkUserInput(text)
            print(self.checkUserInput(text))
        }

        input.selectedMBTI.bind { tappedIndex in
            guard let tappedIndex else { return }
            let groupKey = self.buttonTitleArr[tappedIndex].groupKey
            let selectedIndex = self.selectedIndexDictionary[groupKey]
            if selectedIndex == nil {
                self.selectedIndexDictionary[groupKey] = tappedIndex
                self.output.reloadIndex.value = [tappedIndex]
            } else if selectedIndex == tappedIndex {
                self.selectedIndexDictionary[groupKey] = nil
                self.output.reloadIndex.value = [tappedIndex]
            } else {
                if let selectedIndex {
                    let reloadIndexs = [selectedIndex, tappedIndex]
                    self.selectedIndexDictionary[groupKey] = tappedIndex
                    self.output.reloadIndex.value = reloadIndexs
                }
            }

            // TODO: 이거 어떻게 합치지? tuple로 받아야 하나
            if self.selectedIndexDictionary.count == 4 {
                self.output.checkButtonState.value.btnCon = true
            } else {
                self.output.checkButtonState.value.btnCon = false
            }
        }

        input.completedButtonTapped.lazyBind { _ in
            self.output.checkValidate.value = self.checkTotalValidate()
            print("completedButtonTapped", self.checkTotalValidate())
        }
    }

    // TODO: 이 코드를 internal로 열어서 VC가 사용하는게 맞는지 고민해봐야함
    func buttonSelected(_ index: Int) -> Bool {
        let groupKey = self.buttonTitleArr[index].groupKey
        return selectedIndexDictionary[groupKey] == index
    }

    @discardableResult
    private func checkUserInput(_ text: String?) -> Bool {
        guard let text, text.count >= 2 && text.count < 10 else {
            output.validateLabel.value = "2글자 이상 10글자 미만을 입력해주세요"
            return false
        }

        let pattern = "[0-9]"

        if text.range(of: pattern, options: .regularExpression) != nil {
            output.validateLabel.value = "숫자는 입력할 수 없습니다"
            return false
        }

        let specialPattern = "[@#$%]"

        if text.range(of: specialPattern, options: .regularExpression) != nil {
            output.validateLabel.value = "@, #, $, % 특수문자는 입력이 불가능합니다"
            return false
        }

        output.checkButtonState.value.txtCon = true
        output.validateLabel.value = ""
        return true
    }

    private func checkTotalValidate() -> Bool {
        if output.checkButtonState.value.txtCon && output.checkButtonState.value.btnCon {
            return true
        }

        return false
    }
}

