INSERT INTO Miasta (nazwa, kod_pocztowy) VALUES ('Warszawa', '00-001');
INSERT INTO Miasta (nazwa, kod_pocztowy) VALUES ('Bydgoszcz', '85-100');
INSERT INTO Miasta (nazwa, kod_pocztowy) VALUES ('Gdynia', '80-100');
INSERT INTO Miasta (nazwa, kod_pocztowy) VALUES ('Katowice', '40-100');

INSERT INTO typy_wynagrodzen (nazwa) VALUES ('zasadnicze');
INSERT INTO typy_wynagrodzen (nazwa) VALUES ('premia');
INSERT INTO typy_wynagrodzen (nazwa) VALUES ('dodatek');
INSERT INTO typy_wynagrodzen (nazwa) VALUES ('nadgodziny');

INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Jan', 'Kowalski', '60010478651', 'M', '1960-01-04', 1 ,'2017-01-01', '2018-05-31');
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Adrian', 'Nowak', '91051895697', 'M', '1991-05-18', 2 ,'2017-02-01', null);
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Krzysztof', 'Kownacki', '73052155394', 'M', '1973-05-21', 2 ,'2016-06-01', null);
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Sylwia', 'Machnicka', '72021111856', 'K', '1972-02-11', 3 ,'2017-05-01', '2018-02-28');
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Joanna', 'Cichocka', '83060633263', 'K', '1983-06-06', 4 ,'2017-02-01', null);
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Adam', 'Walenda', '60090428852', 'M', '1960-09-04', 1 ,'2016-08-01', null);
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Marek', 'Wysocki', '65110919374', 'M', '1965-11-09', 2, '2017-09-01', '2018-07-31');
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Anna', 'Kidyba', '88022983558', 'K', '1988-02-29', 1 ,'2018-01-01', null);
INSERT INTO Pracownicy (imie, nazwisko, pesel, plec, data_urodzenia, id_miasta, data_zatrudnienia, data_zwolnienia) VALUES ('Cezary', 'Naworski', '81042991798', 'M', null, 1 ,'2018-04-01', null);


INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (1, '2017-01-01', '2018-05-31', 3000, 1, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (1, '2017-03-01', '2017-04-30', 1000, 2, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (1, '2017-05-01', '2017-05-31', 200, 4, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (2, '2017-02-01', '2019-06-30', 4000, 1, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (3, '2016-06-01', '2019-04-30', 3000, 1, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (3, '2017-01-01', '2017-01-31', 800, 2, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (3, '2018-01-01', '2018-01-31', 200, 3, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (4, '2017-05-01', '2018-02-28', 3500, 1, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (4, '2017-09-01', '2018-01-31', 1000, 4, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (5, '2017-02-01', '2018-01-31', 5000, 1, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (5, '2018-06-01', '2018-07-31', 300, 4, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (5, '2017-01-01', '2018-01-31', 500, 4, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (6, '2016-08-01', '2019-05-31', 3000, 1, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (7, '2017-09-01', '2018-02-28', 4500, 1, null);
INSERT INTO Wynagrodzenia (id_pracownika, data_od, data_do, kwota, id_typu_wynagrodzenia, uwagi) VALUES (8, '2018-01-01', '2019-10-31', 3200, 1, null);