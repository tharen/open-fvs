      SUBROUTINE C26SRT (N,A,INDEX,LSEQ)
      IMPLICIT NONE
C----------
C  **C26SRT--PPBASE   DATE OF LAST REVISION:  07/31/08
C----------
C
C  CHARACTER*26 INDEX SORT.
C
C  C26SRT USES THE VECTOR INDEX TO INDIRECTLY ADDRESS THE ARRAY A.
C  THE FIRST N ELEMENTS OF THE ARRAY INDEX REPRESENT INDICES OF
C  ELEMENTS OF ARRAY A TO BE SORTED OVER.  THE FIRST N ELEMENTS OF THE
C  INDEX ARRAY ARE REARRANGED SUCH THAT FOR EACH I FROM 1 TO N-1,
C  A(INDEX(I)) IS LESS THAN A(INDEX(I+1)).  THE PHYSICAL ARRANGEMENT
C  OF ARRAY A IS NOT ALTERED.
C
C  IF LSEQ IS PASSED IN AS TRUE, THE VECTOR INDEX IS INITIALLY LOADED
C  WITH VALUES FROM 1 TO N INCLUSIVE.  THIS SORTS OVER THE FIRST
C  N ELEMENTS OF ARRAY A.
C
C  IF LSEQ IS PASSED IN AS FALSE, THE FIRST N ELEMENTS OF INDEX ARE
C  ASSUMED TO BE THE INDICES OF A TO BE SORTED OVER.
C
C
C  THIS ALGORITHM IS AN ADAPTATION OF THE TECHNIQUE DESCRIBED IN:
C
C       SCOWEN, R.A. 1965. ALGORITHM 271; QUICKERSORT. COMM ACM.
C                    8(11) 669-670.
C
C----------
C  DECLARATIONS:
C----------
      LOGICAL LSEQ
      INTEGER INDEX(N),IPUSH(33),IL,IP,IU,INDIL,INDIP,INDIU,INDKL,INDKU,
     &        ITOP,JL,JU,KL,KU,I,N
      CHARACTER*26 A(*),T
C----------
C  LOAD IND WITH VALUES FROM 1 TO N.
C----------
      IF (LSEQ) THEN
      DO 10 I=1,N
   10 INDEX(I)=I
      ENDIF
C----------
C  RETURN IF FEWER THAN TWO ELEMENTS IN ARRAY A.
C----------
      IF(N.LT.2) RETURN
C----------
C  BEGIN THE SORT.
C----------
      ITOP=0
      IL=1
      IU=N
   30 CONTINUE
      IF(IU.LE.IL) GO TO 40
      INDIL=INDEX(IL)
      INDIU=INDEX(IU)
      IF(IU.GT.IL+1) GO TO 50
      IF(A(INDIL).LE.A(INDIU)) GO TO 40
      INDEX(IL)=INDIU
      INDEX(IU)=INDIL
   40 CONTINUE
      IF(ITOP.EQ.0) RETURN
      IL=IPUSH(ITOP-1)
      IU=IPUSH(ITOP)
      ITOP=ITOP-2
      GO TO 30
   50 CONTINUE
      IP=(IL+IU)/2
      INDIP=INDEX(IP)
      T=A(INDIP)
      INDEX(IP)=INDIL
      KL=IL
      KU=IU
   60 CONTINUE
      KL=KL+1
      IF(KL.GT.KU) GO TO 90
      INDKL=INDEX(KL)
      IF(A(INDKL).LE.T) GO TO 60
   70 CONTINUE
      INDKU=INDEX(KU)
      IF(KU.LT.KL) GO TO 100
      IF(A(INDKU).LT.T) GO TO 80
      KU=KU-1
      GO TO 70
   80 CONTINUE
      INDEX(KL)=INDKU
      INDEX(KU)=INDKL
      KU=KU-1
      GO TO 60
   90 CONTINUE
      INDKU=INDEX(KU)
  100 CONTINUE
      INDEX(IL)=INDKU
      INDEX(KU)=INDIP
      IF(KU.LE.IP) GO TO 110
      JL=IL
      JU=KU-1
      IL=KU+1
      GO TO 120
  110 CONTINUE
      JL=KU+1
      JU=IU
      IU=KU-1
  120 CONTINUE
      ITOP=ITOP+2
      IPUSH(ITOP-1)=JL
      IPUSH(ITOP)=JU
      GO TO 30
      END
