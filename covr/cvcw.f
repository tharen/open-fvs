      SUBROUTINE CVCW (LTHIN)
      IMPLICIT NONE
C----------
C COVR $Id$
C----------
C  COMPUTES CROWN WIDTH FOR INDIVIDUAL TREES.
C  ALSO COMPUTES SUM OF CROWN AREAS, CRAREA.
C
C  CROWN WIDTH RELATIONSHIPS ARE DOCUMENTED IN :
C  MOEUR,MELINDA. 1981. CROWN WIDTH AND FOLIAGE WEIGHT OF NORTHERN
C      ROCKY MOUNTAIN CONIFERS.  USDA FOR. SERV. RES. PAP. INT- 283.
C----------
C  VARIABLE DEFINITIONS
C----------
C  BH1(MAXSP)-- ARRAY OF COEFFICIENTS FOR HEIGHT TERM FOR CROWN
C             WIDTH FUNCTION FOR TREES LESS THAN 3.5 INCHES DBH
C  BINT2(MAXSP)- ARRAY OF INTERCEPTS FOR CROWN WIDTH FUNCTION
C             FOR TREES 3.5 INCHES AND LARGER
C  BH2(MAXSP)-- ARRAY OF COEFFICIENTS FOR HEIGHT TERM FOR TREES
C             .GE. 3.5 INCHES
C  BAREA   -- STAND BASAL AREA
C  CL      -- CROWN LENGTH
C  D       -- TREE DBH
C  H       -- TREE HEIGHT
C  TRECW(MAXTRE) PREDICTED CROWN WIDTH IN FEET
C  CRAREA -- SUM OF ALL CROWN PROJECTION AREAS (PI/4*TRECW*TRECW)
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CVCOM.F77'
C
COMMONS
      LOGICAL LTHIN,DEBUG
      INTEGER I,ISPI,IICR
      REAL D,H,P
      LOGICAL LDANUW
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      LDANUW = LTHIN
C----------
C  CHECK FOR DEBUG.
C----------
      CALL DBCHK(DEBUG,'CVCW',4,ICYC)
      IF (DEBUG) WRITE (JOSTND,9000) ICYC
 9000 FORMAT (/'**CALLING CVCW, CYCLE = ',I2 / '        I      ISPI',
     & '         D         H        CL     BAREA     TRECW    CRAREA')
C----------
C  RETURN IF NOTREES OPTION IN EFFECT.
C----------
      IF (ITRN .GT. 0) GO TO 5
      IF (DEBUG) WRITE (JOSTND,9001) ITRN
 9001 FORMAT ('ITRN =', I5,' : NOTREES : RETURN TO **CVCNOP**')
      RETURN
    5 CONTINUE
C----------
C  ENTER TREE LOOP
C----------
      CRAREA = 0.0
C
      DO 100 I = 1,ITRN
      D = DBH(I)
      H = HT(I)
      ISPI = ISP(I)
      IICR = ICR(I)
      P = PROB(I)
      TRECW(I) = CRWDTH(I)
C----------
C  COMPUTE SUM OF CROWN PROJECTION AREAS.
C----------
      CRAREA = CRAREA + TRECW(I)*TRECW(I)*P
      IF (DEBUG) WRITE (JOSTND,9002) I,ISPI,D,H,IICR,
     &                TRECW(I),CRAREA
 9002 FORMAT (2I10,2F10.1,I10,2F10.1)
C
  100 CONTINUE
C----------
C  COMPUTE TOTAL CROWN AREA.
C  CONSTANT = PI*TRECW/2*TRECW/2 = .785398
C----------
      CRAREA = CRAREA*0.785398
      RETURN
      END
