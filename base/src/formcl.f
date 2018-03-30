      SUBROUTINE FORMCL(ISPC,IFOR,D,FC)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C THIS PROGRAM CALCULATES FORM FACTORS FOR CALCULATING CUBIC AND
C BOARD FOOT VOLUMES.
C
C THIS IS THE VANILLA VERSION FOR USE IN VARIANTS THAT DON'T USE
C FORM CLASS, OR ONLY SET DEFAULT FORM CLASSES BY SPECIES.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
      INTEGER IFOR,ISPC
      REAL FC,D
      REAL DANUW
C
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      DANUW = D
      DANUW = REAL(IFOR)
C
C----------
C  LOAD FORM CLASS VALUE
C----------
      FC=FRMCLS(ISPC)
C
      RETURN
      END
