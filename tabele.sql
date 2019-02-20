CREATE SEQUENCE seq_id_pracownicy START WITH 1 MINVALUE 0 INCREMENT BY 1;
CREATE SEQUENCE seq_id_wynagrodzenia START WITH 1 MINVALUE 0 INCREMENT BY 1;
CREATE SEQUENCE seq_id_miasta START WITH 1 MINVALUE 0 INCREMENT BY 1;
CREATE SEQUENCE seq_id_wynagrodzen START WITH 1 MINVALUE 0 INCREMENT BY 1;

CREATE TABLE Miasta (
	id NUMERIC(6) DEFAULT seq_id_miasta.NEXTVAL PRIMARY KEY,
	nazwa VARCHAR(20) NOT NULL,
	kod_pocztowy VARCHAR(6) UNIQUE NOT NULL
);

CREATE TABLE typy_wynagrodzen (
	id NUMERIC(6) DEFAULT seq_id_wynagrodzen.NEXTVAL PRIMARY KEY,
	nazwa VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Pracownicy (
	id NUMERIC(6) DEFAULT seq_id_pracownicy.NEXTVAL PRIMARY KEY,
	imie VARCHAR(20) NOT NULL,
	nazwisko VARCHAR(20) NOT NULL,
	pesel CHAR(11) UNIQUE NOT NULL,
	plec CHAR(1) NOT NULL,
	data_urodzenia DATE NOT NULL,
	id_miasta NUMERIC(6) REFERENCES miasta(id),
	data_zatrudnienia DATE NOT NULL,
	data_zwolnienia DATE,
		
	CHECK (plec = 'M' OR plec = 'K'),
	CHECK (data_zwolnienia > data_zatrudnienia),
	CHECK (TO_CHAR(data_zatrudnienia, 'dd') = '01'),
	CHECK (TO_CHAR(data_zwolnienia, 'dd') IN ('28', '29', '30', '31'))
);

CREATE TABLE Wynagrodzenia (
	id NUMERIC(6) DEFAULT seq_id_wynagrodzenia.NEXTVAL PRIMARY KEY,
	id_pracownika NUMERIC(6) REFERENCES Pracownicy(id) NOT NULL,
	data_od DATE NOT NULL,
	data_do DATE,
	kwota NUMERIC NOT NULL,
	id_typu_wynagrodzenia NUMERIC(6) REFERENCES typy_wynagrodzen(id) NOT NULL,
	uwagi VARCHAR(100),
	
	CHECK (kwota >= 0),
	CHECK (data_od<data_do),
	CHECK (TO_CHAR(data_od, 'dd')='01'),
	CHECK (TO_CHAR(data_do, 'dd') IN ('28', '29', '30', '31'))
);



CREATE OR REPLACE TRIGGER trigger_f_validator_pesel
	BEFORE INSERT ON Pracownicy
	FOR EACH ROW
BEGIN
	IF MOD(
  TO_NUMBER(SUBSTR(:NEW.pesel,1,1))
  +3*TO_NUMBER(SUBSTR(:NEW.pesel,2,1))
  +7*TO_NUMBER(SUBSTR(:NEW.pesel,3,1))
  +9*TO_NUMBER(SUBSTR(:NEW.pesel,4,1))
  +TO_NUMBER(SUBSTR(:NEW.pesel,5,1))
  +3*TO_NUMBER(SUBSTR(:NEW.pesel,6,1))
  +7*TO_NUMBER(SUBSTR(:NEW.pesel,7,1))
  +9*TO_NUMBER(SUBSTR(:NEW.pesel,8,1))
  +TO_NUMBER(SUBSTR(:NEW.pesel,9,1))
  +3*TO_NUMBER(SUBSTR(:NEW.pesel,10,1))
  +TO_NUMBER(SUBSTR(:NEW.pesel,11,1))
  ,10)!=0 
	OR LENGTH(:NEW.pesel)!=11
  THEN
	RAISE_APPLICATION_ERROR(-20001,'Niepoprawny PESEL');
  
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trigger_data_urodzenia_null
	BEFORE INSERT ON Pracownicy
	FOR EACH ROW
	WHEN (NEW.data_urodzenia IS NULL)
BEGIN
	SELECT TO_DATE(SUBSTR(:NEW.pesel,1,2)||'-'||SUBSTR(:NEW.pesel,3,2)||'-'||SUBSTR(:NEW.pesel,5,2), 'YYYY-MM-DD') INTO :NEW.data_urodzenia FROM dual;
END;
/


CREATE VIEW V_Wynagrodzenia (imie, nazwisko, pesel, nazwa_miasta, data_zatrudnienia, data_zwolnienia, id_wynagrodzenia, id_pracownika, data_od, data_do, kwota, nazwa_typu_wynagrodzenia, uwagi) AS
SELECT pr.imie, pr.nazwisko, pr.pesel, m.nazwa, pr.data_zatrudnienia, pr.data_zwolnienia, w.id, pr.id, w.data_od, w.data_do, w.kwota, tw.nazwa, w.uwagi
FROM (pracownicy pr LEFT OUTER JOIN wynagrodzenia w ON pr.id=w.id_pracownika LEFT JOIN miasta m ON pr.id_miasta=m.id LEFT JOIN typy_wynagrodzen tw ON w.id_typu_wynagrodzenia=tw.id);