# iOS 커리어 스타터 캠프
# 계산기

> 프로젝트 기간: 2023.01.24-
> 
> 팀원: 👩🏻‍💻[리지](https://github.com/yijiye?tab=repositories) | 리뷰어: 👩🏻‍💻[Judy](https://github.com/Judy-999)
>


## 목차
1. [프로젝트 소개](#프로젝트-소개)
2. [타임라인](#타임라인)
3. [폴더구조](#폴더구조)
4. [UML](#UML)
5. [트러블 슈팅](#트러블-슈팅)
6. [참고 링크](#참고-링크)


# 프로젝트 소개

- 숫자와 기호를 이용하여 사칙연산을 하는 계산기 앱 만들기


# 타임라인 
- 23.01.24(화) : 사칙연산을 구현하기 위한 UML 작성
- 23.01.25(수) : UML을 기반으로 CalculatorItemQueue 구현
- 23.01.26(목) : Queue 코드 보완 
- 23.01.27(금) : STEP2 UML 기반 코드 작성하기 - Operator 구현
<br>

# 폴더구조
```
Calculator
├── Model
|   ├── CalculatorItemQueue
├── └── CalculateItemProtocol
├── CalculatorItemQueueTests
├── └── CalculatorItemQueueTests
├── AppDelegate
├── SceneDelegate
└── ViewController
```

# UML
<img src = "https://user-images.githubusercontent.com/114971172/215016145-d4a92a78-bbea-41df-b0b4-66bf645cbc10.png" width = "500">
   

# 트러블 슈팅 

## **[기능 구현]**

### 1. 배열 vs 연결리스트
  - 자료구조 중에 배열과 연결리스트가 있었고 둘중에 어떤 것을 사용하면 좋을지 고민했습니다. 결정하고자 둘의 장단점을 비교해보았습니다.

### ⚒️ 해결방법

#### 장단점 비교 

|      | 배열                                                 | 연결리스트                                 |
| ---- | ---------------------------------------------------- | ------------------------------------------ |
|    장점  |   - 위치가 정해져있어 빠르게 원하는 값을 찾을 수 있다                                                   |  - 데이터를 추가하거나 삭제하는게 자유롭다                                         |
| 단점 | - 값을 삽입하거나 삭제할때 메모리 공간을 효율적으로 사용하기 위해 값을 당기거나 늘리거나 해야할 경우 시간복잡도가 증가할 수 있다. | - 위치가 정해져있지 않아 원하는 값을 순차적으로 찾아야한다. 따라서 원하는 값을 찾을때 시간이 소요된다.|

- 장단점을 비교했을 때, 값을 추가 삭제하는 경우엔 연결리스트가 배열보다 좋을 것 같다는 생각을 했습니다. 그러나 swift에서 배열은 이미 구현되어 있지만 연결리스트는 구현되어 있지 않아 새로 구현해줘야 한다는 번거로움이 있었고 내용도 배열보다 어렵다고 느꼈습니다.
- 따라서 주디랑 얘기했을 때 러닝커브도 중요한 기준이 된다는 얘기를 듣고 개념 이해가 확실한 배열을 선택하여 적용했습니다.

### 2. 큐를 배열로 구현했을 때 시간복잡도 문제를 해결하는 방법
- 큐는 먼저들어간 값이 먼저 나오게되는 구조로 되어있습니다. 그렇기 때문에 첫번째 값이 빠져나가면 값들이 하나씩 당겨지는 오버헤드 현상이 생기게 되어 시간복잡도가 O(n)이 되었습니다. 이를 해결하고자 두가지 방법을 알아보고 더 적합한 방법을 적용하였습니다.


### ⚒️ 해결방법

#### 1. 커서큐

```swift
struct Queue<T> {
    var queue: [T?] = []
    var head: Int = 0
    
    mutating func dequeue() -> T? {
        guard head <= queue.count, let element = queue[head] else { return nil }
        queue[head] = nil
        head += 1
        
        if head > 50 { // nil로 반환된 값을 삭제해주는 기준
            queue.removeFirst(head)
            head = 0
        }
        return element
    }
```

- 값을 하나씩 당겨줄 필요 없이 ```head``` 포인터를 이용하여 위치를 입력해 주어 해결하는 방법.
- head가 큐배열의 수보다 작고 head의 위치에 있는 큐배열의 값이 존재하면 그 값은 nil로 반환하고 head는 +1을 해서 옆으로 이동.
- 계속해서 반복하면 nil이 남아있게 되므로 50개를 기준으로 nil을 모두 삭제해주고 head도 다시 0으로 초기화 시켜주어 문제를 해결.

#### 2. 더블 스택큐 ✅ 

```swift
struct DoubleStackQueue<T> {
    var input: [T] = []
    var output: [T] = []
    var isEmpty : Bool {
        return input.isEmpty && output.isEmpty
    }
    
    var count: Int {
        return input.count + output.count
    }
    
    mutating func enqueue(_ data: T) {
        input.append(data)
    }
    
    mutating func dequeue() -> T? {
        if output.isEmpty {
            output = input.reversed()
            input.removeAll() // 중복값으로 들어가지 않게 해주려고 input.removeAll을 한다.
        }
        return output.removeLast()
    }
}
```
- 두개의 빈 배열을 만들어 주고 enqueue로 값을 넣어주고 그 값을 ```reversed```해주어 값을 반대로 뒤집은 다음 마지막 값을 제거하여 반환하여 시간복잡도가 그대로 O(1)로 해결해 줄 수 있는 방법.

- ```input.removeAll()```확인하는 코드
```swift
var someQueue = DoubleStackQueue<String>()
someQueue.enqueue("10")
someQueue.enqueue("11")
someQueue.enqueue("12")
print(someQueue.input) // 10, 11, 12
someQueue.dequeue()
print(someQueue.output) // 12, 11
print(someQueue.input) // 10, 11, 12
someQueue.enqueue("13")
print(someQueue.input) // 13
print(someQueue.output) // 12, 11
someQueue.dequeue() // 11
someQueue.dequeue() // 12
someQueue.dequeue() // 비어있으니까 input을 reversed() 하고 removeLast() 해서 13 반환
print(someQueue.output) // 빈 배열
```

- 값을 넣어주고 빼주고 반복하면 왜 저 구문이 필요한지 확인할 수 있음.
- 만약 input을 제거해주는 구문이 없다면 계속해서 쌓이고 중복되는 경우가 발생!!

#### 결론적으로, 
- 커서큐의 경우 nil로 바뀐 값들을 제거해주기 전까지는 메모리 상에 남아있기 때문에 불필요한 값이 있을 수 있다고 생각했습니다. 그래서 조금 더 깔끔한 더블 스택큐를 선택하였습니다.


### 3. protocol, extension
- 미션에서 언급한 protocol은 비어있었고, 큐를 구현할때는 모든 타입이든 받을 수 있는 제네릭타입으로 구현했습니다. 처음에 이 둘의 연관관계에 대해 생각하는 것이 어려웠습니다.

### ⚒️ 해결방법
- 주디랑 멘토링 시간에 주디의 도움을 받아 어떤 역할로써 protocol이 존재하는지 알게되었습니다! 
- protocol은 하나의 약속으로 그 protocol을 채택하게 되면 그 안에 있는 기능을 반드시 준수해야합니다. 현재 과제에서는 비어있기 때문에 반드시 준수해야하는 항목은 없었습니다. 대신 extension을 사용하여 protocol을 채택하고 있는 CalculateItemQueue의 타입을 제한해주도록 구현할 수 있었습니다. 

```swift
protocol CalculateItemProtocol {

 }

 extension String: CalculateItemProtocol {

 }

 extension Double: CalculateItemProtocol {

 }
```
- 위와같이 구현하여 같은 프로토콜을 채택하고 있는 CalculateItemQueue 역시 String 과 Double 타입만 구현할 수 있게 되었습니다.

### 4. 접근제어 (쓰기전용)
- 코드에 접근제어를 설정하려고 했는데, TDD를 작성하기 때문에 ```private``` 으로 걸어두면 접근할 수가 없었습니다.

### ⚒️ 해결방법
- 이를 해결하고자 읽는것은 가능하지만 쓰는것은 접근제어로 막아 변경할 수 없게끔 수정하였습니다.
- 또한 테스트에 필요한 기본값은 ```setUpWithError()```구문에서 초기화를 시켜주는 것으로 해결했습니다.

```swift
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CalculatorItemQueue(items: [], reversedItems: [])
    }
```
- ```setUpWithError()```는 각 테스트 케이스가 실행되기 전에 호출되어 모든 테스트가 동일한 조건에서 확인되도록 하는 역할을 하고 있습니다. ```tearDownWithError()```는 각 테스트 케이스가 실행된 후에 호출되어 nil을 처리해서 값일 해제해주는 역할을 하고있습니다.
- 기본값으로 빈 배열을 넣어주고 필요할때 마다 ```CalculateItemQueue```의 메서드 (```enqueue,dequeue```)를 실행하여 값을 변경해주는 방법으로 테스트를 진행했습니다. 

### 5. TDD 구현
- TDD는 코드를 작성하기 전에 실패케이스를 테스트하면서 올바른 코드를 작성하기 위함이고 Unit Test는 코드를 작성한 후에 코드가 제대로 작동하는지 확인하기 위해 작성하는 테스트입니다. 큐를 구현할때 코드가 단순해서 실패케이스를 작성하는 것이 어려웠습니다. 또한 메서드가 하는 역할과 상관없는 테스트를 작성하기도 했습니다.


### ⚒️ 해결방법

- 기본적으로 테스트할 메서드가 하는 역할이 무엇인지 초점을 맞추고 수정했습니다. 예를 들어 dequeue 메서드의 경우 결국 반환하는 값이 맞는지, 또는 nil을 반환하는 경우는 어떤 경우인지가 가장 중요한 핵심이였습니다. 따라서 아래와 같이 테스트 코드를 수정하였습니다.

```swift
 func test_dequeue_를실행했을때_output과_input이비어있다면_nil을반환한다() {
         //when
         let result = sut.dequeue()

         //then
         XCTAssertNil(result)

     }

     func test_dequeue_를실행했을때_output은비어있고_input은비어있지않을때_output은input의_첫번째값을반환한다() {
         //given
         let input = ["1", "2", "+"]

         //when
         for value in input {
             sut.enqueue(value)
         }
         let result = sut.dequeue()
         let expectation = "1"

         XCTAssertEqual(result, expectation)
     }

```

### 6. 마지막값 반환하는 메서드 
- 아무생각없이 removeLast()를 처음에 사용했었는데 반환값은 옵셔널로 했습니다. removeLast()는 값이 반드시 있을경에만 사용해야 하기 때문에 문맥에 맞지 않는 코드였습니다.

### ⚒️ 해결방법
- 여러종류의 메서드와 프로퍼티를 확인해보고 맞는 메서드를 적용하였습니다.

🔹 **last** 
> 마지막 값을 삭제하지 않고 반환한다. 옵셔널이기 때문에 빈 배열일 경우 nil을 반환한다.

```swift!
var array: [Int] = [1, 2, 3, 4, 5]

array.last // 5
print(array) // [1, 2, 3, 4, 5]
```
🔹 **dropLast(Int)**
> 뒤에서 Int 만큼 값을 제외하고 나머지 값을 반환한다. 이때 제외한 값은 삭제되지 않는다.

```swift
array.dropLast(2) // [1, 2, 3]
print(array) // [1, 2, 3, 4, 5]
```
🔹 **popLast()**
> 마지막 값을 삭제하고 반환한다. 옵셔널이기 때문에 빈 배열일 경우 nil을 반환한다.

```swift
array.popLast() // 5
print(array) // [1, 2, 3, 4]
```
🔹 **removeLast()**
> 마지막 값을 삭제하고 반환한다. 값이 늘 있어야 하므로 배열이 비어있으면 오류가 발생한다.

```swift
array.removeLast() // 4
print(array) // [1, 2, 3]
```
🔹 **removeLast(Int)**
> 뒤에서 Int 만큼 값을 제외하고 나머지 값을 반환한다. 이때 제외한 값은 삭제된다.
```swift
array.removeLast(2) // [1]
print(array) // [1]
```

**reversed() vs reverse()**

🔹 **reversed()**
> 배열의 순서를 뒤집어서 접근할 수 있지만 새로운 배열로 반환해주지는 않는다.

🔹 **reverse()**
> 원래의 배열을 뒤집어서 새로운 배열로 바꿔준다.

```swift
var someArray: [Int] = [10, 20, 30]

let reversed: [Int] = someArray.reversed() // [Int]타입의 reversed에 새로 넣어주면 확인할 수 있다.
print(reversed) // [30, 20, 10]
print(someArray) // [10, 20, 30]

someArray.reverse() 
print(someArray) // [30, 20, 10]
```
---

# 참고 링크
[zdodev.github](https://zdodev.github.io/uml/swift/UML-Class-Diagram/)
[nextree](https://www.nextree.co.kr/p6753/)
[Apple-array 공식문서](https://developer.apple.com/documentation/swift/array)
[개발자아라찌](https://apple-apeach.tistory.com/8)
[개발자소들이](https://babbab2.tistory.com/84)
[dudu-velog](https://velog.io/@aurora_97/Swift-큐)
[Apple-remove 공식문서](https://developer.apple.com/documentation/swift/array/removelast())
[Apple-protocol 공식문서](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)
[Apple-extension 공식문서](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)

