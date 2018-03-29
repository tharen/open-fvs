      SUBROUTINE VARPUT (WK3,IPNT,ILIMIT,REALS,LOGICS,INTS)
      IMPLICIT NONE
C----------
C SN $Id: varput.f 0000 2018-02-14 00:00:00Z gedixon $
C----------
C
C     WRITE THE VARIANT SPECIFIC VARIABLES.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION TO PROGNOSIS.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'SNCOM.F77'
C
C
COMMONS
C
C     NOTE: THE ACTUAL STORAGE LIMIT FOR INTS, LOGICS, AND REALS
C     IS MAXTRE (SEE PRGPRM).  
C
      INTEGER ILIMIT,IPNT,MXL,MXI,MXR
      PARAMETER (MXL=1,MXI=2,MXR=1)
      LOGICAL LOGICS(*)
      REAL WK3(MAXTRE)
      INTEGER INTS (*)
      REAL REALS (*)
      REAL DANUW
      LOGICAL LDANUW
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      DANUW = REALS(1)
      LDANUW = LOGICS(1)
C
C
C     GET THE INTEGER SCALARS.
C
      INTS(1) = KODIST
      INTS(2) = ISEFOR
      CALL IFWRIT (WK3, IPNT, ILIMIT, INTS, MXI, 2)
C
C     GET THE LOGICAL SCALARS.
C
C**   CALL LFWRIT (WK3, IPNT, ILIMIT, LOGICS, MXL, 2)
C
C     GET THE REAL SCALARS.
C
C**   CALL BFWRIT (WK3, IPNT, ILIMIT, REALS, MXR, 2)
      RETURN
      END

      SUBROUTINE VARCHPUT (CBUFF, IPNT, LNCBUF)
      IMPLICIT NONE
C----------
C     Put variant-specific character data
C----------

      INCLUDE 'PRGPRM.F77'

      INTEGER LNCBUF
      CHARACTER CBUFF(LNCBUF)
      INTEGER IPNT
      REAL DANUW
      CHARACTER CDANUW
      ! Stub for variants which need to get/put character data
      ! See /bc/varget.f and /bc/varput.f for examples of VARCHGET and VARCHPUT
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      DANUW = REAL(IPNT)
      CDANUW = CBUFF(1)
C
      RETURN
      END
