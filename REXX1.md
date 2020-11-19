# REXX1.pdf
```
zowe tso issue command "exec 'z05336.source(somerexx)'" --ssm

zowe tso start as
zowe tso stop address-space Z05336-295-aaewaaaq

zowe tso send as Z05336-295-aaewaaaq --data "exec 'z05336.source(guessnum)'"
zowe tso send as Z05336-295-aaewaaaq --data "x"
zowe tso send as Z05336-295-aaewaaaq --data "-1"
zowe tso send as Z05336-295-aaewaaaq --data "11"
zowe tso send as Z05336-295-aaewaaaq --data "0.1"
zowe tso send as Z05336-295-aaewaaaq --data "1"

zowe tso send as Z05336-295-aaewaaaq --data "exec 'z05336.source(somerexx)'"
```

- On address spaces
    - https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_82.htm
- IBM TSO REXX References
    - https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ikja300/datatyp.htm

guessnum rexx program:
```
/* REXX */
say "I'm thinking of a number between 1 and 10."
secret = RANDOM(1,10)
tries = 1

do while (guess \= secret)
    say "What is your guess?"
    pull guess

    select
       when (datatype(guess) = 'CHAR') then
          do
              say "Guess is a char, not a number. Try again"
              tries = tries + 1
          end
       when (datatype(guess, 'W') = 0) then
          do
              say "Guess is not an integer. Try again"
              tries = tries + 1
          end
       when (guess < 0) then
          do
              say "Guess is < 0. Try again"
              tries = tries + 1
          end
       when (guess > 10) then
          do
              say "Guess is > 10. Try again"
              tries = tries + 1
          end
       when (guess \= secret) then
          do
              say "That's not it. Try again"
              tries = tries + 1
          end
       otherwise
          say ""
    end
end
say "You got it! And it only took you" tries "tries!"
exit
```


