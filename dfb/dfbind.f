      SUBROUTINE DFBIND (DBH,SZNDX)
      IMPLICIT NONE
C----------
C DFB $Id$
C----------
C
C  THIS ROUTINE ASSIGNS A SIZE CLASS BETWEEN ONE AND TEN
C  TO A TREE DIAMETER BETWEEN 1.0 INCHES AND 20.0 INCHES.
C  IF THE TREE'S DBH IS LESS THAN 1.0 INCHES, THE TREE IS
C  ASSIGNED TO SIZE CLASS ONE.  IF THE TREES DBH IS GREATER
C  THAN 20.0 INCHES, THEN THE TREE IS ASSIGNED TO SIZE CLASS
C  TEN.
C
C  CALLED BY :
C     DFBDBH  [DFB]
C     DFBMRT  [DFB]
C     DFBTAB  [DFB]
C
C  CALLS :
C     NONE
C
C  PARAMETERS:
C     DBH    - DBH OF TREE (INPUT).
C     SZNDX  - SIZE CLASS (OUTPUT).
C
C  LOCAL VARIABLES :
C     IVAL   - INTEGER VALUE OF DBH.
C

      INTEGER SZNDX, IVAL
      REAL    DBH

C
C     CALCULATE THE INDEX.
C
      IVAL = IFIX(DBH)
      SZNDX = IVAL / 2 + MOD(IVAL,2)

C
C     TAKE INTO ACCOUNT EXTREME VALUES LESS THAN 1 OR
C     GREATER THAN 20 INCHES.
C
      IF (SZNDX .GT. 20) SZNDX = 20
      IF (SZNDX .LT. 1) SZNDX = 1

      RETURN
      END
