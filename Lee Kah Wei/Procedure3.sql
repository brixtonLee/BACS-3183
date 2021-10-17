DELETE MEMBER WHERE MEMBERID = 'M1501';
DELETE MEMBER WHERE MEMBERID = 'M1502';

CREATE OR REPLACE PROCEDURE ADD_NEW_MEMBER(P_MEMBERID IN VARCHAR2, V_MEMBERNAME IN VARCHAR2, V_MEMBERICNO IN VARCHAR2, V_MEMBERGENDER IN CHAR, V_MEMBERDOB IN VARCHAR2, V_EMAIL IN VARCHAR2, V_PHONENO IN VARCHAR2) AS
	V_MEMBERID VARCHAR2(10);	

	UNDER_AGE EXCEPTION;
	PRAGMA exception_init(UNDER_AGE, -20110);

BEGIN
	V_MEMBERID := CONCAT('M', P_MEMBERID);
	INSERT INTO MEMBER (MEMBERID, MEMBERNAME, MEMBERICNO, MEMBERGENDER, MEMBERDOB, MEMBEREMAIL, MEMBERPHONENO) VALUES (V_MEMBERID, V_MEMBERNAME, V_MEMBERICNO, V_MEMBERGENDER, V_MEMBERDOB, V_EMAIL, V_PHONENO);
	DBMS_OUTPUT.PUT_LINE('MEMBER NAME: ' || V_MEMBERNAME || ' HAS BEEN INSERTED SUCCESSFULLY');

	DBMS_OUTPUT.PUT_LINE('MEMBER DETAILS');
	DBMS_OUTPUT.PUT_LINE('-------------------------');
	DBMS_OUTPUT.PUT_LINE('MEMBER ID  : ' || V_MEMBERID);
	DBMS_OUTPUT.PUT_LINE('NAME       : ' || V_MEMBERNAME);
	DBMS_OUTPUT.PUT_LINE('IC         : ' || V_MEMBERICNO);
	DBMS_OUTPUT.PUT_LINE('GENDER     : ' || V_MEMBERGENDER);
	DBMS_OUTPUT.PUT_LINE('DOB        : ' || V_MEMBERDOB);
	DBMS_OUTPUT.PUT_LINE('EMAIL      : ' || V_EMAIL);
	DBMS_OUTPUT.PUT_LINE('PHONE NO   : ' || V_PHONENO);

	EXCEPTION
		WHEN UNDER_AGE THEN
			DBMS_OUTPUT.PUT_LINE('USER AGE UNDER 18, CANNOT REGISTER AS A MEMBER');

END;
/

EXEC ADD_NEW_MEMBER(MEMBER_SEQ.NEXTVAL, 'LEE KAH WEI', '000618030203', 'M', '18-JUN-2000', 'LKW06182000@HOTMAIL.COM', '0125768669');
EXEC ADD_NEW_MEMBER(MEMBER_SEQ.NEXTVAL, 'BRIXTON LEE', '000618030304', 'M', '18-JUN-2005', 'LKW06182000@HOTMAIL.COM', '0135763669');