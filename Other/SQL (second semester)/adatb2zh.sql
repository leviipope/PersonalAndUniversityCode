--select feladatok from buvesz :*
--1
--List�zza ki az �gyfelek azonos�t�j�t, teljes nev�t, valamint a megrendel�seik azonos�t�j�t! Azok az �gyfelek is szerepeljenek az eredm�nyben,
--akik soha nem adtak le megrendel�seket. A lista legyen vezet�kn�v, azon bel�l megrendel�s azonos�t�ja szerint rendezve
SELECT ugyfel_id, vezeteknev || ' ' || keresztnev, megrendeles_id
FROM HAJO.s_ugyfel u LEFT JOIN HAJO.s_megrendeles m
    ON  u.ugyfel_id = m.ugyfel
ORDER BY vezeteknev, megrendeles_id;

--2.
--List�zza ki a haj�t�pusok azonos�t�j�t �s nev�t, valamint az adott t�pus� haj�k azonos�t�j�t �s nev�t! A haj�t�pusok nev�t tartalmaz� oszlop
--'t�pusn�v', a haj�k nev�t tartalmaz� oszlop pedig 'haj�n�v' legyen! Azok a haj�t�pusok is jelenjenek meg, amelyhez egyetlen haj� sem tartzoik.
--A lista legyen a haj�t�pus neve, azon bel�l a haj� neve alapj�n rendezve.
SELECT hajo_tipus_id,ht.nev t�pusn�v, hajo_id, h.nev haj�n�v 
FROM HAJO.s_hajo_tipus ht LEFT JOIN HAJO.s_hajo h
    ON ht.hajo_tipus_id = h.hajo_tipus;


--5.
--List�zza ki Magyarorsz�g�n�l kisebb lakoss�ggal rendelkez? orsz�gok nev�t, lakoss�g�t, valamint a f?v�rosuk nev�t. Azokat az orsz�gokat is
--list�zza, amelyeknek nem ismerj�k a f?v�ros�t. Ezen orsz�gok eset�ben a f?v�ros hely�n "nem ismert" sztring szerepeljen. Rendezze az orsz�gokat
--a lakoss�g szerint cs�kken? sorrendben.
SELECT o.orszag, o.lakossag, nvl(helysegnev,'nem ismert')
FROM HAJO.s_orszag o LEFT JOIN HAJO.s_helyseg h
    ON o.fovaros = h.helyseg_id
WHERE (o.lakossag<(SELECT lakossag
                 FROM HAJO.s_orszag
                 WHERE orszag ='Magyarorsz�g'))
ORDER BY o.lakossag DESC;
    

--6 
--List�zza ki azoknak az �gyfeleknek az azonos�t�j�t �s teljes nev�t,
--akik adtak m�r fel olasz- orsz�gi kik�t?b?l indul� sz�ll�t�sra vonatkoz� megrendel�st! 
--Egy �gyf�l csak egyszer szere- peljen az eredm�nyben!
SELECT ugyfel_id, (vezeteknev || ' ' || keresztnev) teljesnev
FROM HAJO.s_ugyfel u JOIN HAJO.s_megrendeles m
    ON u.ugyfel_id = m.ugyfel
WHERE m.indulasi_kikoto LIKE 'It_%'
GROUP BY ugyfel_id, vezeteknev, keresztnev;

--7
--List�zza ki azoknak a haj�knak az azonos�t�j�t �s nev�t, amelyek egyetlen �t c�l�llom�sak�nt sem k�t�ttek ki francia kik�t?kben
SELECT hajo_id, nev
FROM HAJO.s_hajo h JOIN HAJO.s_ut u
    ON h.hajo_id = u.hajo
WHERE hajo_id NOT IN (SELECT hajo_id
                        FROM HAJO.s_hajo h JOIN HAJO.s_ut u
                            ON h.hajo_id = u.hajo
                        WHERE erkezesi_kikoto LIKE 'Fra_%')
GROUP BY hajo_id, nev;


--8.
--List�zza ki azoknak a helys�geknek az azonos�t�j�t, orsz�g�t �s nev�t, amelyeknek valamelyik kik�t?j�b?l
--indult m�r �tra az SC Bella nev? haj�! Egy helys�g csak egyszer szerepeljen



--9.
--List�zza ki azokat a mmegrendel�seket (azonos�t�) amelyek�rt t�bbet fizettek, mint a 2021. �prilis�ban leadott megrendel�sek
--B�rmelyik��rt. A fizetett �sszeget is t�ntesse fel!



--11
--List�zza ki azoknak a haj�knak a nev�t, a maxim�lis s�lyterhel�s�t, valamint a tipus�nak a nev�t, amely egyetlen utat sem teljes�tett.
--A haj� nev�t megad� oszlop neve a 'haj�n�v' a tipusnev�t a 'tipusn�v'.

--12.
--List�zza ki azoknak az �gyfeleknek a teljes nev�t �s sz�rmaz�si orsz�g�t, akiknek nincs 1milli�n�l nagyobb �rt�k? rendel�se!
--Azok is szerepeljenek, akiknek nem ismerj�k a sz�rmaz�s�t. Rendezze az eredm�nyt vezet�kn�v, azon bel�l keresztn�v szerint


--13
--List�zza ki �b�c�rendben azoknak a kik�t?knek az azonos�t�j�t, amelyekbe vagy teljes�tett egy utat az It_Cat azonos�t�j� kik�t?b?l, vagy c�lpontja egy, az It_Cat
--azonos�t�j? kik�t?j? megrendel�snek!


--14.
--List�zza ki �b�c�rendben azoknak a kik�t?knek az azonos�t�j�t, melyekbe legal�bb egy haj� teljes�tett utat
--Az 'It_Cat' azonos�t�j� kik�t?b?l �s c�lpontja legal�bb egy, az 'It_Cat' kik�t?b?l indul� megrendel�snek. A kik�t? csak egyszer
--Szerepeljen a lek�rdez�sben.


--15. 
--List�zza ki �b�c�rendben azoknak a helys�geknek az azonos�t�j�t, orsz�g�t �s nev�t, ahonnan sz�rmaznak �gyfeleink, vagy ahol vannak kik�t?k!
--Egy helys�g csak egyszer szerepeljen az eredm�nyben! A lista legyen orsz�gn�v, azon bel�l helys�gn�v szerint rendezett.


--16
--List�zza ki �b�c�rendben azoknak a kik�t?vel rendelkez? helys�geknek az azonos�t�j�t,
--orsz�g�t �s nev�t, ahonnan legal�bb egy �gyfel�nk is sz�rmazik! 
--Egy helys�g csak egyszer szerepeljen az eredm�nyben! 
--A lista legyen orsz�gn�v, azon bel�l helys�gn�v szerint rendezve!

--19.
--List�zza ki n�vekv? sorrendben azoknak a megrendel�seknek az azonos�t�j�t, amelyek�rt legal�bb k�tmilli�t fizetett
--Egy Yiorgos keresztnev? �gyf�l, �s m�g nem t�rt�nt meg a sz�ll�t�suk

--20
--List�zza ki azoknak a helys�geknek az azonos�t�j�t, 
--orsz�g�t �s nev�t, amelyek lakoss�ga meghaladja az egymilli� f?t, �s azok�t is, 
--ahonnan sz�rmazik 50 �vesn�l id?sebb �gyfel�nk! 
--Egy helys�g csak egyszer szerepeljen az eredm�nyben! A lista legyen orsz�gn�v, azon bel�l helys�gn�v szerint rendezve!

--22.
--Melyik h�rom orsz�g kik�t?j�b?l indul� sz�ll�t�sokra adt�k le a legt�bb megrendel�st?
--Az orsz�gnevek mellett t�ntesse fel az onnan indul� megrendel�sek sz�m�t is

--25
--List�zza ki a t�z legt�bb ig�nyelt kont�nert tartalmaz� megrendel�st lead� �gyf�l teljes nev�t, 
--a megrendel�s azonos�t�j�t �s az ig�nyelt kont�nerek sz�m�t!

--26
--Adja meg az SC Nina nev? haj�val megtett 3 leghosszabb ideig tart� �t indul�si �s �rkez�si kik�t?j�nek az azonos�t�j�t.


--27
--Adja meg a h�rom legt�bb utat teljes�t? haj� nev�t! A haj�k neve mellett t�ntesse fel az �ltaluk teljes�tett utak sz�m�t is


--28
-- Az 'It Cat' azonos�t�j� kik�t?b?l indul� utak k�z�l melyik n�gyen sz�ll�tott�k a legkevesebb kont�nert?
--Csak azokat az utakat vegye figyelembe, amelyeken legal�bb egy kont�nert sz�ll�tottak!
--Az utakat az azonos�t�jukkal adja meg, �s t�ntesse fel a sz�ll�tott kont�nerek sz�m�t is!!

--29
--Adja meg a n�gy legt�bb rendel�st lead� teljes nev�t �s a megrendel�sek sz�m�t


--31.
--Hozzon l�tre egy s_szemelyzet nevu tablat, amelyben a haj�kon dolgoz� szem�lyzet adatai tal�lhat�ak. Minden szerel?nek van azonos�t�ja
--Pontosan 10 karakteres sztring. Ez az els?dleges kulcs is. Vezet�k �s keresztneve mindkett? 50-50 karakteres sztring. Sz�let�si d�tuma, egy telefonsz�ma
--(20 jegy? eg�sz sz�m). �s hogy melyik haj� szem�lyzet�hez tartozik (max 10 karakteres sztring), �s ezt egy hivatkoz�ssal az s_haj� t�bl�ra hozzuk l�tre.
--A telefonsz�mot legyen k�telez? megadni. Minden megszor�t�st nevezzen el
CREATE TABLE s_szemlyzet(
    azon CHAR(10 CHAR),
    CONSTRAINT sz_pk PRIMARY KEY(azon),
    vezeteknev VARCHAR2(50 CHAR),
    keresztnev VARCHAR2(50 CHAR),
    szul_dat DATE,
    telefonszam NUMBER(20) NOT NULL,
    hajo VARCHAR2(10 CHAR),
    CONSTRAINT sz_fk FOREIGN KEY(hajo) REFERENCES HAJO.s_hajo(hajo_id)
);

--32
--Hozzon l�tre egy s_szem�lyzet nev? t�bl�t, amelyben a haj�kon dolgoz� szem�lyzet adatai tal�lhat�ak!
create table s_szemelyzet(
--Minden szerel?nek van azonos�t�ja, maximum �t jegy? eg�sz sz�m, ez az els?dleges kulcs
    azon number(5),
--vezet�k �s keresztneve, mindkett? maximum negyven karakteres sztring
    vezeteknev varchar2(40),
    keresztnev varchar2(40),
    --sz�let�si d�tuma
    szul_dat date,
    --e-mail c�me (maximum 200 karakteres string)
    email_cim varchar2(200),
    --hogy melyik haj� szem�lyzet�hez tartozik (maximum 10 karakteres sztring), hivatkoz�ssal az s_haj� t�bl�ra
    hajo_id varchar2(10),
    constraint pk_szemelyzet primary key(azon),
    constraint fk_szemelyzet foreign key(hajo_id) references s_hajo(hajo_id),
    constraint uq_szemelyzet unique(vezeteknev, keresztnev, szul_dat)
);

--33
--Hozzon l�tre egy 's_kikoto_email' nev? t�bl�t, amelyben a kik�t?k e-mail c�m�t t�roljuk! Legyen benne egy kikoto_id nev? oszlop
--(maximum 10 karakteres string), amely hivatkozik az s_kikoto t�bl�ra.
--Valamint egy email c�m, ami egy maximum 200 karakteres string!
--Egy kik�t?nek t�bb email c�me lehet, ez�rt a t�bla els?dleges kulcs�t a k�t oszlop egy�ttesen alkossa!
--Minden megszor�t�st nevezzen el!
CREATE TABLE s_kikoto_email(
    kikoto_id_nev VARCHAR2(10 CHAR),
    email VARCHAR2(200 CHAR),
    CONSTRAINT pk_kikoto_email PRIMARY KEY (kikoto_id_nev,email),
    CONSTRAINT fk_kikoto_email FOREIGN KEY(kikoto_id_nev) REFERENCES s_kikoto(kikoto_id)
);

--35.
--Hozzon l�tre egy s_hajo_javitas t�bl�t, ami a haj�k jav�t�si adatait tartalmazza! Legyen benne a jav�tott haj� azonos�t�ja, amely az s_haj� t�bl�ra hivatkozik, legfeljebb
--10 karakter hossz� sztring �s ne legyen null. Jav�t�s kezdete �s v�ge_ d�rumok. Jav�t�s �ra: egy legfeljebb 10 jegy? val�s sz�m, k�t tizedesjeggyel, valamint a hiba
--le�r�sa, 200 karakteres sztring (legfeljebb).
--A t�bla els?dleges kulcsa �s a jav�t�s kezd?d�tuma els?dlegesen alkossa. Tov�bbi megk�t�s, hogy a jav�t�s v�ge csak a jav�t�s kezdete
--n�l k�s?bbi d�tum lehet.


--43
--T�r�lje az s_hajo �s az s_hajo tipus t�bl�kat! Vegye figyelembe az egyes t�bl�kra hivatkoz� k�ls? kulcsokat.
DROP TABLE s_hajo CASCADE CONSTRAINTS;
DROP TABLE s_hajo_tipus CASCADE CONSTRAINTS;
--42
-- A helys�gek lakoss�gi adata nem fontos sz�munkra.
--T�r�lje az 's_helyseg' t�bla 'lakossag' oszlop�t! 
ALTER TABLE s_helyseg
DROP COLUMN lakossag;

--44
--T�r�lje az 's_kikoto_telefon' t�bla els?dleges kulcs megszor�t�s�t!
ALTER TABLE s_kikoto_telefon
DROP CONSTRAINT skt_pk;

--49.
--az s_kik�t? telefon t�bl�t egy email nev?, amx 200 karakter hossz� sztringel, melyben alap�rtelmezetten a 'nem ismert' sztring legyen
CREATE TABLE s_kikoto(
    email VARCHAR2(200 CHAR) DEFAULT('nem ismert')
);

--50.
--M�dos�tsa az s_ugyfel t�bla email oszlop�nak maxim�lis hossz�t 50 karakterre, az utca_hsz oszlop hossz�t pedig 100 karakterre!
ALTER TABLE s_ugyfel
MODIFY COLUMN email VARCHAR2(50 CHAR)
MODIFY COLUMN utca_hsz VARCHAR2(100 CHAR);

--53
--Sz�rja be a haj� s�m�b�l a saj�t s�m�j�nak s_ugyfel t�bl�j�ba az olaszorsz�gi �gyfeleket!
INSERT INTO s_ugyfel (ugyfel_id, vezetekenev, keresztnev, telefon, email,szul_dat,helyseg,utca_hsz)
SELECT s_ugyfel (ugyfel_id, vezetekenev, keresztnev, telefon, email,szul_dat,helyseg,utca_hsz
FROM HAJO.s_ugyfel;

--54
--Sz�rja be a haj� s�m�b�l a saj�t s�m�j�nak s_haj� t�bl�j�ba a small feeder tipus� haj�k k�z�l azokat,
--amelyeknek nett� s�lya legal�bb 250 tonna
INSERT INTO s_hajo (hajo_id, nev, netto_suly, max_kontener_dbszam, max_sulyterheles, hajo_tipus)
SELECT hajo_id, nev, netto_suly, max_kontener_dbszam, max_sulyterheles, hajo_tipus
FROM HAJO.s_hajo
WHERE netto_suly>=250;

--55.
--Sz�rja be a 'haj�' s�m�b�l a saj�t s�m�j�nak s_hajo t�bl�j�ba azokat a 'Small Feeder"' t�pus� hja�kat, amelyek legfeljebb 10 kont�nert
--tudnak sz�ll�tani egyszerre;


--57
--T�r�lje a sz�razdokkal rendelkez? olaszorsz�gi �s ib�riai kik�t?ket! Azok a kik�t?k rendelkeznek sz�razdokkal, amelyeknek a le�r�s�ban
--szerepel a sz�razdokk sz�.
DELETE FROM HAJO.s_kikoto
WHERE leiras LIKE 'sz�razdokk'
    AND kikoto_id LIKE 'It_%' OR 'Liby_%';
    

--61
--M�dos�tsa a nagy termin�lter�lettel rendelkez? kik�t?k le�r�s�t �gy, 
--hogy az az elej�n tar- talmazza a kik�t? helys�g�t is, 
--amelyet egy vessz?vel �s egy sz?k�zzel v�lasszon el a le�r�s jelenlegi tartalm�t�l! 
--A nagy termin�lter�lettel rendelkez? kik�t?k le�r�s�ban szerepel a 'termin�lter�let: nagy, sztring. 
--(Figyeljen a vessz?re, a nagyon nagy" ter�let? kik�t?ket nem szeretn�nk m�dos�tani!) 
UPDATE HAJO.s_kikoto
SET leiras = helyseg||', '||leiras
WHERE leiras LIKE 'termin�lter�let: nagy,';


--62
--Alak�tsa csuba nagybet?ss� azon �gyfelek vezet�knev�t, akik eddig a legt�bbet fizett�k �sszesen a megrendel�seik�rt
UPDATE HAJO.s_ugyfel
SET vezeteknev = UPPER(vezeteknev)
WHERE(ugyfel_id IN (SELECT ugyfel
                    FROM HAJO.s_megrendeles
                    ORDER BY fizetett_osszeg desc
                    FETCH FIRST 5 ROWS ONLY)
);


--67.
--A francia kereskedelmi jogszab�lyoknak nemr�g bevezetett v�ltoz�sok jelent?s k�lts�gn�veked�st okoztak a c�g�nk sz�m�ra a francia 
--megrendel�sek lesz�ll�t�s�t illet?en. N�velje meg 15%-al a franciaorsz�gb�l sz�rmaz� �gyfeleink utols� megrendel�sei�rt fizetett �sszeget

--68
--A n�pess�gi adataink elavultak. 
--A friss�t�s�k egyik l�p�sek�nt n�velje meg 5%-kal az �zsiai orsz�gok telep�l�seinek lakoss�g�t! 

--69
--Egy puszt�t� v�rus szedte �ldozatait Afrika nagyv�rosaiban. Felezze meg azon afrikai telep�l�sek lakoss�g�t, amelyeknek aktu�lis
--lakoss�ga meghaladja a f�lmilli� f?t!

--70.
--C�g�nk adminisztr�tora elk�vetett egy nagy hib�t. A 2021 j�lius�ban Algeciras kik�t?j�b?l indul� utakat t�vesen
--Vitte be az adatb�zisba, mintha azok Valenci�b�l indultak volna. Val�ban Valenci�b�l egyetlen �t sem indult a k�rd�ses id?pontban
--Korrig�lja az adminisztr�tor hib�j�t! Az egyszer?s�g kedv��rt felt�telezz�k, hogy 1-1 ilyen v�ros l�tezik, egy kik�t?vel


--71.
--Hozzon l�tre n�zetet, amely list�zza az utak minden attrib�tum�t, kieg�sz�tve az indul�si �s �rkez�si kik�t? helys�g �s orsz�gnev�vel.


--74. Hozzon l�tre n�zetet, amely list�zza a megrendel�sek �sszes attrib�tum�t, kieg�sz�tve az indul�si �s �rkez�si kik�t?
--helys�gnev�vel �s orsz�g�val
CREATE VIEW megrendeles AS;
SELECT *
FROM HAJO.s_megrendeles;
        

--75
--Hozzon l�tre n�zetet, amely list�zza, hogy az egyes haj�t�pusokhoz tartoz� haj�k �sszesen h�ny utat teljes�tettek! 
--A list�ban szerepeljen a haj�t�pusok azonos�t�ja, neve �s a teljes�tett utak sz�ma! 
--Azokat a haj�t�pusokat is t�ntesse fel az eredm�nyben, amelyekhez egyetlen haj� sem tartozik, 
--�s azokat is, amelyekhez tartoz� haj�k egyetlen utat sem teljes�tettek! 
--A lista legyen a haj�t�pus neve szerint rendezett!

--76.
--Hozzon l�tre n�zetet, amely list�zza, hogy az egyes kik�t?knek h�ny telefonsz�ma van. A lista tartalmazza a kik�t?k azonos�t�j�t,
--a helys�g nev�t �s osz�g�t �s a telefonok sz�m�t. Azokat is t�ntess�k fel, aminek nincs telefonsz�ma


--78.
--Hozzon l�tre n�zetet, amely list�zza, hogy az egyes kik�t?kre h�ny �t vezetett: kik�t?k azonos�t�ja, helys�g�k neve, orsz�ga, utak sz�ma
--Azokat is t�ntess�k fel, ahova egyetlen �t sem vezetett!


--from hajo.s_helyseg h right outer join hajo.s_kikoto k on h.helyseg_id = k.helyseg
--from hajo.s_kikoto k left outer join hajo.s_helyseg h on h.helyseg_id = k.helyseg


--80
--Egy n�zetet, amely kilist�zza, hogy az egyes kik�t?k h�ny megrendel�sben szerepeltek c�lpontk�nt! A lista tartalmazza kik�t?k id-j�t, helys�gek
--nev�t �s orsz�g�t �s a megrendel�sek sz�m�t

--81. 
--Hozzon l�tre n�zetet, amely megadja a legnagyobb forgalm� kik�t?(k) azonos�t�j�t, helys�gnev�t �s orsz�g�t! A legnagyobb
--forgalm� kik�t? az, amelyik a legt�bb �t indul�si vagy �rkez�si kik�t?je volt.

--82
--Hozzon l�tre n�zetet, amely megadja annak a haj�nak az azonos�t�j�t �s nev�t, 
--amelyik a legnagyobb �sszs�lyt sz�ll�totta a 2021 m�jus�ban indul� utakon! 
--Ha t�bb ilyen haj� is van, akkor mindegyiket list�zza!


--83
--Hozzon l�tre n�zetet, ami megadja a kik�t? azonos�t�j�t, helys�gnev�t, orsz�g�t, amelykb?l kiindul� utakon
--sz�ll�tott kont�nerek �sszes�lya  a legnagyobb. Ha t�bb ilyen van, akkor mindegyiket list�zza

--84.
--Hozzon l�tre n�zetet, amely megadja annak a kik�t?nek az azonos�t�j�t, helys�gnev�t, �s orsz�g�t, ameylikbe tart� utakon
--sz�ll�tott kont�nerek �sszs�lya a legnagyobb. 


--86.
--Hozzon l�tre n�zetet amely megadja azoknak az utaknak az adatait, amelyeken a rakom�ny s�lya (a sz�ll�tott kont�nerek �s a
--rakom�nyaik �sszs�lya) nem haladja meg a haj� maxim�lis s�lyterhel�s�nek a fel�t! Az �t adatai mellett t�ntesse fel a haj� nev�t �s maxim�lis s�lyterhel�s�t
--Valamint a rakom�ny s�ly�t is



--88.
--Hozzon l�tre n�zetet, amely megadja annak a megrendel�snek az adatait, amelynek a teljes�t�s�hez a legt�bb �tra volt sz�ks�g! Ha t�bb
--Ilyen megrendel�s is van, akkor mindegyiket list�zza!
SELECT *
FROM HAJO.s_megrendeles;
--92.
--Adjon hivatkoz�si jogosults�got panovicsnak az �n s_ut t�bl�j�nak indulasi_ido �s hajo oszlopaiba
GRANT REFERENCES(indulasi_ido,hajo) ON HAJO.s_ut TO panovics;

--94
--Adjon m�dos�t�si jogosults�got a 'panovics' felhaszn�l�nak az �n s_ugyfel t�bl�j�nak vezet�k �s keresztn�v oszlopaira
GRANT UPDATE(vezeteknev,keresztnev) ON HAJO.s_ugyfel TO panovics;

--95
--Adjon besz�r�si jogosults�got minden felhaszn�l�nak 
--az �n 's_kikoto' t�bl�j�nak a 'kikoto_id' �s 'helyseg' oszlopaira!
GRANT INSERT(kikoto_id,helyseg) ON HAJO.s_kikoto TO PUBLIC;

--96
--Vonja vissza a lek�rdez�si jogosults�got a 'panovics' felhaszn�l�t�l az �n s_ut t�bl�j�b�l
REVOKE SELECT ON s_ut FROM panovics;

--98
--Vonja vissza a t�rl�si �s m�dos�t�si jogosults�got a 'panovics' nev? felhaszn�l�t�l az �n s_kikoto t�bl�j�r�l
REVOKE DELETE, UPDATE  ON HAJO.s_kikoto FROM panovics;


--99
--Vonja vissza a t�rl�si jogot 'panovics' felhaszn�l�t�l az �n s_orszag t�bl�j�r�l
REVOKE DELETE ON s_orszag FROM panovics;

--100
--Vonja vissza a besz�r�si jogosults�got minden felhaszn�l�t�l az �n s_megrendel�s t�bl�j�r�l
REVOKE INSERT ON HAJO.s_megrendeles FROM PUBLIC;