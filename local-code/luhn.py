def luhn(card_number):
    def digits_of(n):
        return [int(d) for d in str(n)]
    digits = digits_of(card_number)
    odd_digits = digits[-1::-2]
    even_digits = digits[-2::-2]
    print("odd digits: ")
    print(odd_digits)
    print("\n")
    print("even digits: ")
    print(even_digits)
    checksum = 0
    checksum += sum(odd_digits)
    print("checksum odd digits:")
    print(checksum)
    for d in even_digits:
        checksum += sum(digits_of(d*2))
        print("checksum even sum:")
        print(checksum)
    print("checksum:")
    print(checksum)
    return (checksum % 10)


luhn("0000000001004993")
luhn("000000000100499")
luhn("000000000100496")

#A little code to test it out on a number
if (luhn("8830723086640477")):
    print("INVALID")
else:
    print("VALID")

if (luhn(8830723086640477)):
    print("INVALID")
else:
    print("VALID")

