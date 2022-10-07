main:
      MOV R4, #askMakerName   // read maker name
      STR R4, .WriteString
      MOV R4, #codemaker
      STR R4, .ReadString

      MOV R4, #askBreakerName   // read break name
      STR R4, .WriteString
      MOV R4, #codebreaker
      STR R4, .ReadString

      MOV R4, #askMaxQueries   // read max query
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
      HALT

newline:
      MOV R0, #0xA
      STRB R0, .WriteChar
      RET

codemaker: .BLOCK 128
codebreaker: .BLOCK 128
askMakerName: .ASCIZ "Enter code maker name:\n"
askBreakerName: .ASCIZ "Enter code breaker name:\n"
askMaxQueries: .ASCIZ "Enter the maximum number of queries:\n"
printMaker: .ASCIZ "Codemaker is: "
printBreaker: .ASCIZ "Codebreaker is: "
printMaxQueries: .ASCIZ "Maximum number of guesses: "
