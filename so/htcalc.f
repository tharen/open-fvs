      SUBROUTINE HTCALC(JFOR,SINDX,ISPC,AG,HGUESS,JOSTND,DEBUG)
      IMPLICIT NONE
C----------
C SO $Id$
C----------
C THIS ROUTINE CALCULATES A POTENTIAL HT GIVEN AN SPECIES SITE AND AGE
C IT IS USED TO CAL POTHTG AND SITE
C----------
      LOGICAL DEBUG
      INTEGER ISPC,JOSTND,INDX,JFOR
      REAL HGUESS,AG
      REAL SINDX,X1,X2,X3,TERM,B,TERM2,B50,Z
      REAL DUNL1(6),DUNL2(6),DUNL3(6)
C----------
C  SPECIES ORDER:
C  1=WP,  2=SP,  3=DF,  4=WF,  5=MH,  6=IC,  7=LP,  8=ES,  9=SH,  10=PP,
C 11=WJ, 12=GF, 13=AF, 14=SF, 15=NF, 16=WB, 17=WL, 18=RC, 19=WH,  20=PY,
C 21=WA, 22=RA, 23=BM, 24=AS, 25=CW, 26=CH, 27=WO, 28=WI, 29=GC,  30=MC,
C 31=MB, 32=OS, 33=OH
C----------
C  DATA STATEMENTS:
C----------
      DATA DUNL1/ -88.9, -82.2, -78.3, -82.1, -56.0, -33.8 /
      DATA DUNL2/ 49.7067, 44.1147, 39.1441,
     &            35.4160, 26.7173, 18.6400 /
      DATA DUNL3/ 2.375, 2.025, 1.650, 1.225, 1.075, 0.875 /
C----------
      IF(DEBUG)WRITE(JOSTND,*)' IN HTCALC JFOR,ISPC,SINDX,AG= ',
     &JFOR,ISPC,SINDX,AG
C
      SELECT CASE(ISPC)
C
C-------
C WHITE PINE USE BRICKELL EQUATIONS
C SPECIES: WP
C-------
      CASE(1)
        HGUESS= SINDX/(0.37504453*(1.0-0.92503*EXP(-0.0207959*AG))**
     &          (-2.4881068))
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WP HGUESS= ',HGUESS
C------
C DOUGLAS FIR USE COCHRAN PNW 251. THIS EQUATION ALSO USED FOR 
C OTHER SOFTWOODS
C SPECIES: DF, OS
C------
      CASE(3,32)
        HGUESS= 4.5 + EXP(-0.37496 + 1.36164*ALOG(AG) 
     &          - 0.00243434*(ALOG(AG))**4)
     &          - 79.97*(-0.2828 + 1.87947*(1.0 - EXP(-0.022399*AG))
     &          **0.966998) + (SINDX - 4.5)*(-0.2828 + 1.87947*(1.0 - 
     &          EXP(-0.022399*AG)**0.966998))
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC DF/OS HGUESS= ',HGUESS
C------
C WHITE FIR USE COCHRAN PNW 252. THIS EQUATION IS ALSO USED IN FOR
C INCENSE CEDAR, GRAND FIR, AND PACIFIC SILVER FIR
C SPECIES: WF, IC, GF, SF
C------
      CASE(4,6,12,14)
        X2= -0.30935 + 1.2383*ALOG(AG) + 0.001762*(ALOG(AG))**4
     &      - 5.4E-6*(ALOG(AG))**9 + 2.046E-7*(ALOG(AG))**11
     &      - 4.04E-13*(ALOG(AG))**18
        X3= -6.2056 + 2.097*ALOG(AG) - 0.09411*(ALOG(AG))**2
     &      - 0.00004382*(ALOG(AG))**7 + 2.007E-11*(ALOG(AG))**16
     &      - 2.054E-17*(ALOG(AG))**24
        HGUESS=EXP(X2) - 84.73*EXP(X3) + (SINDX - 4.5)*EXP(X3)
     &       + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WF/IC/GF/SF X2,X3,HGUESS= ',
     &  X2,X3,HGUESS
C------
C MTN HEMLOCK USE INTERIM MEANS PUB
C SPECIES: MH
C------
      CASE(5)
        HGUESS = (22.8741 + 0.950234*SINDX)*(1.0 - EXP(-0.00206465*
     &           SQRT(SINDX)*AG))**(1.365566 + 2.045963/SINDX)
        HGUESS = (HGUESS + 1.37)*3.281
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC MH HGUESS= ',HGUESS
C------
C LODGEPOLE PINE USE DAHMS PNW 8
C SPECIES: LP
C------
      CASE(7)
        HGUESS = SINDX*(-0.0968 + 0.02679*AG - 0.00009309*AG*AG)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC LP HGUESS= ',HGUESS
C------
C ENGLEMANN SPRUCE USE ALEXANDER
C SPECIES: ES
C------
      CASE(8)
        HGUESS = 4.5+((2.75780*SINDX**0.83312)*(1.0-EXP(-0.015701*AG))
     &           **(22.71944*SINDX**(-0.63557)))
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC ES HGUESS= ',HGUESS
C----------
C SHASTA FIR: R6 USES DOLPH RED FIR CURVES, RES PAP PSW 206
C             R5 USES DUNNING-LEVITATN CURVES
C SPECIES: SH
C----------
      CASE(9)
        SELECT CASE (JFOR)
        CASE (1:3,10)
          TERM=AG*EXP(AG*(-0.0440853))*1.41512E-6
          B = SINDX*TERM - 3.04951E6*TERM*TERM + 5.72474E-4
          TERM2 = 50.0 * EXP(50.0*(-0.0440853)) * 1.41512E-6
          B50 = SINDX*TERM2 - 3.04951E6*TERM2*TERM2 + 5.72474E-4
          HGUESS = ((SINDX-4.5) * (1.0-EXP(-B*(AG**1.51744)))) /
     &             (1.0-EXP(-B50*(50.0**1.51744)))
          HGUESS = HGUESS + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC SH TERM,B,TERM2,B50,HGUESS= ',
     &  TERM,B,TERM2,B50,HGUESS
C
        CASE DEFAULT
C----------
C SET UP MAPPING TO THE CORRECT DUNNING-LEVITAN SITE CURVE
C----------
          IF(SINDX .LE. 44.) THEN
            INDX=6
          ELSEIF (SINDX.GT.44. .AND. SINDX.LE.52.) THEN
            INDX=5
          ELSEIF (SINDX.GT.52. .AND. SINDX.LE.65.) THEN
            INDX=4
          ELSEIF (SINDX.GT.65. .AND. SINDX.LE.82.) THEN
            INDX=3
          ELSEIF (SINDX.GT.82. .AND. SINDX.LE.98.) THEN
            INDX=2
          ELSE
            INDX=1
          ENDIF
          IF(AG .LE. 40.) THEN
            HGUESS = DUNL3(INDX) * AG
          ELSE
            HGUESS = DUNL1(INDX) + DUNL2(INDX)*ALOG(AG)
          ENDIF
          IF(DEBUG)WRITE(JOSTND,*)' HTCALC SH DUNNING INDX,HGUESS= ',
     &    INDX,HGUESS
        END SELECT
C------
C PONDEROSA PINE USE BARRETT. THIS EQUATION ALSO USED FOR SUGAR PINE.
C SPECIES: SP, PP
C------
       CASE(2,10)
        HGUESS = (128.89522*(1.0 -EXP(-0.016959*AG))**1.23114)
     &         - ((-0.7864 + 2.49717*(1.0-EXP(-0.0045042*AG))**0.33022)
     &         *100.43) + ((-0.7864 + 2.49717*(1.0- EXP(-0.0045042*AG))
     &         **0.33022)*(SINDX - 4.5)) + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC SP/PP HGUESS= ',HGUESS
C------
C SUB ALPINE FIR USES JOHNSON'S EQUIV OF DEMARS
C SPECIES: AF
C------
      CASE(13)
        HGUESS=SINDX*(-0.07831 + 0.0149*AG - 4.0818E-5*AG*AG)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC AF HGUESS= ',HGUESS
C----------
C NOBLE FIR - HERMAN, PNW-243
C SPECIES: NF
C----------
      CASE(15)
        X1 = -564.38 + 22.250*(SINDX - 4.5) - 0.04995*(SINDX - 4.5)**2
        X2 = 6.8 + 2843.21*(SINDX - 4.5)**(-1) + 34735.54*
     &       (SINDX - 4.5)**(-2)
        HGUESS = 4.5 + (SINDX - 4.5)/(X1*(1.0/AG)**2 +
     &   X2*(1.0/AG) + 1.0 - 0.0001*X1 - 0.01*X2)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC NF X1,X2,HGUESS= ',X1,X2,HGUESS
C----------
C WESTERN LARCH USE COCHRAN PNW 424
C SPECIES: WL
C----------
      CASE(17)
        HGUESS=4.5 + 1.46897*AG + 0.0092466*AG*AG - 0.00023957*AG**3 +
     &       1.1122E-6*AG**4 + (SINDX -4.5)*(-0.12528 + 0.039636*AG
     &       - 0.0004278*AG*AG + 1.7039E-6*AG**3)-
     &       73.57*(-0.12528 + 0.039636*AG - 0.0004278*AG*AG + 
     &       1.7039E-6*AG**3)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WL HGUESS= ',HGUESS
C----------
C RED CEDAR ---- USE HEGYI, JELINEK, VISZLAI,
C & CARPENTER 1981 FOR SITE REFERENCE
C SPECIES: RC
C----------
      CASE(18)
        HGUESS = 1.3283*SINDX * ((1.0 - EXP(-0.0174*AG))**1.4711)
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC RC HGUESS= ',HGUESS
C----------
C WESTERN HEMLOCK - WILEY, 1978
C SPECIES: WH
C----------
      CASE(19)
        Z = 2500./(SINDX-4.5)
        HGUESS = (AG*AG/(-1.73070 + 0.1394*Z + (-0.0616 + 0.0137*Z)*AG 
     &         + (0.00192 + 0.00007*Z)*(AG*AG))) + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WH Z,HGUESS= ',Z,HGUESS
C----------
C MISC. SPECIES - USE CURTIS, FOR. SCI. 20:307-316.  CURTIS CURVES
C ARE PRESENTED IN METRIC (3.2808 ?)
C
C BECAUSE OF EXCESSIVE HT GROWTH -- APPROX 30-40 FT/CYCLE, TOOK OUT 
C THE METRIC MULTIPLIER. DIXON 11-05-92
C SPECIES: PY, WA, BM, CW, CH, WI, GC, MC, MB, OH
C----------
      CASE(20,21,23,25,26,28:31,33)
        HGUESS = (SINDX - 4.5) / (0.6192 - 5.3394/(SINDX - 4.5)
     &         + 240.29*AG**(-1.4) + (3368.9/(SINDX-4.5))*AG**(-1.4))
        HGUESS = HGUESS + 4.5
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC MISC HGUESS= ',HGUESS
C----------
C RED ALDER - HARRINGTON, PNW-358
C SPECIES: RA
C----------
      CASE(22)
        HGUESS = SINDX
     &         + (59.5864 + 0.79530*SINDX)*(1.0-EXP((0.00194 - 
     &         0.000740*SINDX)*AG))**0.9198
     &         - (59.5864 + 0.79530*SINDX)*(1.0-EXP((0.00194 -
     &         0.000740*SINDX)*20.0))**0.9198
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC RA HGUESS= ',HGUESS
C----------
C R6 POWERS BLACK OAK RES NOTE PSW-262
C R5 DUNNING-LEVITAN SITE CURVES
C SPECIES: WO
C----------
      CASE(27)
        SELECT CASE (JFOR)
        CASE (1:3,10)
          TERM = SQRT(AG)-SQRT(50.)
          HGUESS = (SINDX * (1 + 0.322*TERM)) - 6.413*TERM
          IF(DEBUG)WRITE(JOSTND,*)' HTCALC WO HGUESS= ',HGUESS
C
        CASE DEFAULT
C----------
C SET UP MAPPING TO THE CORRECT DUNNING-LEVITAN SITE CURVE
C----------
          IF(SINDX .LE. 44.) THEN
            INDX=6
          ELSEIF (SINDX.GT.44. .AND. SINDX.LE.52.) THEN
            INDX=5
          ELSEIF (SINDX.GT.52. .AND. SINDX.LE.65.) THEN
            INDX=4
          ELSEIF (SINDX.GT.65. .AND. SINDX.LE.82.) THEN
            INDX=3
          ELSEIF (SINDX.GT.82. .AND. SINDX.LE.98.) THEN
            INDX=2
          ELSE
            INDX=1
          ENDIF
          IF(AG .LE. 40.) THEN
            HGUESS = DUNL3(INDX) * AG
          ELSE
            HGUESS = DUNL1(INDX) + DUNL2(INDX)*ALOG(AG)
          ENDIF
          IF(DEBUG)WRITE(JOSTND,*)' HTCALC WO DUNNING INDX,HGUESS= ',
     &    INDX,HGUESS
        END SELECT
C----------
C WESTERN JUNIPER, WHITEBARK PINE, AND QUAKING ASPEN DO NOT HAVE SITE CURVES
C SPECIES: WJ, WB, AS
C----------
      CASE(11,16,24)
        HGUESS=0.0
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC WJ/WB/AS HGUESS= ',HGUESS
C----------
C FUTURE SPECIES
C----------
      CASE DEFAULT
        HGUESS=0.0
        IF(DEBUG)WRITE(JOSTND,*)' HTCALC DEFAULT HGUESS= ',HGUESS
C
      END SELECT
C
      RETURN
      END