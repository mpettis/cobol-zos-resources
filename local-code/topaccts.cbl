       IDENTIFICATION DIVISION.
       PROGRAM-ID.    TOPACCTS.
       AUTHOR.        STUDENT.
      *
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUS-RECS ASSIGN TO CUSTRECS.
           SELECT PRT-OUT ASSIGN TO PRTDONE.

       DATA DIVISION.
       FILE SECTION.
       FD  PRT-OUT RECORD CONTAINS 80 CHARACTERS RECORDING MODE F.
       01  PRT-REC-OUT.
           05  FIRST-NAME   PIC X(11)        VALUE SPACES.
           05               PIC X(1)         VALUE SPACES.
           05  LAST-NAME    PIC X(22)        VALUE SPACES.
           05               PIC X(1)         VALUE SPACES.
           05  PRT-BAL      PIC Z,ZZZ,ZZZ    VALUE SPACES.
           05               PIC X(36)        VALUE SPACES.
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

       01  FLAGS.
           05 LASTREC       PIC X VALUE SPACE.

       01 WS-CURRENT-DATE.
          05  WS-CURRENT-YEAR         PIC X(04).
          05  WS-CURRENT-MONTH        PIC X(02).
          05  WS-CURRENT-DAY          PIC X(02).

       01  HEADER-1.
           05 TITLE-1       PIC X(80) VALUE SPACE.

       01  HEADER-2.
           05 PREAMBLE-2  PIC X(27) VALUE "PREPARED FOR PAT STANARD ON".
           05             PIC X(1)  VALUE SPACES.
           05 MONTH-2     PIC Z9.
           05             PIC X(1) VALUE ".".
           05 DAY-2       PIC Z9.
           05             PIC X(1) VALUE ".".
           05 YEAR-2      PIC 9999.
           05             PIC X(40) VALUE SPACES.


      ****************************************************************
      *                  PROCEDURE DIVISION                          *
      ****************************************************************
       PROCEDURE DIVISION.
      *
       A000-START.
           OPEN OUTPUT PRT-OUT.
           OPEN INPUT CUS-RECS.

       A010-WRITE-HEADERS.
           MOVE SPACES TO PRT-REC-OUT.
           MOVE "REPORT OF TOP ACCOUNT BALANCE HOLDERS" TO TITLE-1.
           WRITE PRT-REC-OUT FROM HEADER-1.
           MOVE SPACES TO PRT-REC-OUT.
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-CURRENT-DATE.
           MOVE WS-CURRENT-YEAR  TO YEAR-2.
           MOVE WS-CURRENT-MONTH TO MONTH-2.
           MOVE WS-CURRENT-DAY   TO DAY-2.
           WRITE PRT-REC-OUT FROM HEADER-2.

       CLOSE-STOP.
           CLOSE PRT-OUT.
           CLOSE CUS-RECS.
           STOP RUN.
