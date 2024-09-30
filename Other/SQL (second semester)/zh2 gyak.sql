------------ 9. ora ------------

-- 1. Hozzunk letre egy tablat tulaj neven ilyen oszlopokkal:
-- azon: legfeljebb 5 jegyu egesz szam, tulajdonos azonositoja, elsodleges kulcsa
-- nev: egy legfeljebb 30 karakteres sztring, a tulajdonos neve, nem vehet fel NULL erteket;
-- szul_dat: datum tipusu, a tulajdonos szuletesi datuma;
-- szemelyiszam: egy pontosan 11 karakteres sztring, a tulajdonos szemelyiszama, a tabla kulcsa, nem vehet fel NULL erteket.
CREATE TABLE tulaj
(
    azon NUMBER(5),
    CONSTRAINT tul_pk PRIMARY KEY (azon),
    nev VARCHAR2(30 CHAR) NOT NULL,
    szul_dat DATE,
    szemelyiszam CHAR(11 CHAR) NOT NULL,
    CONSTRAINT tul_uq_szsz UNIQUE (szemelyiszam)  
);


-- ellenorizzuk a kulonbozo adatszotarnezetekben, mit alkottunk
SELECT * FROM user_tables;
SELECT * FROM user_tab_columns;
SELECT * FROM user_objects;
SELECT * FROM user_constraints;


-- masik forma: feltoltott tabla letrehozasa
-- az oszlopok nevet es tipusat is a SELECT hatarozza meg, megszoritas nem lesz
CREATE TABLE tag AS
    SELECT vezeteknev, keresztnev,  to_char(szuletesi_datum, 'yyyy.mm.dd') szd
        FROM konyvtar.tag;

-- 1.1 szurjunk be nehany sort a tablaba
INSERT INTO tulaj (azon, nev, szul_dat, szemelyiszam) VALUES (1, 'Joska', to_date('2001.01.01','yyyy.mm.dd'),'a');
UPDATE tulaj SET tulaj.szemelyiszam = 'aaaaa11111';

-- 1.2 adjunk alapertelmezett erteket a szuletesi datumnak a tulaj tablaban
ALTER TABLE tulaj
    MODIFY szul_dat DEFAULT sysdate;

-- 1.3 adjunk hozza egy temp oszlopot valtozo hosszusagi karakter tipussal
ALTER TABLE tulaj
    ADD temp VARCHAR2(20 CHAR);

-- 1.4 nevezzuk at a temp oszlopot felesleges-re
ALTER TABLE tulaj
    RENAME COLUMN temp TO felesleges;

-- 1.5 toroljuk a felesleges oszlopot
ALTER TABLE tulaj
    DROP COLUMN felesleges;

-- 1.6 nevezzuk at a tulaj tablat tulajdonos-ra
ALTER TABLE tulaj
    RENAME TO tulajdonos;

--vagy:
RENAME tulaj TO tulajdonos;

-- 1.7 toroljuk ki az osszes sort a tulajdonos tablabol
TRUNCATE TABLE tulajdonos;


-- 2. Hozzunk l�tre egy t�bl�t auto n�ven, amelyben aut�k adatait szeretn�nk t�rolni! 
-- A k�vetkez? oszlopok legyenek a t�bl�ban:
-- rendszam: egy legfeljebb 6 karakteres sztring, az aut� rendsz�ma, a t�bla els?dleges kulcsa;
-- szin: egy legfeljebb 10 karakteres sztring, az aut� sz�ne;
-- tulaj_azon: egy legfeljebb 5 jegy? eg�sz, az aut� tulajdonos�nak azonos�t�ja, a
--             t�bla k�ls? kulcsa, amely a tulaj t�bla els?dleges kulcs�ra hivatkozik;
-- ar: egy legfeljebb 8 �rt�kes jegyb?l �s 2 tizedesjegyb?l �ll� val�s sz�m, az aut� �ra,
--     amelynek 10000-n�l nagyobbnak kell lennie.
CREATE TABLE auto
(
    rendszam VARCHAR2(6 CHAR),
    CONSTRAINT au_pk PRIMARY KEY (rendszam),
    szin VARCHAR2(10 CHAR),
    tulaj_azon NUMBER(5),
    CONSTRAINT au_fk_tul FOREIGN KEY (tulaj_azon) REFERENCES tulaj,
    ar NUMBER(8,2),
    CONSTRAINT au_ch_ar CHECK (ar>10000)
);

-- 2.1 vegy�nk fel egy �j oszlopot az auto t�bl�ba tipus n�ven, amely az aut� t�pus�t
-- tartalmazza egy legfeljebb 20 karakteres sztringk�nt!
ALTER TABLE auto
    ADD tipus VARCHAR2(20 CHAR);

-- 2.2 n�velj�k meg az auto t�bla tipus oszlop�nak maxim�lis m�ret�t 50 karakterre!
ALTER TABLE auto
    MODIFY tipus VARCHAR2(50 CHAR);

-- 2.3 nevezz�k �t az auto t�bla tipus oszlop�t modell-re!
ALTER TABLE auto
    RENAME COLUMN tipus TO modell;

-- 2.4 nevezz�k �t az auto t�bla au_ch_ar nev? megszor�t�s�t au_check_ar-ra!
ALTER TABLE auto
    RENAME CONSTRAINT au_ch_ar TO au_check_ar;

-- 2.5 T�r�lj�k az auto t�bla au_check_ar nev? megszor�t�s�t!
ALTER TABLE auto
    DROP CONSTRAINT au_check_ar;

-- 2.6 adjuk hozz� �jra az auto t�bl�hoz a kor�bban defini�lt au_ch_ar megszor�t�st!
ALTER TABLE auto
    ADD CONSTRAINT au_ch_ar CHECK (ar>10000);

-- 2.7 t�r�lj�k az auto t�bla modell oszlop�t!
ALTER TABLE auto
    DROP COLUMN modell;

-- 2.8 Nevezz�k �t az auto t�bl�t kocsi-ra!
RENAME auto TO kocsi;

-- 2.9 szurjunk be nehany sort a tablaba
INSERT INTO kocsi VALUES ('abc123', 'fekete', 100, 20000); -- rossz FK
INSERT INTO kocsi VALUES ('abc245', 'feher', 1, 20000);
INSERT INTO kocsi VALUES ('aasd23', 'piros', 2, 20000);

-- 2.10 probalgassuk ki az egyes joinokat


-- 2.11 toroljuk az eddigi ket tablainkat
DROP TABLE tulaj PURGE;
DROP TABLE auto PURGE;


-- 3. Hozzunk letre egy webuser tablat, ahol a webappunk felhasznaloit szeretnenk tarolni!
-- Kovetkezo oszlopokat adjuk meg:
-- userid: 5 hosszu egesz szam, elsodleges kulcs
-- nev: max 255 hosszu sztring, kotelezo
-- szul_dat: datum
-- jelszo: max 255 hosszu sztring, kezdodjon # karakterrel
CREATE TABLE webuser
(
    userid NUMBER(5) PRIMARY KEY,
    nev VARCHAR2(225 CHAR) NOT NULL,
    szul_dat DATE,
    jelszo VARCHAR2(255 CHAR) CHECK (SUBSTR(jelszo,1,1) = '#')
);

-- 3.1 szurjunk be nehany sort
INSERT ALL 
    INTO webuser VALUES (1, 'John Doe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), '#password123')
    INTO webuser VALUES (2, 'Jane Smith', TO_DATE('1985-09-28', 'YYYY-MM-DD'), '#user456')
    INTO webuser VALUES (3, 'Alice Lee', TO_DATE('1988-12-10', 'YYYY-MM-DD'), '#secretword')
    INTO webuser VALUES (4, 'Bob Brown', TO_DATE('1995-03-20', 'YYYY-MM-DD'), '#pass123')
    INTO webuser VALUES (5, 'Emma Davis', TO_DATE('1992-07-08', 'YYYY-MM-DD'), '#123abc')
SELECT * FROM dual;


-- 3.2 Hozzunk letre egy event tablat, ahol az esemenyeinket taroljuk!
-- Kovetkezo oszlopokat adjuk meg:
-- eventid: 5 hosszu egesz szam, elsodleges kulcs
-- nev: max 255 hosszu sztring, kotelezo
-- dat: datum
-- helyszin: max 255 hosszu sztring
CREATE TABLE event (
    eventid NUMBER(5) PRIMARY KEY,
    nev VARCHAR2(255) NOT NULL,
    dat DATE,
    helyszin VARCHAR2(255)
);

-- 3.3 szurjunk be nehany sort
INSERT ALL 
    INTO event (eventid, nev, dat, helyszin) VALUES (1, 'Konferencia', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'Konferencia K�zpont')
    INTO event (eventid, nev, dat, helyszin) VALUES (2, 'Workshop', TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'TechPark')
    INTO event (eventid, nev, dat, helyszin) VALUES (3, 'Tr�ning', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Training Center')
    INTO event (eventid, nev, dat, helyszin) VALUES (4, 'F�rum', TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'F�rum H�z')
    INTO event (eventid, nev, dat, helyszin) VALUES (5, 'Verseny', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 'Sport Ar�na')
SELECT * FROM dual;


-- 3.4 kapcsoljuk ossze a webuser es event tablat
CREATE TABLE user_event
(
    user_id NUMBER(5),
    event_id NUMBER(5),
    PRIMARY KEY (user_id,event_id),
    FOREIGN KEY (user_id) REFERENCES webuser(user_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);

-- 3.5 adjunk egy oszlopot az osszekapcsolo tablahoz, ami a jelentkezes
-- statuszat jelzi es csak j/f/v ertekeket vehet fel
ALTER TABLE user_event
    ADD status CHAR(1 CHAR) CHECK (status IN ('j', 'f', 'v'));


--------------- 10.ora ---------------

-- sajat tabla + semabol -> zoo
-- ZOO sema alapjan: https://elearning.unideb.hu/pluginfile.php/8083/mod_resource/content/6/zoo_tables.png

-- 1. hozzuk letre adatokkal egyutt a fajok tablat a semanak megfeleloen
CREATE TABLE fajok
    AS SELECT * FROM zoo.zoo_fajok;


-- 2. nezzuk meg milyen megszoritasok vannak a semaban
SELECT * FROM all_constraints WHERE table_name = 'ZOO_FAJOK';

-- 3. nezzuk meg milyen megszoritasok vannak a sajat fajok tablankon
SELECT SELECT * FROM all_constraints WHERE table_name = 'FAJOK';

-- 4. tegyunk egy PK megszoritas a fajok tablankra
ALTER TABLE fajok
    ADD CONSTRAINT fajok_pk PRIMARY KEY (faj_azon);

-- 5. nezzuk meg az osszes 'fajok' sztringet tartalmazo
--    tablaban a megszoritasokat
SELECT * FROM all_constraints WHERE table_name LIKE '%FAJOK%';

-- 6. milyen fajok elnek NEM Magyarorszagon?
SELECT * FROM fajok
    WHERE szarmazasi_hely NOT IN 'Magyarorsz�g';

-- 7. toroljuk ki ezeket a NEM nalunk honos fajokat!
--    (probaljuk ki a tranzakciokezelest is)
COMMIT;
DELETE FROM fajok
    WHERE szarmazasi_hely NOT IN 'Magyarorsz�g';
COMMIT;


-- 8. hozzuk letre az allatok tablat, magunktol adatok nelkul
CREATE TABLE allatok
(
    allat_azon NUMBER(5),
    faj_azon NUMBER(5),
    allat_nev VARCHAR2(50 CHAR),
    nem VARCHAR2 (1 CHAR),
    szul_dat DATE,
    erkezesi_hely VARCHAR2(50 CHAR),
    erkezesi_dat DATE,
    erkezesi_mag NUMBER(5),
    erkezesi_suly NUMBER(5),
        CONSTRAINT allatok_pk PRIMARY KEY (allat_azon),
        CONSTRAINT allatok_fk FOREIGN KEY (faj_azon)
            REFERENCES fajok (faj_azon)
);

-- 9. adjunk hozza egy megszoritast, hogy az erkezesi datum
--    legalabb a szuletesi datum legyen
ALTER TABLE allatok
    ADD CONSTRAINT erk_szul_dat CHECK (erkezesi_dat>=szul_dat);

-- 9. adjunk hozza egy megszoritast, hogy az allat
--    neve nem lehet NULL ertek
ALTER TABLE allatok
    ADD CONSTRAINT allat_nev_not_null CHECK (allat_nev IS NOT NULL);

-- 10. szurjunk be ertekeket az allat tablankba ugy,
--     hogy csak a kotelezoket adjuk meg
INSERT INTO allatok (allat_azon, allat_nev) 
  VALUES (1, 'J�nos');

-- 11. szurjunk be ertekeket az allat tablankba ugy,
--     hogy az osszes oszlophoz irunk valamit
INSERT INTO allatok 
  VALUES (2, 15,'Kolb�sz', 'h', date'2020-04-23', 'P�cs', date'2020-05-23', 20, 3);
INSERT INTO allatok 
  VALUES (3, 14,'Eper', 'n', date'2020-04-23', 'P�cs', date'2020-05-23', 20, 3);
INSERT INTO allatok 
  VALUES (4, 15,'Szulejm�n', 'h', date'2020-04-23', 'Debrecen', date'2020-05-23', 20, 3);

-- 12. toltsuk ki a nem teljes rekordunkat ertekekkel
--     (+ savepoint jatszas)
UPDATE allatok
    SET faj_azon = 19
    WHERE allat_azon = 1;
    
SAVEPOINT p1;

UPDATE allatok 
    SET nem = 'h', 
        szul_dat = sysdate, erkezesi_hely = 'Debrecen', 
        erkezesi_dat = sysdate, erkezesi_mag = 15, erkezesi_suly = 2;
        
SELECT * FROM allatok;
ROLLBACK TO p1;

UPDATE allatok 
    SET nem = 'h', 
        szul_dat = sysdate, erkezesi_hely = 'Debrecen', 
        erkezesi_dat = sysdate, erkezesi_mag = 15, erkezesi_suly = 2
    WHERE allat_azon = 1;
    
SELECT * FROM allatok;


-- 13. hozzuk letre az ellenorzes tablat, adatok nelkul a sema alapjan
--     a nem kotelezo sorokhoz adjunk meg alapertelmezett erteket!
CREATE TABLE ELLENORZES
   (	
    ALLAT_AZON NUMBER(5), 
	  ELL_DAT DATE,
	  ELL_MAG NUMBER(3) DEFAULT 0,
	  ELL_HOSSZ NUMBER(3) DEFAULT 0,
	  ELL_SULY NUMBER(4) DEFAULT 0,
	  ELL_EGESZSEG VARCHAR2(1) DEFAULT '-', 
	  CONSTRAINT ELL_PK PRIMARY KEY (ALLAT_AZON,ELL_DAT),
  	CONSTRAINT ELL_FK FOREIGN KEY (ALLAT_AZON)
		REFERENCES ALLATOK (ALLAT_AZON));

-- 14. nevezzuk at az ellenorzes tablat ellenorzesekre      
RENAME ellenorzes TO ellenorzesek;

-- 15. szurjunk be ertekeket az ellenorzesek tablankba ugy,
--     hogy beagyazott select-eket hasznalunk:
--     legnagyobb azonositoval rendelkezo allat nehany adatat
INSERT INTO ellenorzesek (allat_azon, ell_dat, ell_suly) 
    VALUES
    (
    (SELECT MAX(allat_azon) FROM allatok),
    sysdate,
    (SELECT erkezesi_suly + 3 FROM allatok
        WHERE allat_azon = (SELECT MAX(allat_azon) FROM allatok))
    );

SELECT * FROM ellenorzesek;
-- 16. szurjunk be ertekeket az ellenorzesek tablankba ugy,
--     hogy egy masik lekerdezest hasznalunk:
--     csak azokat az allatokat, akik meg nem voltak ellenorzesen
--     legyen mindegyik ilyen allat egy kicsivel sulyosabb de egeszseges
INSERT INTO ellenorzesek
    SELECT allat_azon, sysdate, erkezesi_mag, erkezesi_mag * 2, erkezesi_suly + 2, '+' -- nvl
    FROM allatok
    WHERE allat_azon 
        NOT IN (SELECT allat_azon FROM ellenorzesek);

-- 17. toroljuk az ertekeket az ellenorzesek tablabol tobb modon is!
--     (melyikeket lehet visszavonni?)
SELECT * FROM ellenorzesek;

COMMIT;
DELETE FROM ellenorzesek;
ROLLBACK;
SELECT * FROM ellenorzesek;

COMMIT;
TRUNCATE TABLE ellenorzesek;
ROLLBACK;
SELECT * FROM ellenorzesek;

-- 18. modositsuk ugy az ellenorzesek tablat, hogy azoknal a soroknal,
--     ahol null ertek a suly, magassag vagy hossz, az egeszsegnel egy 
--     '?' karakter jelenjen meg
UPDATE ellenorzesek SET ell_egeszseg = '?'
    WHERE ell_mag IS NULL OR ell_hossz IS NULL OR ell_suly IS NULL;

-- 19. kapcsoljuk ossze a tablakat es nezzunk ra az adatokra
--     milyen fajokba tartoznak az egyes allataink?


-- 20. kapcsoljuk ossze a tablakat es nezzunk ra az adatokra
--     milyen fajokbol nem szerepelnek allatok az adatbazisunkban?


-- 21. kapcsoljuk ossze a tablakat es nezzunk ra az adatokra
--     egyes allataink hanyszor voltak ellenorzesen?


-------------- 10. ora feladatok --------------

/*1. 
Hozzunk l�tre t�bl�t szemely n�ven a k�vetkez? oszlopokkal:
azon: max. 5 sz�mjegy? eg�sz sz�m,
nev: maximum 30 hossz� v�ltoz� hossz�s�g� karaktersorozat, amelyet ki kell t�lteni,
szul_dat: d�tum t�pus�,
irsz: pontosan 4 karakter hossz� sztring,
cim: maximum 40 hossz� v�ltoz� hossz�s�g� karaktersorozat,
zsebpenz: sz�m, amelynek maximum 12 sz�mjegye lehet, amelyb?l az utols� kett? a tizedesvessz? ut�n �ll.
A t�bla els?dleges kulcsa az azon oszlop legyen. A nev, szul_dat, cim egy�tt legyen egyedi. A zsebpenz, ha ki van t�ltve, legyen nagyobb, mint 100.
*/



--2. Sz�rjunk be a szemely t�bl�ba h�rom sort.


/*
3. Hozzunk l�tre t�bl�t bicikli n�ven a k�vetkez? oszlopokkal:
azon: max. 5 sz�mjegy? eg�sz sz�m,
szin: maximum 20 hossz� v�ltoz� hossz�s�g� karaktersorozat,
tulaj_azon: max. 5 sz�mjegy? eg�sz sz�m.
A t�bla els?dleges kulcsa az azon oszlop legyen. A tulaj_azon hivatkozzon a szem�ly t�bla els?dleges kulcs�ra.
*/



--4. Sz�rjunk be h�rom sort a bicikli t�bl�ba!


--5. List�zzuk ki a szem�lyek biciklijeit. A lista tartalmazza azokat a szem�lyeket is, 
-- akiknek nincs biciklij�k, �s azokat a bicikliket is, amelyeknek nincs tulajdonosuk.
-- tipp: full outer join


--6. Hozzunk l�tre t�bl�t eldobom n�ven egy nev nev? oszloppal, amely maximum 30 hossz� v�ltoz� hossz�s�g� karaktersorozat t�pus�.


--7. Dobjuk el az eldobom t�bl�t!


--8. T�r�lj�k a piros sz�n? bicikliket!


--9. M�dos�tsuk a bicikli t�bla sz�n oszlop�ban l�v? �rt�ket: f?zz�nk hozz� egy '2'-es karaktert, ann�l a sorn�l,
--   ahol az azon �rt�ke 200!


--10. Adjuk a bicikli t�bl�hoz �j oszlopot tipus n�vvel �s maximum 30 hossz� v�ltoz� hossz�s�g� karaktersorozattal.


--11. Dobjuk el a bicikli t�bla tipus oszlop�t!


--12. Nevezz�k �t a bicikli t�bla tulaj_azon oszlop�t t_azon-ra.


--13. M�dos�tsuk a bicikli t�bla sz�n oszlop�nak t�pus�t varchar2(30)-ra!


--14. Nevezz�k �t a szem�ly t�bla cs_ch nev? megszor�t�s�t sz_ck-ra!


--15. Nevezz�k �t a szem�ly t�bl�t szemely2-re.


--16. Dobjuk el a sz_uq nev? megszor�t�st a szem�ly2 t�bl�r�l.


--17. Adjunk megszor�t�st a szem�ly2 t�bl�hoz: a n�v, sz�let�si d�tum �s a c�m egy�tt legyen egyedi.


--18. Dobjuk el a bicikli t�bla els?dleges kulcs�t!


--19. Legyen az azon oszlop a bicikli t�bla els?dleges kulcsa!


--20. Hozzunk l�tre t�bl�t, amely azt tartalmazza, hogy melyik szerz? milyen c�m? k�nyveket �rt.
--    A t�bla tartalmazza a k�nyvek oldalank�nti �r�t is.


--21. Hozzunk l�tre n�zetet v_szerzo_konyv n�ven, amelyben azt list�zzuk, hogy az egyes k�nyveknek kik a szerz?i. 
-- A lista csak azokat a k�nyveket tartalmazza, amelyeknek van szerz?je. A lista tartalmazza a k�nyvek oldalank�nti �r�t is.


--22. Hozzunk l�tre n�zetet, amely a horror, sci-fi, krimi t�m�j� k�nyvek c�m�t, lelt�ri sz�m�t �s oldalank�nti �r�t list�zza.


--23. Hozzunk l�tre n�zetet legidosebb_szerzo n�ven, amely a legid?sebb szerz? nev�t �s sz�let�si d�tum�t list�zza.

---------  EXISTS, ALL, ANY ---------

-- 4. Keress�k azokat a tagokat, akik a Nap�leon c�mu konyv irojaval/irojaival
--    azonos honapban szulettek. 
-- (EXISTS)
SELECT *
FROM konyvtar.tag ta
WHERE EXISTS (SELECT 1
    FROM konyvtar.konyv k JOIN konyvtar.konyvszerzo ksz 
            ON k.konyv_azon = ksz.konyv_azon
        JOIN konyvtar.szerzo sz ON ksz.szerzo_azon = sz.szerzo_azon    
    WHERE cim = 'Nap�leon' 
        AND extract(month from ta.szuletesi_datum) 
            = extract(month from sz.szuletesi_datum)
);

-- 5. Listazzuk ki azoknak a szerzoknek a teljes nevet, azonositojat 
--    es szuletesi datumant, akik
--    1900 utan szulettek es ugyanannyi honorariumot kaptak egy konyvukert, 
--    mint b�rmelyik legfeljebb 1900-ban sz�letett szerzo kapott akarmelyik konyveert! 

SELECT szk.szerzo_azon, konyv_azon, vezeteknev, keresztnev, honorarium, to_char(szuletesi_datum, 'DS TS')
FROM konyvtar.szerzo szk JOIN konyvtar.konyvszerzo kszk 
    ON szk.szerzo_azon = kszk.szerzo_azon
    WHERE honorarium = ANY (
    SELECT honorarium
        FROM konyvtar.szerzo sz JOIN konyvtar.konyvszerzo ksz 
        ON sz.szerzo_azon = ksz.szerzo_azon
    WHERE extract(year from szuletesi_datum) <= 1900
    )
    AND extract(year from szuletesi_datum) > 1900;

-- 6. Listazzuk ki azoknak a szerzoknek a teljes nevet, azonositojat 
--    es szuletesi datumant, akik
--    1900 utan szulettek es tobb honorariumot kaptak egy konyvukert, 
--    mint mindegyik legfeljebb 1900-ban sz�letett szerzo kapott akarmelyik konyveert! 

SELECT szk.szerzo_azon, konyv_azon, vezeteknev, keresztnev, honorarium, to_char(szuletesi_datum, 'DS TS')
FROM konyvtar.szerzo szk JOIN konyvtar.konyvszerzo kszk 
    ON szk.szerzo_azon = kszk.szerzo_azon
    WHERE honorarium > ALL (
    SELECT honorarium
        FROM konyvtar.szerzo sz JOIN konyvtar.konyvszerzo ksz 
        ON sz.szerzo_azon = ksz.szerzo_azon
    WHERE extract(year from szuletesi_datum) <= 1900
    )
    AND extract(year from szuletesi_datum) > 1900;

