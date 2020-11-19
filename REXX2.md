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

