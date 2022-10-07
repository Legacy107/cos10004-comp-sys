main:
      MOV R4, #askMakerName         // read maker name
      STR R4, .WriteString
      MOV R4, #codemaker
      STR R4, .ReadString

      MOV R4, #askBreakerName       // read break name
      STR R4, .WriteString
      MOV R4, #codebreaker
      STR R4, .ReadString

      MOV R4, #askMaxQueries        // read max query
      STR R4, .WriteString
      LDR R5, .InputNum

      MOV R4, #printMaker
      STR R4, .WriteString
      MOV R4, #codemaker
      STR R4, .WriteString
      BL newline

      MOV R4, #printBreaker
      STR R4, .WriteString
      MOV R4, #codebreaker
      STR R4, .WriteString
      BL newline

      MOV R4, #printMaxQueries
      STR R4, .WriteString
      STR R5, .WriteSignedNum
      BL newline

      MOV R0, #querycode
      BL getcode
      HALT

newline:
      MOV R0, #0xA
      STRB R0, .WriteChar
      RET

getcode:                            // params: R0 -> arr
      PUSH {R3, R4, R5, R6, R7}
      MOV R1, #askCode
      STR R1, .WriteString
      STR R0, .ReadString
      MOV R3, #0                    // offset
      MOV R4, #allowedChars
      LDR R7, charSize
getcodeLoop:                        // for char in code
      LDRB R2, [R0 + R3]
      ADD R3, R3, R7
      CMP R2, #0                    // end of string
      BEQ getcodeReturn

      CMP R3, #5                    // string length > 4
      BEQ getcode

      MOV R5, #0                    // offset
getcodeLoop2:                       // for char in allowedChars
      LDRB R6, [R4 + R5]
      CMP R2, R6
      BEQ getcodeLoop               // char is allowed

      ADD R5, R5, R7
      CMP R5, #6                    // end of string
      BLT getcodeLoop2
      B getcode                     // char is not allowed

getcodeReturn:
      CMP R3, #4                    // length < 4
      BLT getcode
      POP {R3, R4, R5, R6, R7}
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
allowedChars: .ASCIZ "rgbypc"
