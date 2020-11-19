       IDENTIFICATION DIVISION.
       PROGRAM-ID.    TOPACCTS.
       AUTHOR.        STUDENT.
      *
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUS-RECS ASSIGN TO CUSTRECS.
           SELECT PRT-DONE ASSIGN TO PRTDONE.

       DATA DIVISION.
       FILE SECTION.
       FD  PRT-DONE RECORD CONTAINS 25 CHARACTERS RECORDING MODE F.
       01  PRT-REC-DONE.
      *    05  PRT-DATE     PIC X(8)         VALUE SPACES.
      *    05  FILLER       PIC X(1)         VALUE SPACES.
      *    05  PRT-TIME     PIC X(4)         VALUE SPACES.
      *    05  FILLER       PIC X(2)         VALUE SPACES.
      *    05  PRT-COMMENT  PIC X(27)        VALUE SPACES.
      *    05  FILLER       PIC X(2)         VALUE SPACES.
           05  PRT-MY-NAME  PIC X(11)        VALUE SPACES.
           05  FILLER       PIC X(2)         VALUE SPACES.
           05  PRT-BAL      PIC Z,ZZZ,ZZZ.99 VALUE SPACES.
      *
       FD  CUS-RECS RECORD CONTAINS 80 CHARACTERS RECORDING MODE F.
       01  IN-REC.
           05  FIRST-NAME   PIC X(11).
           05  LAST-NAME    PIC X(22).
           05  START-DATE   PIC X(8).
           05               PIC X(3).
           05  END-DATE     PIC X(8).
           05               PIC X(9).
           05  BAL-CHAR     PIC X(12).
           05               PIC X(7).
      *
       
       WORKING-STORAGE SECTION.

       01  PGM-VARIABLES.
           05  PGM-COUNT    PIC 9(05).

       01  YYYYMMDD         PIC 9(8).

       01  INTEGER-FORM     PIC S9(9).

       01  REFMOD-TIME-ITEM PIC X(8).

       01  ACC-BAL          PIC 9(09)V99.

      ****************************************************************
      *                  PROCEDURE DIVISION                          *
      ****************************************************************
       PROCEDURE DIVISION.
      *
       A000-START.
      *    OPEN OUTPUT PRT-DONE.
      *    MOVE SPACES TO PRT-REC-DONE.
      *    MOVE "Matt Pettis" TO PRT-MY-NAME.
      *    WRITE PRT-REC-DONE.
      *    CLOSE PRT-DONE.
           OPEN OUTPUT PRT-DONE.
           OPEN INPUT CUS-RECS.

           READ CUS-RECS.

           MOVE SPACES TO PRT-REC-DONE.
      *    MOVE "Matt Pettis" TO PRT-MY-NAME.
           MOVE FIRST-NAME TO PRT-MY-NAME.
      *    MOVE 1234567.89 TO PRT-BAL.
      *    COMPUTE ACC-BAL = Function Numval-C(BAL-CHAR)
           COMPUTE ACC-BAL = Function Numval-C("1,234,567.89")
           MOVE ACC-BAL TO PRT-BAL.
      *    MOVE 123456789 TO PRT-BAL.

           WRITE PRT-REC-DONE.

           CLOSE PRT-DONE.
           CLOSE CUS-RECS.
           STOP RUN.
