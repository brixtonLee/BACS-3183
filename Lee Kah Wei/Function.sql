CREATE OR REPLACE FUNCTION FINDSCHEDULEID(IN_SCHEDULEID IN BUSSCHEDULE.SCHEDULEID%TYPE) RETURN NUMBER IS V_ISSCHEDULE NUMBER(1) := 0;
	V_SCHEDULE BUSSCHEDULE.SCHEDULEID%TYPE;
BEGIN
	SELECT SCHEDULEID INTO V_SCHEDULE
	FROM BUSSCHEDULE
	WHERE SCHEDULEID = IN_SCHEDULEID;

	IF NOT SQL%NOTFOUND THEN
		V_ISSCHEDULE :=1;
		RETURN V_ISSCHEDULE;
	END IF;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_ISSCHEDULE := 0;
		RETURN V_ISSCHEDULE;

	
END;
/

CREATE OR REPLACE FUNCTION FINDTRANSACTIONID(IN_TRANSACTIONID IN TRANSACTION.TRANSACTIONID%TYPE) RETURN NUMBER IS V_ISTRANSACTION NUMBER(1) := 0;
	V_TRANSACTIONID BUSSCHEDULE.SCHEDULEID%TYPE;
BEGIN
	SELECT TRANSACTIONID INTO V_TRANSACTIONID
	FROM TRANSACTION
	WHERE TRANSACTIONID = IN_TRANSACTIONID;

	IF NOT SQL%NOTFOUND THEN
		V_ISTRANSACTION :=1;
		RETURN V_ISTRANSACTION;
	END IF;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_ISTRANSACTION := 0;
		RETURN V_ISTRANSACTION;
	
END;
/

CREATE OR REPLACE FUNCTION FINDMEMBERID(IN_MEMBERID IN MEMBER.MEMBERID%TYPE) RETURN NUMBER IS V_ISMEMBER NUMBER(1) := 0;
	V_MEMBERID MEMBER.MEMBERID%TYPE;
BEGIN
	SELECT MEMBERID INTO V_MEMBERID
	FROM MEMBER
	WHERE MEMBERID = IN_MEMBERID;

	IF NOT SQL%NOTFOUND THEN
		V_ISMEMBER := 1;
		RETURN V_ISMEMBER;
	END IF;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_ISMEMBER := 0;
		RETURN V_ISMEMBER;
	
END;
/

CREATE OR REPLACE FUNCTION VALIDATESCHEDULE(IN_SCHEDULEID IN BUSSCHEDULE.SCHEDULEID%TYPE, IN_PURCHASEDATE IN TRANSACTION.PURCHASEDATE%TYPE) RETURN NUMBER IS V_VALIDSCHEDULE NUMBER(1) := 0;
	V_DEPARTUREDATE BUSSCHEDULE.DEPARTUREDATE%TYPE;
BEGIN
	SELECT DEPARTUREDATE INTO V_DEPARTUREDATE
	FROM BUSSCHEDULE
	WHERE SCHEDULEID = IN_SCHEDULEID;

	IF NOT SQL%NOTFOUND THEN

		IF (TO_DATE(V_DEPARTUREDATE, 'DD-MM-YYYY') - TO_DATE(IN_PURCHASEDATE, 'DD-MM-YYYY') < 0) THEN
			V_VALIDSCHEDULE := 0;
			RETURN V_VALIDSCHEDULE;
		ELSE
			V_VALIDSCHEDULE := 1;
			RETURN V_VALIDSCHEDULE;
		END IF;
	END IF;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_VALIDSCHEDULE := 0;
		RETURN V_VALIDSCHEDULE;
	
END;
/

CREATE OR REPLACE FUNCTION CHECKSEAT0(IN_SCHEDULEID IN BUSSCHEDULE.SCHEDULEID%TYPE) RETURN NUMBER IS V_ISZERO NUMBER(1) := 0;
	V_NOOFTICKETAVAILABLE BUSSCHEDULE.NOOFTICKETAVAILABLE%TYPE;
BEGIN
	SELECT NOOFTICKETAVAILABLE INTO V_NOOFTICKETAVAILABLE
	FROM BUSSCHEDULE
	WHERE SCHEDULEID = IN_SCHEDULEID;

	IF NOT SQL%NOTFOUND THEN
		IF(V_NOOFTICKETAVAILABLE = 0) THEN
			V_ISZERO := 1;
			RETURN V_ISZERO;
		ELSE
			V_ISZERO := 0;
			RETURN V_ISZERO;
		END IF;
	END IF;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_ISZERO := 1;
		RETURN V_ISZERO;
END;
/

CREATE OR REPLACE FUNCTION FINDROUTENO(IN_ROUTENO IN ROUTE.ROUTENO%TYPE) RETURN NUMBER IS V_ISROUTE NUMBER(1) := 0;
	V_ROUTENO ROUTE.ROUTENO%TYPE;
BEGIN
	SELECT ROUTENO INTO V_ROUTENO
	FROM ROUTE
	WHERE ROUTENO = IN_ROUTENO;

	IF NOT SQL%NOTFOUND THEN
		V_ISROUTE := 1;
		RETURN V_ISROUTE;
	END IF;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_ISROUTE := 0;
		RETURN V_ISROUTE;
	
END;
/