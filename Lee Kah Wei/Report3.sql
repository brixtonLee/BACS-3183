SET PAGESIZE 600
SET LINESIZE 1200

CREATE OR REPLACE PROCEDURE PRC_SCHEDULE_LATE AS

ONTIMECOUNTER NUMBER;
DELAYCOUNTER NUMBER;
CANCELCOUNTER NUMBER;
TOTALCOUNTER NUMBER;
TOTALNOTONTIMECOUNTER NUMBER;
V_INDICATOR VARCHAR2(11);
PERCENTAGE NUMBER(7,2);
ROUTENO VARCHAR2(10);
TOTAL_LOSS_VALUE NUMBER(7,2);
TOTAL_TICKET_DIDNT_SOLD_OUT NUMBER;
TOTAL_DELAYED_CANCELLED_PERCENTAGE NUMBER(7,2);

CURSOR SCHEDULE_STATUS_CURSOR(V_YEAR VARCHAR2) IS
	SELECT V1.ROUTENO, V1.YEAR, COALESCE(V1.ONTIMECOUNTER, 0) AS ONTIMECOUNTER, COALESCE(V2.DELAYCOUNTER, 0) AS DELAYCOUNTER, COALESCE(V3.CANCELCOUNTER, 0) AS CANCELCOUNTER
	FROM ((SELECT ROUTENO, TO_CHAR(DEPARTUREDATE, 'YYYY') AS YEAR, COUNT(*) AS ONTIMECOUNTER FROM BUSSCHEDULE WHERE SCHEDULESTATUS = 'On Time' AND TO_CHAR(DEPARTUREDATE, 'YYYY') = V_YEAR GROUP BY TO_CHAR(DEPARTUREDATE, 'YYYY'), ROUTENO ORDER BY YEAR, ROUTENO) V1 ) INNER JOIN
	((SELECT ROUTENO,TO_CHAR(DEPARTUREDATE, 'YYYY') AS YEAR, COUNT(*) AS DELAYCOUNTER FROM BUSSCHEDULE WHERE SCHEDULESTATUS = 'Delayed' AND TO_CHAR(DEPARTUREDATE, 'YYYY') = V_YEAR GROUP BY TO_CHAR(DEPARTUREDATE, 'YYYY'), ROUTENO ORDER BY YEAR, ROUTENO) V2) ON V1.YEAR = V2.YEAR AND V1.ROUTENO = V2.ROUTENO LEFT JOIN
	((SELECT ROUTENO, TO_CHAR(DEPARTUREDATE, 'YYYY') AS YEAR, COUNT(*) AS CANCELCOUNTER FROM BUSSCHEDULE WHERE SCHEDULESTATUS = 'Cancelled' AND TO_CHAR(DEPARTUREDATE, 'YYYY') = V_YEAR GROUP BY TO_CHAR(DEPARTUREDATE, 'YYYY'), ROUTENO ORDER BY YEAR, ROUTENO) V3) ON V1.YEAR = V3.YEAR AND V1.ROUTENO = V3.ROUTENO
	ORDER BY V1.ROUTENO;

CURSOR YEAR_CURSOR IS
	SELECT DISTINCT TO_CHAR(DEPARTUREDATE, 'YYYY') AS YEAR
	FROM BUSSCHEDULE
	ORDER BY YEAR;
BEGIN

DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE(rpad(chr(9),7)||' ROUTE DELAYED PERCENTAGE REPORT');
DBMS_OUTPUT.PUT_LINE(rpad(chr(9),7)||'*********************************');
DBMS_OUTPUT.PUT_LINE('FROM 01-JAN-2018 to ' || TO_CHAR(sysdate, 'DD-MON-YYYY'));

FOR YEAR_REC IN YEAR_CURSOR LOOP
	TOTALNOTONTIMECOUNTER := 0;
	TOTAL_DELAYED_CANCELLED_PERCENTAGE := 0;
	DBMS_OUTPUT.PUT_LINE(CHR(10));
	DBMS_OUTPUT.PUT_LINE('YEAR: ' ||YEAR_REC.YEAR);
	
	DBMS_OUTPUT.PUT_LINE(RPAD('-',65,'-'));
	DBMS_OUTPUT.PUT_LINE(RPAD('Route No', 10, ' ') || RPAD('On Time', 10, ' ') || RPAD('Delayed', 10, ' ') || RPAD('Cancelled', 10, ' ') || RPAD('Total', 10, ' ') || RPAD('Not On Time %', 15, ' '));
	DBMS_OUTPUT.PUT_LINE(RPAD('-',65,'-'));

	FOR SCHEDULE_REC IN SCHEDULE_STATUS_CURSOR(YEAR_REC.YEAR) LOOP
		V_INDICATOR := ' ';
		ONTIMECOUNTER := SCHEDULE_REC.ONTIMECOUNTER;
		DELAYCOUNTER := SCHEDULE_REC.DELAYCOUNTER;
		CANCELCOUNTER := SCHEDULE_REC.CANCELCOUNTER;
		
		
		TOTALCOUNTER:= ONTIMECOUNTER + DELAYCOUNTER + CANCELCOUNTER;
		PERCENTAGE:= (((DELAYCOUNTER + CANCELCOUNTER) / TOTALCOUNTER) * 100);
		TOTAL_DELAYED_CANCELLED_PERCENTAGE := TOTAL_DELAYED_CANCELLED_PERCENTAGE + PERCENTAGE;

		IF(PERCENTAGE > 20) THEN
			V_INDICATOR := '#<--------';
		END IF;
		TOTALNOTONTIMECOUNTER := TOTALNOTONTIMECOUNTER + DELAYCOUNTER + CANCELCOUNTER;
		DBMS_OUTPUT.PUT_LINE(RPAD(SCHEDULE_REC.ROUTENO,10, ' ') || RPAD(SCHEDULE_REC.ONTIMECOUNTER, 10, ' ') || RPAD(SCHEDULE_REC.DELAYCOUNTER, 10, ' ') || RPAD(SCHEDULE_REC.CANCELCOUNTER, 10, ' ') || RPAD(TOTALCOUNTER, 15, ' ') || RPAD(TRIM(TO_CHAR(PERCENTAGE,'999D99')), 6, ' ') || ' % ' || V_INDICATOR);

		
		
		END LOOP;
	DBMS_OUTPUT.PUT_LINE(RPAD('=',65,'='));
	DBMS_OUTPUT.put_line('.'||lpad(TOTALNOTONTIMECOUNTER||' RECORDS FOUND FOR ' || ' DELAYED/CANCELLED SCHEDULE IN ' || YEAR_REC.YEAR,64,' ') ||'.');
	DBMS_OUTPUT.put_line('.'||lpad('Total DELAYED/CANCELLED PERCENTAGE FOR '||YEAR_REC.YEAR||' is '|| TOTAL_DELAYED_CANCELLED_PERCENTAGE|| '%',64,' ')||'.');
	END LOOP;
DBMS_OUTPUT.PUT_LINE(CHR(10)||LPAD('-END OF REPORT-',35,' '));
END;
/
EXEC PRC_SCHEDULE_LATE