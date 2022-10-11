main:
      MOV R4, #.burlywood
      MOV R1, #.PixelScreen
      MOV R2, #0
      LDR R3, .PixelAreaSize
clearScreen:
      STR R4, [R1]                  // clear screen
      ADD R1, R1, #4
      ADD R2, R2, #1
      CMP R2, R3
      BLT clearScreen

      MOV R4, #askMakerName         // read maker's name
      STR R4, .WriteString
      MOV R4, #codemaker
      STR R4, .ReadString

      MOV R4, #askBreakerName       // read breaker's name
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

      MOV R1, #.PixelScreen         // draw borders
      ADD R1, R1, #104
      MOV R2, #0
      MOV R4, #.grey
drawVerticalLines:
      MOV R3, R1
      STR R4, [R3]
      ADD R3, R3, #20
      STR R4, [R3]
      ADD R3, R3, #4
      STR R4, [R3]
      ADD R3, R3, #20
      STR R4, [R3]
      ADD R1, R1, #256
      ADD R2, R2, #1
      CMP R2, R5
      BLT drawVerticalLines

      MOV R4, #codemaker            // read secret code
      STR R4, .WriteString
      MOV R4, #askSecretCode
      STR R4, .WriteString
      MOV R0, #secretcode
      BL getcode

      MOV R6, #0                    // current number of guesses
      LDR R7, codeSize
loop:
      ADD R6, R6, #1

      MOV R4, #codebreaker          // print number of guess
      STR R4, .WriteString
      MOV R4, #printGuessNumber
      STR R4, .WriteString
      STR R6, .WriteSignedNum
      BL newline

      MOV R4, #askQueryCode         // read query code
      STR R4, .WriteString
      MOV R0, #querycode
      BL getcode

      MOV R0, #secretcode           // count matches
      MOV R1, #querycode
      BL comparecodes

      MOV R4, #printPositionMatches // print feedback
      STR R4, .WriteString
      STR R0, .WriteSignedNum
      MOV R4, #printColourMatches
      STR R4, .WriteString
      STR R1, .WriteSignedNum
      PUSH {R0, R1}
      BL newline
      POP {R0, R1}

      PUSH {R0, R1}
      MOV R2, #responsecode
      BL getResponseCode
      POP {R0, R1}

      PUSH {R0, R1}
      SUB R0, R6, #1
      MOV R1, #querycode
      MOV R2, #responsecode
      BL displayGuess
      POP {R0, R1}

      CMP R0, R7                    // check win
      BEQ win

      CMP R6, R5
      BLT loop
lose:
      MOV R4, #codebreaker
      STR R4, .WriteString
      MOV R4, #printLose
      STR R4, .WriteString
      HALT
win:
      MOV R4, #codebreaker
      STR R4, .WriteString
      MOV R4, #printWin
      STR R4, .WriteString
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

// desc: compare query to secret code and return feedback 
// params: R0 -> secret array, R1 -> query array
// return: R0 -> number of exact matches, R1 -> number of colour matches
comparecodes:
      PUSH {R3, R4, R5, R6, R7, R8, R9}
      LDR R2, charSize
      MOV R3, #0                    // exact match
      MOV R4, #0                    // partial match
      MOV R5, #0                    // offset
      LDR R9, codeSize
comparecodesLoop:
      LDRB R6, [R0 + R5]            // char in secret
      LDRB R7, [R1 + R5]            // char in query
      CMP R6, R7                    // exact match
      BNE comparecodesElse
      ADD R3, R3, #1
      B comparecodesEndIf
comparecodesElse:
      MOV R8, #0                    // offset
comparecodesLoop2:
      LDRB R6, [R0 + R8]            // char in secret
      CMP R6, R7                    // partial match
      BNE comparecodesLoop2Else
      ADD R4, R4, #1
      B comparecodesEndIf
comparecodesLoop2Else:
      ADD R8, R8, R2
      CMP R8, R9
      BLT comparecodesLoop2
comparecodesEndIf:
      ADD R5, R5, R2
      CMP R5, R9
      BLT comparecodesLoop

      MOV R0, R3
      MOV R1, R4
      POP {R3, R4, R5, R6, R7, R8, R9}
      RET

// desc: convert code to array of colours
// params: R0 -> arr, R1 -> code
// return: R0 -> arr of colours
getColour:
      PUSH {R3, R4, R5, R6, R7, R8}
      LDR R2, charSize
      LDR R3, codeSize
      LDR R8, wordSize
      MOV R4, #0                    // char arr offset
      MOV R5, #0                    // colour arr offset
getColourLoop:
      LDRB R6, [R1 + R4]            // char in code

      CMP R6, #0x72                 // r
      BNE getColourG
      MOV R7, #.red
      B getColourStore
getColourG:
      CMP R6, #0x67                 // g
      BNE getColourB
      MOV R7, #.green
      B getColourStore
getColourB:
      CMP R6, #0x62                 // b
      BNE getColourY
      MOV R7, #.blue
      B getColourStore
getColourY:      
      CMP R6, #0x79                 // y
      BNE getColourP
      MOV R7, #.yellow
      B getColourStore
getColourP:
      CMP R6, #0x70                 // p
      BNE getColourC
      MOV R7, #.purple
      B getColourStore
getColourC:
      CMP R6, #0x63                 // c
      BNE getColourW
      MOV R7, #.cyan
      B getColourStore
getColourW:
      CMP R6, #0x77                 // w
      BNE getColourK
      MOV R7, #.white
      B getColourStore
getColourK:
      CMP R6, #0x6B                 // k
      BNE getColourO
      MOV R7, #.black
      B getColourStore
getColourO:
      MOV R7, #.burlywood           // no need to check last colour
getColourStore:
      STR R7, [R0 + R5]
      ADD R5, R5, R8
      ADD R4, R4, #1
      CMP R4, R3
      BLT getColourLoop
      POP {R3, R4, R5, R6, R7, R8}
      RET

// desc: get colour code for response
// params: R0 -> exact matches, R1 -> partial matches, R2 -> arr
// return: R2 -> arr of code
getResponseCode:
      PUSH {R3, R4, R5, R6}
      LDR R3, charSize
      MOV R4, #0                    // offset
      LDR R6, codeSize
getResponseCodeLoop1:
      CMP R0, #0
      BEQ getResponseCodeLoop2
      MOV R5, #0x6b
      STRB R5, [R2 + R4]          // fill with k
      ADD R4, R4, R3
      SUB R0, R0, #1
      B getResponseCodeLoop1
getResponseCodeLoop2:
      CMP R1, #0
      BEQ getResponseCodeLoop3
      MOV R5, #0x77
      STRB R5, [R2 + R4]          // fill with w
      ADD R4, R4, R3
      SUB R1, R1, #1
      B getResponseCodeLoop2
getResponseCodeLoop3:
      CMP R4, R6
      BEQ getResponseCodeReturn
      MOV R5, #0x6F
      STRB R5, [R2 + R4]          // fill with o
      ADD R4, R4, R3
      B getResponseCodeLoop3
getResponseCodeReturn:
      POP {R3, R4, R5, R6}
      RET

// desc: draw a 4-pixel line of colours at (x, y)
// params: R0 -> x, R1 -> y, R2 -> arr of colours
drawLine:
      PUSH {R3, R4, R5, R6, R7, R8, R9}
      LDR R3, wordSize
      MOV R4, #0                    // offset
      MOV R5, #.PixelScreen         // pixel
      LDR R7, codeSize
      MOV R8, #0                    // screen offset
      MOV R9, #0                    // index
drawLineMoveY:
      CMP R1, #0
      BEQ drawLineMoveX
      ADD R5, R5, #256               // move down by 1 row
      SUB R1, R1, #1
      B drawLineMoveY
drawLineMoveX:
      CMP R0, #0
      BEQ drawLineLoop
      ADD R5, R5, R3                // move right by 1 columns
      SUB R0, R0, #1
      B drawLineMoveX
drawLineLoop:
      LDR R6, [R2 + R4]
      STR R6, [R5 + R8]             // draw to screen

      ADD R8, R8, R3
      ADD R4, R4, R3
      ADD R9, R9, #1
      CMP R9, R7
      BLT drawLineLoop

      POP {R3, R4, R5, R6, R7, R8, R9}
      RET

// desc: draw a line for guess and a line for response
// params: R0 -> guess number, R1 -> query code, R2 -> response code
displayGuess:
      PUSH {R3}

      PUSH {R0, R1, R2, LR}
      MOV R0, #line
      BL getColour
      POP {R0, R1, R2, LR}

      PUSH {R0, R1, R2, LR}
      MOV R1, R0                    // y = guess
      MOV R0, #27                   // x = 27
      MOV R2, #line
      BL drawLine
      POP {R0, R1, R2, LR}

      PUSH {R0, R1, R2, LR}
      MOV R0, #line
      MOV R1, R2
      BL getColour
      POP {R0, R1, R2, LR}

      PUSH {R0, R1, R2, LR}
      MOV R1, R0                    // y = guess
      MOV R0, #33                   // x = 33
      MOV R2, #line
      BL drawLine
      POP {R0, R1, R2, LR}

      POP {R3}
      RET

codemaker: .BLOCK 128
codebreaker: .BLOCK 128
secretcode: .BLOCK 128
querycode: .BLOCK 128
responsecode: .BLOCK 4
askMakerName: .ASCIZ "Enter code maker name:\n"
askBreakerName: .ASCIZ "Enter code breaker name:\n"
askMaxQueries: .ASCIZ "Enter the maximum number of queries:\n"
printMaker: .ASCIZ "Codemaker is: "
printBreaker: .ASCIZ "Codebreaker is: "
printMaxQueries: .ASCIZ "Maximum number of guesses: "
askSecretCode: .ASCIZ ", please enter a 4-character secret code\n"
printGuessNumber: .ASCIZ ", this is guess number:"
askQueryCode: .ASCIZ "Please enter a 4-character code\n"
askCode: .ASCIZ "Enter a code:\n"
charSize: 1
codeSize: 4
allowedCharsSize: 6
allowedChars: .ASCIZ "rgbypc"
wordSize: 4
line: .WORD 0
      0
      0
      0
printPositionMatches: .ASCIZ "Position matches: "
printColourMatches: .ASCIZ ", Colour matches: "
printWin: .ASCIZ ", you WIN!\n"
printLose: .ASCIZ ", you LOSE!\n"
