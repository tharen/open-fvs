      SUBROUTINE HTGF
      IMPLICIT NONE
C----------
C OP $Id: htgf.f $
C----------
C  THIS SUBROUTINE COMPUTES THE PREDICTED PERIODIC HEIGHT
C  INCREMENT FOR EACH CYCLE AND LOADS IT INTO THE ARRAY HTG.
C  HEIGHT INCREMENT IS PREDICTED FROM SPECIES, HABITAT TYPE,
C  HEIGHT, DBH, AND PREDICTED DBH INCREMENT.  THIS ROUTINE
C  IS CALLED FROM **TREGRO** DURING REGULAR CYCLING.  ENTRY
C  **HTCONS** IS CALLED FROM **RCON** TO LOAD SITE DEPENDENT
C  CONSTANTS THAT NEED ONLY BE RESOLVED ONCE. CALLS **FINDAG
c  TO CALCULATE TREE AGE.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'MULTCM.F77'
C
C
      INCLUDE 'HTCAL.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
      INCLUDE 'ORGANON.F77'
C
C
COMMONS
C----------
      LOGICAL DEBUG
      INTEGER MAPHD(MAXSP)
      INTEGER ITFN,I3,I2,I1,ISPC,I,MAPPHD
      REAL SITAGE,SITHT,AGMAX,HTMAX,HTMAX2,D2,BARK,BRATIO
      REAL RHR(MAXSP),RHYXS(MAXSP),RHM(MAXSP),RHB(MAXSP)
      REAL TEMHTG,HTGMOD,WTRH,WTCR,HGMDRH,FCTRM,FCTRXB,FCTRRB,FCTRKX,RHX
      REAL HGMDCR,RELHT,POTHTG,TEMPD,TEMPH,H,D,XHT,SINDX
      REAL CRC,CRB,CRA,RHXS,RHK,AGP10,HGUESS,HGUESS1,HGUESS2,SCALE
      REAL MAXGUESS
      REAL MISHGF
C----------
C  COEFFICIENTS--CROWN RATIO (CR) BASED HT. GRTH. MODIFIER
C----------
      DATA CRA /100.0/, CRB /3.0/, CRC /-5.0/
C----------
C  COEFFICIENTS--RELATIVE HEIGHT (RH) BASED HT. GRTH. MODIFIER
C----------
      DATA RHK /1.0/, RHXS /0.0/
C----------
C  COEFFS BASED ON SPECIES SHADE TOLERANCE AS FOLLOWS:
C                                   RHR  RHYXS    RHM    RHB
C        VERY TOLERANT             20.0   0.20    1.1  -1.10
C        TOLERANT                  16.0   0.15    1.1  -1.20
C        INTERMEDIATE              15.0   0.10    1.1  -1.45
C        INTOLERANT                13.0   0.05    1.1  -1.60
C        VERY INTOLERANT           12.0   0.01    1.1  -1.60
C  IN THE WC VARIANT, SILVICS OF NORTH AMERICA (AG.HNDBK-654)
C  WAS USED TO GET SHADE TOLERANCE. SHADE TOLERANCE COEFFICIENTS WERE
C  DEVEOLPED BY D.DONNELY, TO COMPUTE HGMDRH (RELAT. HT. CONTRIBUTION)
C  SEQ. NO.   CHAR. CODE    SHADE TOL.   SEQ. NO.  CHAR. CODE    SHADE TOL.
C      1      SF            TOLN            21     BM            VTOL
C      2      WF            TOLN            22     RA            INTL
C      3      GF            TOLN            23     MA            INTL
C      4      AF            VTOL            24     TO            INTM
C      5      RF            TOLN            25     GC            INTM
C      6      SS            TOLN            26     AS            VINT
C      7      NF            INTM            27     CW            VINT
C      8      YC            TOLN            28     WO            INTM
C      9      IC            VTOL            29     J             INTL
C      10     ES            TOLN            30     LL            VINT
C      11     LP            VINT            31     WB            INTM
C      12     JP            INTL            32     KP            VINT
C      13     SP            INTM            33     PY            VTOL
C      14     WP            INTM            34     DG            VTOL
C      15     PP            INTL            35     HT            VINT
C      16     DF            INTM            36     CH            INTL
C      17     RW            VTOL            37     WI            VINT
C      18     RC            VTOL            38
C      19     WH            VTOL            39     OT            INTM
C      20     MH            VTOL
C----------
      DATA RHR    / 16.0,  16.0,  16.0,  20.0,  16.0,
     &              16.0,  15.0,  16.0,  20.0,  16.0,
     &              12.0,  13.0,  15.0,  15.0,  13.0,
     &              15.0,  20.0,  20.0,  20.0,  20.0,
     &              20.0,  13.0,  13.0,  15.0,  15.0,
     &              12.0,  12.0,  15.0,  13.0,  12.0,
     &              15.0,  12.0,  20.0,  20.0,  12.0,
     &              13.0,  12.0,  15.0,  15.0/
      DATA RHYXS /  0.15,  0.15,  0.15,  0.20,  0.15,
     &              0.15,  0.10,  0.15,  0.20,  0.15,
     &              0.01,  0.05,  0.10,  0.15,  0.05,
     &              0.10,  0.20,  0.20,  0.20,  0.20,
     &              0.20,  0.05,  0.05,  0.10,  0.10,
     &              0.01,  0.01,  0.10,  0.05,  0.01,
     &              0.10,  0.01,  0.20,  0.20,  0.01,
     &              0.05,  0.01,  0.10,  0.10/
      DATA RHM   /  MAXSP*1.10/
      DATA RHB   / -1.20, -1.20, -1.20, -1.10, -1.20,
     &             -1.20, -1.45, -1.20, -1.10, -1.20,
     &             -1.60, -1.60, -1.45, -1.45, -1.60,
     &             -1.45, -1.10, -1.10, -1.10, -1.10,
     &             -1.10, -1.60, -1.60, -1.45, -1.45,
     &             -1.60, -1.60, -1.45, -1.60, -1.60,
     &              0.10, -1.60, -1.10, -1.10, -1.60,
     &             -1.60, -1.60, -1.45, -1.45/
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'HTGF',4,ICYC)
      IF(DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE HTGF CYCLE =',I5)
C
      IF(DEBUG)WRITE(JOSTND,*) 'IN HTGF AT BEGINNING,HTCON=',
     *HTCON,'RMAI=',RMAI,'ELEV=',ELEV
      SCALE=FINT/YR
C----------
C  GET THE HEIGHT GROWTH MULTIPLIERS.
C----------
      CALL MULTS (2,IY(ICYC),XHMULT)
      IF(DEBUG)WRITE(JOSTND,*)'HTGF- IY(ICYC),XHMULT= ',
     & IY(ICYC), XHMULT
C----------
C   BEGIN SPECIES LOOP:
C----------
      DO 40 ISPC=1,MAXSP
      I1 = ISCT(ISPC,1)
      IF (I1 .EQ. 0) GO TO 40
      I2 = ISCT(ISPC,2)
      SINDX = SITEAR(ISPC)
      XHT=XHMULT(ISPC)
C-----------
C   BEGIN TREE LOOP WITHIN SPECIES LOOP
C
C   XHT CONTAINS THE HEIGHT GROWTH MULTIPLIER FROM THE HTGMULT KEYWORD
C   HTCON CONTAINS THE HEIGHT GROWTH MULTIPLIER FROM THE READCORH KEYWORD
C-----------
      DO 30 I3 = I1,I2
      I=IND1(I3)
      HTG(I)=0.
C----------
C  START ORGANON
C
      IF(LORGANON .AND. (IORG(I) .EQ. 1)) THEN
        HTG(I)=SCALE*XHT*HGRO(I)*EXP(HTCON(ISPC))
        IF(DEBUG)WRITE(JOSTND,*)' HTGF ORGANON I,ISP,DBH,HT,HTG,HGRO,',
     &  'SCALE,XHT,HTCON,IORG= ',I,ISP(I),DBH(I),HT(I),HTG(I),HGRO(I),
     &  SCALE,XHT,HTCON(ISPC),IORG(I)
        GO TO 161
      ENDIF
C
C  END ORGANON
C----------
      H=HT(I)
      D=DBH(I)
C
      SITAGE = 0.0
      SITHT = 0.0
      AGMAX = 0.0
      HTMAX = 0.0
      HTMAX2 = 0.0
      BARK=BRATIO(ISPC,D,H)
      D2 = D + DG(I)/BARK
      IF (PROB(I).LE.0.0) GO TO 161
      IF(DEBUG)WRITE(JOSTND,*)' IN HTGF, CALLING FINDAG I= ',I
      CALL FINDAG(I,ISPC,D,D2,H,SITAGE,SITHT,AGMAX,HTMAX,HTMAX2,DEBUG)
C
C----------
C  CHECK TO SEE IF TREE HT/DBH RATIO IS ABOVE THE MAXIMUM RATIO AT
C  THE BEGINNING OF THE CYCLE. THIS COULD HAPPEN FOR TREES COMING
C  OUT OF THE ESTAB MODEL.  IF IT IS, THEN CHECK TO SEE IF THE
C  HT/NEWDBH RATIO IS ABOVE THE MAXIMUM.  IF THIS IS ALSO TRUE, LIMIT
C  HTG TO 0.1 FOOT OR HALF THE DG, WHICH EVER IS GREATER.
C  IF IT ISN'T, THEN LET HTG BE COMPUTED THE NORMAL
C  WAY AND THEN CHECK IT AGAIN AT THAT POINT.
C----------
      TEMPH=H + HTG(I)
      IF(H .GT.HTMAX) THEN
         IF(H .GE. HTMAX2) THEN
           HTG(I)=0.5 * DG(I)
           IF(HTG(I).LT.0.1)HTG(I)=0.1
           HTG(I)=SCALE*XHT*HTG(I)*EXP(HTCON(ISPC))
           IF(DEBUG)WRITE(JOSTND,*)' I,ISPC,H,HTMAX2,HTG,SCALE,XHT,',
     &     'HTCON= ',I,ISPC,H,HTMAX2,HTG(I),SCALE,XHT,HTCON(ISPC)
         ENDIF
         GO TO 161
      END IF
C
C----------
C  NORMAL HEIGHT INCREMENT CALCULATON BASED ON TREE AGE
C  FIRST CHECK FOR MAXIMUM TREE AGE
C----------
      IF (SITAGE .GE. AGMAX) THEN
        POTHTG= 0.10
        IF(ISPC.EQ.2 .OR. ISPC.EQ.3)THEN
          POTHTG=(0.2+0.00264*SINDX)*5.
        ENDIF
        GO TO 1320
      ELSE
        AGP10= SITAGE + 5.0
      ENDIF
C----------
C  CALL HTCALC FOR NORMAL CYCLING
C----------
      IF(DEBUG)WRITE(JOSTND,*)' ISPC,I,HGUESS,AGP10= ',
     &ISPC,I,HGUESS,AGP10
C
      HGUESS = 0.0
      CALL HTCALC(SINDX,ISPC,AGP10,HGUESS,JOSTND,DEBUG) 
      POTHTG= HGUESS-SITHT
C----------
C  PATCH FOR OREGON WHITE OAK - WORK BY GOULD AND HARRINGTON, PNW
C  USES A HT-DBH EQUATION MODIFIED BY SI AND BA, FIRST PREDICTS
C  HEIGHT GUESS BASED ON PREVIOUS DIAMETER AND THEN PREDICT THE
C  HEIGHT GUESS BASED ON PRESENT DIAMETER, SUBTRACT GUESSES
C  TO CALCULATE HEIGHT GROWTH.
C----------
      IF (ISPC .EQ. 28) THEN
C----------
C  CALCULATE MAX HEIGHT BASED ON SI, THEN MODIFY BASED ON BA
C----------
        MAXGUESS = SINDX - 18.6024/ALOG(2.7 + BA)
C----------
C  DUB HEIGHT BASED ON PRESENT DBH
C----------
        D2 = DBH(I) + DG(I)
        IF (D2 .LT. 0.) D2 = 0.1
        HGUESS2 = 4.5 + MAXGUESS*(1-EXP(-0.137428*D2))**1.38994
C----------
C  DUB HEIGHT BASED ON PAST DBH
C----------
        HGUESS1 = 4.5 + MAXGUESS*(1-EXP(-0.137428*D))**1.38994
C----------
C  DIFFERENCE OF TWO DUBBED HEIGHTS IS POTENTIAL HEIGHT GROWTH
C
C  SINCE DG IS ON A 10-YEAR BASIS HERE, POTHTG IS A 10-YEAR ESTIMATE.
C  DIVIDE IT BY 2 TO GET IT ON A 5-YEAR BASIS. IT WILL BE SCALED TO
C  THE CYCLE LENGTH BELOW
C----------
        POTHTG = (HGUESS2 - HGUESS1) / 2.0
C      IF(DEBUG)WRITE(JOSTND,*)'ISPC,I,H,PHTG,HGS1,HGS2,MX,D,D2,BA,DG',
C     &ISPC,I,H,POTHTG,HGUESS1,HGUESS2,MAXGUESS,D,D2,BA,DG(I)
      ENDIF
C--End OWO PATCH
C----------
C  HEIGHT GROWTH MUST BE POSITIVE
C----------
      IF(POTHTG .LT. 0.1)POTHTG= 0.1
C---------
C ASSIGN A POTENTIAL HTG FOR THE ASYMPTOTIC AGE
C---------
 1320 CONTINUE
C----------
C  HEIGHT GROWTH MODIFIERS
C----------
      RELHT = 0.0
      IF(AVH .GT. 0.0) RELHT=HT(I)/AVH
      IF(RELHT .GT. 1.5)RELHT=1.5
C-----------
C     REVISED HEIGHT GROWTH MODIFIER APPROACH.
C-----------
C     CROWN RATIO CONTRIBUTION.  DATA AND READINGS INDICATE HEIGHT
C     GROWTH PEAKS IN MID-RANGE OF CR, DECREASES SOMEWHAT FOR LARGE
C     CROWN RATIOS DUE TO PHOTOSYNTHETIC ENERGY PUT INTO CROWN SUPPORT
C     RATHER THAN HT. GROWTH.  CROWN RATIO FOR THIS COMPUTATION NEEDS
C     TO BE IN (0-1) RANGE; DIVIDE BY 100.  FUNCTION IS HOERL'S
C     SPECIAL FUNCTION (REF. P.23, CUTHBERT&WOOD, FITTING EQNS. TO DATA
C     WILEY, 1971).  FUNCTION OUTPUT CONSTRAINED TO BE 1.0 OR LESS.
C-----------
      HGMDCR = (CRA * (ICR(I)/100.0)**CRB) * EXP(CRC*(ICR(I)/100.0))
      IF (HGMDCR .GT. 1.0) HGMDCR = 1.0
C-----------
C     RELATIVE HEIGHT CONTRIBUTION.  DATA AND READINGS INDICATE HEIGHT
C     GROWTH IS ENHANCED BY STRONG TOP LIGHT AND HINDERED BY HIGH
C     SHADE EVEN IF SOME LIGHT FILTERS THROUGH.  ALSO RESPONSE IS
C     GREATER FOR GIVEN LIGHT AS SHADE TOLERANCE INCREASES.  FUNCTION
C     IS GENERALIZED CHAPMAN-RICHARDS (REF. P.2 DONNELLY ET AL. 1992.
C     THINNING EVEN-AGED FOREST STANDS...OPTIMAL CONTROL ANALYSES.
C     USDA FOR. SERV. RES. PAPER RM-307).
C     PARTS OF THE GENERALIZED CHAPMAN-RICHARDS FUNCTION USED TO
C     COMPUTE HGMDRH BELOW ARE SEGMENTED INTO FACTORS
C     FOR PROGRAMMING CONVENIENCE.
C-----------
      RHX = RELHT
      FCTRKX = ( (RHK/RHYXS(ISPC))**(RHM(ISPC)-1.0) ) - 1.0
      FCTRRB = -1.0*( RHR(ISPC)/(1.0-RHB(ISPC)) )
      FCTRXB = RHX**(1.0-RHB(ISPC)) - RHXS**(1.0-RHB(ISPC))
      FCTRM  = -1.0/(RHM(ISPC)-1.0)
      IF (DEBUG)
     &WRITE(JOSTND,*) ' HTGF-HGMDRH FACTORS = ',
     &ISPC, RHX, FCTRKX, FCTRRB, FCTRXB, FCTRM
      HGMDRH = RHK * ( 1.0 + FCTRKX*EXP(FCTRRB*FCTRXB) ) ** FCTRM
C-----------
C     APPLY WEIGHTED MODIFIER VALUES.
C-----------
      WTCR = .25
      WTRH = 1.0 - WTCR
      HTGMOD = WTCR*HGMDCR + WTRH*HGMDRH
C----------
C    MULTIPLIED BY SCALE TO CHANGE FROM A YR. PERIOD TO FINT AND
C    MULTIPLIED BY XHT TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C----------
C
      IF(DEBUG) THEN
        WRITE(JOSTND,*)' IN HTGF, I= ',I,' ISPC= ',ISPC,'HTGMOD= ',
     &  HTGMOD,' ICR= ',ICR(I),' HGMDCR= ',HGMDCR
        WRITE(JOSTND,*)' HT(I)= ',HT(I),' AVH= ',AVH,' RELHT= ',RELHT,
     & ' HGMDRH= ',HGMDRH
      ENDIF
C
      IF (HTGMOD .GE. 2.0) HTGMOD= 2.0
      IF (HTGMOD .LE. 0.0) HTGMOD= 0.1

C     XMOD=1.0
C      CRATIO=ICR(I)/100.0
C      RELHT=H/AVH
C      IF(RELHT .GT. 1.0)RELHT=1.0
C      IF(PCCF(ITRE(I)) .LT. 100.0)RELHT=1.0
C      XMOD = 1.117148 * (1.0-EXP(-4.26558 * CRATIO))
C     &        *(EXP(2.54119 * (RELHT**0.250537 -1.0)))
 1322  HTG(I) = POTHTG * HTGMOD
C
      IF(DEBUG)WRITE(JOSTND,901)ICR(I),PCT(I),BA,DG(I),HT(I),
     & POTHTG,AVH,HTG(I),PCCF(ITRE(I)),ABIRTH(I),HGUESS,HTGMOD
  901 FORMAT(' HTGF',I5,13F9.2)
C-----------
C  HEIGHT GROWTH GETS EVALUATED FOR EACH TREE EACH CYCLE. HTG GETS
C  MULTIPLIED BY SCALE TO CHANGE FROM A YR  PERIOD TO FINT AND
C  MULTIPLIED BY XHT AND HTCON TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C----------
      TEMPH=H + HTG(I)
      IF(TEMPH .GT. HTMAX2) HTG(I)=HTMAX2-H
      IF(HTG(I) .LT. 0.1) HTG(I)=0.1
      HTG(I)=SCALE*XHT*HTG(I)*EXP(HTCON(ISPC))
      IF(DEBUG)WRITE(JOSTND,*)' I,ISPC,TEMPH,TEMPD,DBH,DG,H,HTG,MAP,',
     &'HTMAX2,SCALE,XHT,HTCON= ',I,ISPC,TEMPH,TEMPD,DBH(I),DG(I),H,
     &HTG(I),MAPPHD,HTMAX2,SCALE,XHT,HTCON(ISPC) 
C
  161 CONTINUE
C----------
C    APPLY DWARF MISTLETOE HEIGHT GROWTH IMPACT HERE,
C    INSTEAD OF AT EACH FUNCTION IF SPECIAL CASES EXIST.
C----------
      HTG(I)=HTG(I)*MISHGF(I,ISPC)
      TEMHTG=HTG(I)
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(I)+HTG(I)).GT.SIZCAP(ISPC,4))THEN
        HTG(I)=SIZCAP(ISPC,4)-HT(I)
        IF(HTG(I) .LT. 0.1) HTG(I)=0.1
      ENDIF
C
      IF(.NOT.LTRIP) GO TO 30
      ITFN=ITRN+2*I-1
      HTG(ITFN)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN)+HTG(ITFN)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN)=SIZCAP(ISPC,4)-HT(ITFN)
        IF(HTG(ITFN) .LT. 0.1) HTG(ITFN)=0.1
      ENDIF
C
      HTG(ITFN+1)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN+1)+HTG(ITFN+1)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN+1)=SIZCAP(ISPC,4)-HT(ITFN+1)
        IF(HTG(ITFN+1) .LT. 0.1) HTG(ITFN+1)=0.1
      ENDIF
C
      IF(DEBUG) WRITE(JOSTND,9001) HTG(ITFN),HTG(ITFN+1)
 9001 FORMAT( ' UPPER HTG =',F8.4,' LOWER HTG =',F8.4)
C----------
C   END OF TREE LOOP
C----------
   30 CONTINUE
C----------
C   END OF SPECIES LOOP
C----------
   40 CONTINUE
C
      IF(DEBUG)WRITE(JOSTND,60)ICYC
   60 FORMAT(' LEAVING SUBROUTINE HTGF   CYCLE =',I5)
      RETURN
C
      ENTRY HTCONS
C----------
C  ENTRY POINT FOR LOADING HEIGHT INCREMENT MODEL COEFFICIENTS THAT
C  ARE SITE DEPENDENT AND REQUIRE ONE-TIME RESOLUTION.  HGHC
C  CONTAINS HABITAT TYPE INTERCEPTS, HGLDD CONTAINS HABITAT
C  DEPENDENT COEFFICIENTS FOR THE DIAMETER INCREMENT TERM, HGH2
C  CONTAINS HABITAT DEPENDENT COEFFICIENTS FOR THE HEIGHT-SQUARED
C  TERM, AND HGHC CONTAINS SPECIES DEPENDENT INTERCEPTS.  HABITAT
C  TYPE IS INDEXED BY ITYPE (SEE /PLOT/ COMMON AREA).
C----------
C  LOAD OVERALL INTERCEPT FOR EACH SPECIES.
C----------
      DO 50 ISPC=1,MAXSP
      HTCON(ISPC)=0.0
      IF(LHCOR2 .AND. HCOR2(ISPC).GT.0.0) HTCON(ISPC)=
     &    HTCON(ISPC)+ALOG(HCOR2(ISPC))
   50 CONTINUE
C
      RETURN
      END
