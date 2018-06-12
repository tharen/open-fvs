       SUBROUTINE EXTWIGVOL
       IMPLICIT NONE
C----------
C BASE $Id: extwigvol.f 0000 2018-02-14 00:00:00Z gedixon $
C
C  SATISFY CALLS TO TWIGS VOLUME EQUATIONS FROM ***FVSVOL*** FROM
C  NON-R9 VARIANTS
C----------
      INTEGER ISPC,I
      REAL    H,D,VMAX,BBFV,VN,VM
      REAL RDANUW
      INTEGER IDANUW
C
      ENTRY TWIGBF(ISPC,H,D,VMAX,BBFV)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = ISPC
        RDANUW = H
        RDANUW = D
        RDANUW = VMAX
        RDANUW = BBFV
C
      RETURN
C
      ENTRY TWIGCF(ISPC,H,D,VN,VM,I)
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
        IF(.TRUE.)RETURN
        IDANUW = ISPC
        RDANUW = H
        RDANUW = D
        RDANUW = VN
        RDANUW = VM
        IDANUW = I
C
      RETURN
C
      END