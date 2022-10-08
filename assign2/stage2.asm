main:
      MOV R4, #askMakerName         // read maker's name
      STR R4, .WriteString
      MOV R4, #codemaker
      STR R4, .ReadString

      MOV R4, #askBreakerName       // read break's name
      STR R4, .WriteString
      MOV R4, #codebreaker
      STR R4, .ReadString

      MOV R4, #askMaxQueries        // read max queries
      STR R4, .WriteString
      LDR R5, .InputNum

      MOV R4, #printMaker           // print maker's name
      STR R4, .WriteString
      MOV R4, #codemaker
      STR R4, .WriteString
      BL newline

      MOV R4, #printBreaker         // print breaker's name
      STR R4, .WriteString
      MOV R4, #codebreaker
      STR R4, .WriteString
      BL newline

      MOV R4, #printMaxQueries      // print max queries
      STR R4, .WriteString
      STR R5, .WriteSignedNum
      BL newline

      MOV R0, #querycode
      BL getcode
      HALT

// desc: print new line char
newline:
      MOV R0, #0xA
      STRB R0, .WriteChar
      RET

// desc: read code from user input and store it into arr
// params: R0 -> arr
// return: R0 -> arr with values
getcode:                            
      PUSH {R3, R4, R5, R6, R7, R8, R9}
getcodeMain:
      MOV R1, #askCode
      STR R1, .WriteString
      STR R0, .ReadString
      MOV R3, #0                    // offset
      MOV R4, #allowedChars
      LDR R7, charSize
      LDR R8, codeSize
      LDR R9, allowedCharsSize
getcodeLoop:                        // for char in code
      LDRB R2, [R0 + R3]
      ADD R3, R3, R7
      CMP R2, #0                    // end of string
      BEQ getcodeReturn

      CMP R3, R8                    // string length > 4
      BGT getcodeMain

      MOV R5, #0                    // offset
getcodeLoop2:                       // for char in allowedChars
      LDRB R6, [R4 + R5]
      CMP R2, R6
      BEQ getcodeLoop               // char is allowed

      ADD R5, R5, R7
      CMP R5, R9                    // end of string
      BLT getcodeLoop2
      B getcodeMain                 // char is not allowed
getcodeReturn:
      CMP R3, R8                    // length < 4
      BLT getcodeMain
      POP {R3, R4, R5, R6, R7, R8, R9}
      RET

codemaker: .BLOCK 128
codebreaker: .BLOCK 128
querycode: .BLOCK 128
askMakerName: .ASCIZ "Enter code maker name:\n"
askBreakerName: .ASCIZ "Enter code breaker name:\n"
askMaxQueries: .ASCIZ "Enter the maximum number of queries:\n"
printMaker: .ASCIZ "Codemaker is: "
printBreaker: .ASCIZ "Codebreaker is: "
printMaxQueries: .ASCIZ "Maximum number of guesses: "
askCode: .ASCIZ "Enter a code:\n"
charSize: 1
codeSize: 4
allowedCharsSize: 6
allowedChars: .ASCIZ "rgbypc"
