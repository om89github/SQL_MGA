CREATE OR REPLACE PACKAGE pkg_prac IS
	FUNCTION wynagrodzenie_dla_pracownika (p_data IN DATE, p_id_pracownika IN NUMBER DEFAULT null, p_id_typu_wynagrodzenia IN NUMBER DEFAULT null) RETURN NUMBER;
	FUNCTION f_wynagrodzenia (p_data_od IN DATE, p_data_do IN DATE, p_pesel IN VARCHAR2 DEFAULT NULL, p_id_typu_wynagrodzenia IN NUMBER DEFAULT null) RETURN NUMBER;
	FUNCTION ilosc_aktywnych_pracownikow (p_data IN DATE) RETURN NUMBER;
	PROCEDURE dodaj_wynagrodzenie (p_data_od IN DATE, p_data_do IN DATE DEFAULT null, p_pesel IN VARCHAR2, p_id_typu_wynagrodzenia IN NUMBER, p_kwota IN NUMBER, p_czy_nadpisywac IN BOOLEAN DEFAULT FALSE);
END pkg_prac;
/

CREATE OR REPLACE PACKAGE BODY pkg_prac IS

FUNCTION wynagrodzenie_dla_pracownika (p_data IN DATE, p_id_pracownika IN NUMBER, p_id_typu_wynagrodzenia IN NUMBER DEFAULT null) RETURN NUMBER IS
  v_wynagrodzenie NUMBER(5);
  v_count NUMBER(5);
  v_data_zatr DATE;
  v_data_zwoln DATE;
  
 BEGIN
	BEGIN
		SELECT data_zatrudnienia INTO v_data_zatr
		FROM Pracownicy WHERE id=p_id_pracownika;
		
		SELECT data_zwolnienia INTO v_data_zwoln
		FROM Pracownicy WHERE id=p_id_pracownika;
		
			IF v_data_zwoln = NULL THEN v_data_zwoln:=current_date();  END IF;
						
			IF p_data NOT BETWEEN v_data_zatr AND v_data_zwoln THEN raise_application_error(-20001,'Pracownik nie byl lub nie jest zatrudniony w danym przedziale czasowym.'); END IF;
	END;

	IF p_id_typu_wynagrodzenia IS NULL THEN
    SELECT COUNT(id) INTO v_count FROM wynagrodzenia w WHERE p_data BETWEEN w.data_od AND w.data_do AND w.id_pracownika=p_id_pracownika;
    IF v_count = 0 THEN RETURN v_count; END IF;
    
		SELECT sum(w.kwota)INTO v_wynagrodzenie
		FROM wynagrodzenia w
		WHERE p_data BETWEEN w.data_od AND w.data_do AND w.id_pracownika=p_id_pracownika;
	ELSE
    SELECT COUNT(id) INTO v_count FROM wynagrodzenia w WHERE p_data BETWEEN w.data_od AND w.data_do AND w.id_pracownika=p_id_pracownika AND w.id_typu_wynagrodzenia=p_id_typu_wynagrodzenia;
    IF v_count = 0 THEN RETURN v_count; END IF;
  
		SELECT sum(w.kwota)INTO v_wynagrodzenie
		FROM wynagrodzenia w
		WHERE p_data BETWEEN w.data_od AND w.data_do AND w.id_pracownika=p_id_pracownika AND w.id_typu_wynagrodzenia=p_id_typu_wynagrodzenia;
	END IF;
  
RETURN v_wynagrodzenie;
	
END wynagrodzenie_dla_pracownika;



FUNCTION f_wynagrodzenia (p_data_od IN DATE, p_data_do IN DATE, p_pesel IN VARCHAR2 DEFAULT NULL, p_id_typu_wynagrodzenia IN NUMBER DEFAULT NULL) RETURN NUMBER IS
  v_id NUMBER(5);
  v_sum1 NUMBER(10);
  v_sum2 NUMBER(10);
  v_sum3 NUMBER(10);
  v_sum4 NUMBER(10);
  v_sum5 NUMBER(10);
  v_sum6 NUMBER(10);
  v_data_zatr DATE;
  v_data_zw DATE;

BEGIN
      IF p_data_od > p_data_do THEN raise_application_error(-20001,'Podane daty sa niepoprawne.'); END IF;
      IF length(p_pesel)!=11 THEN raise_application_error(-20001,'Niepoprawny PESEL.'); END IF;
CASE
  WHEN p_pesel IS NULL AND p_id_typu_wynagrodzenia IS NULL THEN
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0)) INTO v_sum1 FROM wynagrodzenia WHERE data_do IS NULL AND data_od >= p_data_od;
      IF v_sum1 IS NULL THEN v_sum1:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0)) INTO v_sum2 FROM wynagrodzenia WHERE data_do IS NULL AND data_od < p_data_od;
      IF v_sum2 IS NULL THEN v_sum2:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0))	INTO v_sum3 FROM wynagrodzenia WHERE data_do IS NOT NULL AND data_od >= p_data_od AND data_do >= p_data_do;
      IF v_sum3 IS NULL THEN v_sum3:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, data_od),0))	INTO v_sum4 FROM wynagrodzenia WHERE data_do IS NOT NULL AND data_od >= p_data_od AND data_do < p_data_do;
      IF v_sum4 IS NULL THEN v_sum4:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0))	INTO v_sum5 FROM wynagrodzenia WHERE data_do IS NOT NULL AND data_od < p_data_od AND data_do > p_data_do;
      IF v_sum5 IS NULL THEN v_sum5:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, p_data_od),0))	INTO v_sum6 FROM wynagrodzenia WHERE data_do IS NOT NULL AND data_od < p_data_od AND data_do < p_data_do;
      IF v_sum6 IS NULL THEN v_sum6:=0; END IF;
	    
    
      RETURN v_sum1+v_sum2+v_sum3+v_sum4+v_sum5+v_sum6;
    
  WHEN p_pesel IS NOT NULL AND p_id_typu_wynagrodzenia IS NULL THEN
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0)) INTO v_sum1 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND data_do IS NULL AND data_od >= p_data_od;
      IF v_sum1 IS NULL THEN v_sum1:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0)) INTO v_sum2 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND data_do IS NULL AND data_od < p_data_od;
    	IF v_sum2 IS NULL THEN v_sum2:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0)) INTO v_sum3 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND data_do IS NOT NULL AND data_od >= p_data_od AND data_do >= p_data_do;
      IF v_sum3 IS NULL THEN v_sum3:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, data_od),0)) INTO v_sum4 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND data_do IS NOT NULL AND data_od >= p_data_od AND data_do < p_data_do;
      IF v_sum4 IS NULL THEN v_sum4:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0)) INTO v_sum5 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND data_do IS NOT NULL AND data_od < p_data_od AND data_do > p_data_do;
      IF v_sum5 IS NULL THEN v_sum5:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, p_data_od),0)) INTO v_sum6 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND data_do IS NOT NULL AND data_od < p_data_od AND data_do < p_data_do;
      IF v_sum6 IS NULL THEN v_sum6:=0; END IF;
          
      RETURN v_sum1+v_sum2+v_sum3+v_sum4+v_sum5+v_sum6;

  WHEN p_pesel IS NULL AND p_id_typu_wynagrodzenia IS NOT NULL THEN
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0)) INTO v_sum1 FROM wynagrodzenia WHERE id_typu_wynagrodzenia=p_id_typu_wynagrodzenia AND data_do IS NULL AND data_od >= p_data_od;
      IF v_sum1 IS NULL THEN v_sum1:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0)) INTO v_sum2 FROM wynagrodzenia WHERE id_typu_wynagrodzenia=p_id_typu_wynagrodzenia AND data_do IS NULL AND data_od < p_data_od;
      IF v_sum2 IS NULL THEN v_sum2:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0)) INTO v_sum3 FROM wynagrodzenia WHERE id_typu_wynagrodzenia=p_id_typu_wynagrodzenia AND data_do IS NOT NULL AND data_od >= p_data_od AND data_do >= p_data_do;
      IF v_sum3 IS NULL THEN v_sum3:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, data_od),0)) INTO v_sum4 FROM wynagrodzenia WHERE id_typu_wynagrodzenia=p_id_typu_wynagrodzenia AND data_do IS NOT NULL AND data_od >= p_data_od AND data_do < p_data_do;
      IF v_sum4 IS NULL THEN v_sum4:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0)) INTO v_sum5 FROM wynagrodzenia WHERE id_typu_wynagrodzenia=p_id_typu_wynagrodzenia AND data_do IS NOT NULL AND data_od < p_data_od AND data_do > p_data_do;
      IF v_sum5 IS NULL THEN v_sum5:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, p_data_od),0)) INTO v_sum6 FROM wynagrodzenia WHERE id_typu_wynagrodzenia=p_id_typu_wynagrodzenia AND data_do IS NOT NULL AND data_od < p_data_od AND data_do < p_data_do;
      IF v_sum6 IS NULL THEN v_sum6:=0; END IF;
            
      RETURN v_sum1+v_sum2+v_sum3+v_sum4+v_sum5+v_sum6;
 
  WHEN p_pesel IS NOT NULL AND p_id_typu_wynagrodzenia IS NOT NULL THEN  
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0)) INTO v_sum1 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND (id_typu_wynagrodzenia=p_id_typu_wynagrodzenia) AND data_do IS NULL AND data_od >= p_data_od;
      IF v_sum1 IS NULL THEN v_sum1:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0)) INTO v_sum2 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND (id_typu_wynagrodzenia=p_id_typu_wynagrodzenia) AND data_do IS NULL AND data_od < p_data_od;
      IF v_sum2 IS NULL THEN v_sum2:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, data_od),0)) INTO v_sum3 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND (id_typu_wynagrodzenia=p_id_typu_wynagrodzenia) AND data_do IS NOT NULL AND data_od >= p_data_od AND data_do >= p_data_do;
      IF v_sum3 IS NULL THEN v_sum3:=0; END IF;
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, data_od),0)) INTO v_sum4 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND (id_typu_wynagrodzenia=p_id_typu_wynagrodzenia) AND data_do IS NOT NULL AND data_od >= p_data_od AND data_do < p_data_do;
      IF v_sum4 IS NULL THEN v_sum4:=0; END IF;
      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(p_data_do, p_data_od),0)) INTO v_sum5 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND (id_typu_wynagrodzenia=p_id_typu_wynagrodzenia) AND data_do IS NOT NULL AND data_od < p_data_od AND data_do > p_data_do;
      IF v_sum5 IS NULL THEN v_sum5:=0; END IF;      
      SELECT SUM(kwota*ROUND(MONTHS_BETWEEN(data_do, p_data_od),0)) INTO v_sum6 FROM wynagrodzenia WHERE id_pracownika IN (SELECT id_pracownika FROM wynagrodzenia WHERE id_pracownika IN (SELECT id FROM pracownicy WHERE pesel=p_pesel)) AND (id_typu_wynagrodzenia=p_id_typu_wynagrodzenia) AND data_do IS NOT NULL AND data_od < p_data_od AND data_do < p_data_do;
      IF v_sum6 IS NULL THEN v_sum6:=0; END IF;
      
      RETURN v_sum1+v_sum2+v_sum3+v_sum4+v_sum5+v_sum6;
END CASE;

END f_wynagrodzenia;



FUNCTION ilosc_aktywnych_pracownikow (p_data IN DATE) RETURN NUMBER IS
	v_aktywni_prac NUMBER(6);
	BEGIN
	
	SELECT count(id) INTO v_aktywni_prac
  FROM Pracownicy WHERE id IN (SELECT id_pracownika 
                                FROM wynagrodzenia
                                WHERE kwota > 0 AND ((p_data BETWEEN data_od AND data_do) OR (p_data >= data_od AND data_do IS NULL))
                                    MINUS
                                SELECT id
                                FROM pracownicy
                                WHERE (p_data < data_zatrudnienia) AND (p_data < data_zwolnienia OR data_zwolnienia IS NULL)
                                );        
  RETURN v_aktywni_prac;
END ilosc_aktywnych_pracownikow;



PROCEDURE dodaj_wynagrodzenie (p_data_od IN DATE, p_data_do IN DATE DEFAULT null, p_pesel IN VARCHAR2, p_id_typu_wynagrodzenia IN NUMBER, p_kwota IN NUMBER, p_czy_nadpisywac IN BOOLEAN DEFAULT FALSE) IS
	v_id NUMBER(5);
	v_data_zatr DATE;
	v_data_zw DATE;
	v_data_donn DATE;
	v_id_typu_wynagrodzenia NUMBER(5);
		
BEGIN

	SELECT DISTINCT id_pracownika INTO v_id
		FROM wynagrodzenia
		WHERE id_pracownika = (SELECT id
                  FROM Pracownicy
                  WHERE pesel=p_pesel);
	
	BEGIN
		SELECT data_zatrudnienia INTO v_data_zatr 
		FROM Pracownicy WHERE id=v_id;
		
		SELECT data_zwolnienia INTO v_data_zw
		FROM Pracownicy WHERE id=v_id;
		
			IF v_data_zw = NULL THEN v_data_zw:=current_date();  END IF;
			v_data_donn:=p_data_do;   --B2
			IF p_data_do = NULL THEN v_data_donn:=current_date(); END IF;			
			
			IF ((v_data_zatr <= v_data_donn) AND (v_data_zw >= p_data_od)) = FALSE THEN raise_application_error(-20001,'Pracownik musi pracowac choc jeden miesiac w podanym okresie dodawanego wynagrodzenia'); END IF;
	END;
  
    BEGIN
      SELECT id_typu_wynagrodzenia INTO v_id_typu_wynagrodzenia
      FROM wynagrodzenia
      WHERE id_pracownika=v_id AND id_typu_wynagrodzenia=p_id_typu_wynagrodzenia;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_id_typu_wynagrodzenia:=Null;
    END;

	CASE
	  WHEN p_czy_nadpisywac = TRUE THEN
      IF p_id_typu_wynagrodzenia = v_id_typu_wynagrodzenia THEN
        UPDATE Wynagrodzenia SET kwota=p_kwota, data_od=p_data_od, data_do=p_data_do WHERE id_pracownika=v_id AND id_typu_wynagrodzenia=p_id_typu_wynagrodzenia;
      ELSE
        INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia) VALUES (v_id, p_data_od, p_data_do, p_kwota, p_id_typu_wynagrodzenia);
      END IF;
      
	  WHEN p_czy_nadpisywac = FALSE THEN
	  	IF p_id_typu_wynagrodzenia = v_id_typu_wynagrodzenia THEN
        raise_application_error(-20001,'Istnieje juz taki typ wynagrodzenia w systemie dla tego uzytkownika.');
      ELSE
        INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia) VALUES (v_id, p_data_od, p_data_do, p_kwota, p_id_typu_wynagrodzenia);
      END IF;

	END CASE;
  
END dodaj_wynagrodzenie;


END pkg_prac;
/