type token = {name: string, value: string}

type charType =
  | Int(string)
  | Upper(string)
  | Lower(string)
  | NoOp(string)

// makeStringFromMatch
let makeStringFromMatch = (chars, current, break) => {
  let stringsArr = []

  while break.contents != true {
    let currentChar = chars[current.contents + 1]
    let nextChar = chars[current.contents + 2]
    Js.log("nextchar: " ++ nextChar)
    switch true {
    | true if nextChar == " " => break := true
    | _ => {
        incr(current)
        let _ = stringsArr |> Js.Array.push(currentChar)
      }
    }
  }
  //return
  let combinedString = Js.Array.joinWith("", stringsArr)
  combinedString
}

// TOKENIZE -
let tokenize = (input: string) => {
  // filtering stops
  let current = ref(0)
  let break = ref(false)

  let wsRegex = %re("/\s/")
  let numRegex = %re("/[0-9]/")
  let lowercaseRegex = %re("/^[a-z]/")
  let uppercaseRegex = %re("/^[A-Z]+$/")

  let chars = Js.String.split("", input)

  // start maping here
  let tokens = Js.Array.map(char => {
    let isNum = Js.Re.test_(numRegex, char)
    let isWhitespace = Js.Re.test_(wsRegex, char)
    let isUpper = Js.Re.test_(uppercaseRegex, char)
    let isLower = Js.Re.test_(lowercaseRegex, char)

    /* switch isUpper { */
    /* | true => { */
    /* let testingFn = makeStringFromMatch(chars, current, break) */
    /* Js.log(" testing fn: " ++ testingFn) */
    /* } */
    /* | false => Js.log("false") */
    /* } */
    // switch for char
    switch true {
    | true if char == "(" => {
        incr(current)
        {name: "paren", value: char}
      }
    | true if char == ")" => {
        incr(current)
        {name: "paren", value: char}
      }
    | true if isWhitespace => {
        incr(current)
        {name: "space", value: char}
      }
    | true if isUpper => {
        incr(current)
        // let resValue = makeStringFromMatch(chars, current, break)
        {name: "upper", value: char}
      }
    | true if isLower => {
        incr(current)
        {name: "lower", value: char}
      }
    | true if isNum => {name: "number", value: char}
    | _ => {name: "noop", value: ""}
    }
  }, chars)

  let onlyUppers =
    tokens |> Js.Array.filter(v => v.name == "upper") |> Js.Array.reduce((prev, next) => {
      let comboValue = Js.String.concat(next.value, prev.value)
      {name: "upper", value: comboValue}
    }, {name: "", value: ""})
  Js.log(onlyUppers)
}
