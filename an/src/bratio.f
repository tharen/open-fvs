      FUNCTION BRATIO(IS,D,H)
      IMPLICIT NONE
C----------
C  **BRATIO--AN   DATE OF LAST REVISION:  02/14/08
C
C     SPECIES LIST FOR ALASKA VARIANT.
C
C     1 = WHITE SPRUCE (WS)           PICEA GLAUCA
C     2 = WESTERN REDCEDAR (RC)       THUJA PLICATA
C     3 = PACIFIC SILVER FIR (SF)     ABIES AMABILIS
C     4 = MOUNTAIN HEMLOCK (MH)       TSUGA MERTENSIANA
C     5 = WESTERN HEMLOCK (WH)        TSUGA HETEROPHYLLA
C     6 = ALASKA YELLOW CEDAR (YC)    CHAMAECYPARIS NOOTKATENSIS
C     7 = LODGEPOLE PINE (LP)         PINUS CONTORTA
C     8 = SITKA SPRUCE (SS)           PICEA SITCHENSIS
C     9 = SUBALPINE FIR (AF)          ABIES LASIOCARPA
C    10 = RED ALDER (RA)              ALNUS RUBRA
C    11 = BLACK COTTONWOOD (CW)       POPULUS TRICHOCARPA
C    12 = OTHER HARDWOODS (OH)
C    13 = OTHER SOFTWOODS (OS)
C
C  FUNCTION TO COMPUTE BARK RATIOS AS A FUNCTION OF DIAMETER
C----------
      INTEGER IS
      REAL H,D,BRATIO,DIB,DD
C  RED ALDER AND COTTONWOOD (FROM PN VARIANT)
C----------
      IF(IS.EQ.10 .OR. IS.EQ.11) THEN
        DIB=0.075256 + 0.94373*D
        BRATIO=DIB/D
      ELSE
C----------
C  EQUATIONS FOR OTHER SPECIES
C  COMPUTE DOUBLE BARK THICKNESS AND STORE IN BRATIO
C----------
        DD=D
        IF(DD .LT. 1.)DD=1.
        BRATIO = 0.186 * (DD ** 0.45417)
C----------
C SUBTRACT DOUBLE BARK THICKNESS FROM DIAMETER, THEN DIVIDE BY
C DIAMETER TO GET BARK RATIO.
C----------
        BRATIO = (DD - BRATIO) / DD
      ENDIF
C
      RETURN
      END
