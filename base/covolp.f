      SUBROUTINE COVOLP (DEBUG,JOSTND,NTREES,INDEX,CRAREA,COVER,CCCOEF)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     N.L.CROOKSTON - RMRS MOSCOW - OCTOBER 1997

C     OUTPUT:
C     COVER = PERCENT COVER THAT ACCOUNTS FOR CROWN OVERLAP
 
C     INPUT:
C     DEBUG = .TRUE. IF DEBUGING OUTPUT IS REQUESTED.
C     JOSTND= THE DATA SET REF NUMBER FOR OUTPUT.
C     NTREES= THE NUMBER OF VALUES IN INDEX (COULD BE EQUAL TO ITRN).
C     INDEX = A VECTOR OF TREE RECORD POINTERS THAT WILL BE INCLUDED
C             IN THE CALCULATIONS (COULD BE PASSED AS IND).
C             IF INDEX(1) IS ZERO, THE INDICES ARE NOT USED.
C     CRAREA= LOADED WITH THE CROWN AREA (PER ACRE) PROJECTED BY EACH 
C             TREE RECORD
C     CCCOEF= USER-SPECIFIED COEFFICIENT FOR SPECIFYING THE DISTRIBUTION
C       OF THE TREE RECORDS %CC IS BEING CALCULATED FOR.

      REAL CRAREA(*),COVER,SUM,CCCOEF,PCCU
      INTEGER INDEX(*),NTREES,JOSTND,I
      LOGICAL DEBUG 
         
      COVER = 0.
      SUM = 0.
      
      IF (DEBUG) WRITE (JOSTND,'('' IN COVOLP, NTREES ='',I4)') 
     >           NTREES

      IF (NTREES.EQ.0) GOTO 30

      IF (INDEX(1).EQ.0) THEN
         DO I=1,NTREES
            SUM = SUM+CRAREA(I)
         ENDDO
      ELSE
         DO I=1,NTREES
            SUM = SUM+CRAREA(INDEX(I))
         ENDDO
      ENDIF
      
      PCCU = CCCOEF*(SUM/43560.0)
      
      IF (PCCU.GT.5.) THEN
         COVER=100.
      ELSE
         COVER = (1.0-EXP(-PCCU))*100.0
      ENDIF
      
C      IF(COVER.GT.PCCU)COVER=PCCU

 30   CONTINUE
      IF (DEBUG) WRITE (JOSTND,40) SUM,COVER,CCCOEF
 40   FORMAT (' SUM=',E14.7,'; COVER=',F8.1,'; CCCOEF=',F8.6)
      RETURN
      END