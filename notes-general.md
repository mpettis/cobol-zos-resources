# Slack channels
- Cobol/Open Mainframe Project: https://app.slack.com/client/T1BAJVCTY/C011NE32Z1T
- Master the Mainframe: https://app.slack.com/client/TBZMCK0GG/CBZMCK8JU
 


# Resources
- cobol-programming-course github: https://github.com/openmainframeproject/cobol-programming-course



# Master the mainframe
- https://www.ibm.com/it-infrastructure/z/education/master-the-mainframe
    - matthew.pettis@gmail.com
    - 4!Th3luv
- Site: https://community.ibm.com/community/user/ibmz-and-linuxone/groups/community-home?communitykey=aae5965f-01ff-4609-927f-87d6d1134ac8&tab=groupdetails
- Part one of master the mainframe:
    - https://www.youtube.com/watch?v=0CKcSdaR5r8&feature=youtu.be&utm_campaign=IBM+MTM&utm_source=hs_email&utm_medium=email&utm_content=80654549&_hsenc=p2ANqtz--v8erFe3bApM2ID1s0feNxA5u2XWrQPw9KfXRy_dlhldvkE74fbelm1_Qaqe3K8zMrVwcKEwh-7C72d1LHscVHxe1bUA&_hsmi=80654549



# Credentials
- https://mtm.masterthemainframe.com/channels/11
- System requirements: https://code.visualstudio.com/docs/supporting/requirements
- ID: Z05336
- Password: glare110
- Password reset: https://mtm.influitive.com/challenges?challenge=105
- Challenge Instructions: https://mtm.influitive.com/forum/t/lets-get-connected-vsc1/60
    - VSCode instructions saved to: art/VSC.1_alt.pdf
- Challenge tutorial: https://mediacenter.ibm.com/media/VS+Code+for+Master+the+Mainframe/1_fvg90mg0
- Connection url: https://192.86.32.153:10443
- connection type zosmf



# python modules for mainframe
- https://www.ibm.com/support/knowledgecenter/SSKFYE_1.0.3/python_doc_zoautil/index.html?view=embed



# LinuxONE
- LNX1.redhat.pdf
- https://developer.ibm.com/components/ibm-linuxone/gettingstarted/
- https://github.com/linuxone-community-cloud/technical-resources/blob/master/faststart/deploy-virtual-server.md
    - https://developer.ibm.com/components/ibm-linuxone/gettingstarted/



# VSAM
- https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_169.htm
- https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.2.0/com.ibm.zos.v2r2.idai200/da6i2123.htm



# Commands from ZCLI1.pdf

```
zowe files create ps Z05336.ZOWEPS --rl 120 --block-size 9600
zowe files list ds Z05336.ZOWEPS -a

zowe  zos-files create data-set-vsam Z05336.VSAMDS -v VPWRKC
zowe files list ds Z05336.VSAMDS -a

zowe jobs submit lf "repro.txt"
zowe jobs submit lf "repro-print.txt"


zowe files create ps Z05336.OUTPUT.VSAMPRNT --rl 120 --block-size 9600
```

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


# REXX2.pdf
- https://www.ibm.com/support/knowledgecenter/SSLTBW_2.4.0/com.ibm.zos.v2r4.ikjc300/ikj2g2_Additional_Examples2.htm

Create files for REXX script
```
zowe files create ps Z05336.OUTPUT.CUSTOMER
zowe tso issue command "exec 'z05336.source(ccview)'" --ssm
zowe tso issue command "exec 'z05336.source(ccgen)'" --ssm
```


The script `ccview`:
```
/**************************** REXX *********************************/
/* This exec illustrates the use of "EXECIO 0 ..." to open, empty, */
/* or close a file. It reads records from file indd, allocated     */
/* to 'sams.input.dataset', and writes selected records to file    */
/* outdd, allocated to 'sams.output.dataset'. In this example, the */
/* data set 'smas.input.dataset' contains variable-length records  */
/* (RECFM = VB).                                                   */
/*******************************************************************/
"FREE FI(outdd)"
"FREE FI(indd)"
"ALLOC FI(indd) DA('MTM2020.PUBLIC.CUST16') SHR REUSE"
"ALLOC FI(outdd) DA('Z05336.OUTPUT.CUSTOMER') SHR REUSE"
eofflag = 2                 /* Return code to indicate end-of-file */
return_code = 0                /* Initialize return code           */
in_ctr = 0                     /* Initialize # of lines read       */
out_ctr = 0                    /* Initialize # of lines written    */

/*******************************************************************/
/* Open the indd file, but do not read any records yet.  All       */
/* records will be read and processed within the loop body.        */
/*******************************************************************/

"EXECIO 0 DISKR indd (OPEN"   /* Open indd                         */

/*******************************************************************/
/* Now read all lines from indd, starting at line 1, and copy      */
/* selected lines to outdd.                                        */
/*******************************************************************/

DO WHILE (return_code \= eofflag) /* Loop while not end-of-file   */
  'EXECIO 1 DISKR indd'           /* Read 1 line to the data stack */
  return_code = rc                /* Save execio rc                */
  IF return_code = 0 THEN         /* Get a line ok?                */
   DO                             /* Yes                           */
      in_ctr = in_ctr + 1         /* Increment input line ctr      */
      PARSE PULL line.1           /* Pull line just read from stack*/
      IF LENGTH(line.1) > 10 then /* If line longer than 10 chars  */
       DO
         "EXECIO 1 DISKW outdd (STEM line." /* Write it to outdd   */
         cc_digits = SUBSTR(line.1,3,19)
         /* call INSPECT */
         out_ctr = out_ctr + 1        /* Increment output line ctr */
       END
   END
END
"EXECIO 0 DISKR indd (FINIS"   /* Close the input file, indd   */
IF out_ctr > 0 THEN             /* Were any lines written to outdd?*/
  DO                               /* Yes.  So outdd is now open   */
     /****************************************************************/
   /* Since the outdd file is already open at this point, the      */
   /* following "EXECIO 0 DISKW ..." command will close the file,  */
   /* but will not empty it of the lines that have already been    */
   /* written. The data set allocated to outdd will contain out_ctr*/
   /* lines.                                                       */
   /****************************************************************/

  "EXECIO 0 DISKW outdd (FINIS" /* Closes the open file, outdd     */
  SAY 'File outdd now contains ' out_ctr' lines.'
END
ELSE                         /* Else no new lines have been        */
                             /* written to file outdd              */
  DO                         /* Erase any old records from the file*/

   /****************************************************************/
   /* Since the outdd file is still closed at this point, the      */
   /* following "EXECIO 0 DISKW " command will open the file,   */
   /* write 0 records, and then close it.  This will effectively   */
   /* empty the data set allocated to outdd.  Any old records that */
   /* were in this data set when this exec started will now be     */
   /* deleted.                                                     */
   /****************************************************************/

   "EXECIO 0 DISKW outdd (OPEN FINIS"  /*Empty the outdd file      */
   SAY 'File outdd is now empty.'
   END
"FREE FI(indd)"
"FREE FI(outdd)"
EXIT

INSPECT:
  say 'inspecting' cc_digits
RETURN
```


CCGEN
```
/* REXX */

"FREE FI(outdd)"
"ALLOC FI(outdd) DA('Z05336.OUTPUT(CUST16)') SHR REUSE"

valid_count = 0
i = 12345
do while valid_count < 500
    do
        say '----'  
        say i

        /* Odd digits */
        say 'odd digits'
        sum_odd = 0
        do idx=length(i) to 1 by -2
            digit = substr(i, idx, 1)
            say 'idx:' idx
            say 'digit:' digit
            sum_odd = sum_odd + digit
        end
        say 'sum odd:' sum_odd

        /* Even digits */
        say 'even digits'
        sum_even = 0
        do idx=(length(i) - 1) to 1 by -2
            digit = substr(i, idx, 1)
            say 'digit:' digit
            digit = 2 * digit
            say '2*digit' digit
            if digit > 9 then
            do
                digit = digit - 9
            end
            sum_even = sum_even + digit
        end
        say 'sum even:' sum_even

        checksum = sum_odd + sum_even
        checksum = checksum // 10

        if checksum = 0 then
        do
            cc_num_pad1 = right(i, 16, '0')
            say 'VALID:' cc_num_pad1    
            "EXECIO 1 DISKW outdd (STEM cc_num_pad"
            valid_count = valid_count + 1
        end

        i = i + 1
    end
end


"EXECIO 0 DISKW outdd (FINIS"
"FREE FI(outdd)"

EXIT
```

