codemaker = ''
codebreaker = ''
R10 = 0
secret_code = []
query_code = []

def get_code(arr):
    print("Enter a code:\n")
    read_string(arr)
    count = 0
    for char in arr:
        if char == '\0': break

        count += 1
        if count == 5:
            get_code()

        for allowed_char in allowed_chars:
            if char == allowed_char:
                goto allowed

        get_code(arr)
        allowed:

def compare_code(secret, query):
    R0 = 0
    R1 = 0
    for i = 0, i < 4, i++:
        if query[i] = secret[i]:
            R0 += 1
        else:
            for j = 0, j < 4, j++:
                if query[i] = secret[i]:
                    R1 += 1

if __name__ == "__main__":
    codemaker = read_string()
    codebreaker = read_string()
    R0 = read_int()

    print("Codebreaker is ")
    print(codebreaker + '\n')
    print("Codemaker is ")
    print(codemaker + '\n')
    print("Maximum number of guesses: ")
    print(R0 + '\n')

    print(codemaker)
    print(", please enter a 4-character secret code\n")
    get_code(secret_code)

    for i = 1, i <= R10, i++:
        print(codebreaker)
        print(", this is guess number:")
        print(i + '\n')
        print("Please enter a 4-character code\n")
        get_code(query_code)

        compare_code(secret, query)
        print("Position matches: ")
        print(R0)
        print(", Colour matches: ")
        print(R1 + '\n')

        if R0 == 4:
            print(codebreaker)
            print(", you WIN!\n")
    
    print(codebreaker)
    print(", you LOSE!\n")