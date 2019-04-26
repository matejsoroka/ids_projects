-- DROPPING TABLES IF NOT EXIST
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'adventure_author';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'character_adventure';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'character_equipment';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'adventure_campaign';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'adventure_session';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'adventure_game_element';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'adventure';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'character';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'player';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'death';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'location';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'equipment';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'author';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'map';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'enemy';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'game_element';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'campaign';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'sessions';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'race';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

-- CREATING TABLES
create table player(
  player_id int generated as identity constraint PK_player primary key,
  name varchar(64) unique,
  gold int,
  kills int,
  email varchar(128),
  password varchar(128),
  role varchar(10)
);

create table author(
  author_id int generated as identity constraint PK_author primary key,
  name varchar(64)
);

create table location(
  location_id int generated as identity constraint PK_location primary key,
  name varchar(64)
);

create table adventure(
  adventure_id int generated as identity constraint PK_adventure primary key,
  difficulty int,
  objective varchar(64),
  pj_id int,
  location_id int,
  CONSTRAINT FK_Adventure FOREIGN KEY (pj_id) REFERENCES player(player_id) ON DELETE SET NULL,
  CONSTRAINT FK_Location FOREIGN KEY (location_id) REFERENCES location(location_id)
);

create table adventure_author(
  adventure_author_id int generated as identity constraint PK_adventure_author primary key,
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id) ON DELETE CASCADE,
  author_id int NOT NULL,
  FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);

create table death(
  death_id int generated as identity constraint PK_death primary key,
  "date" date,
  location_id int,
  CONSTRAINT FK_Death FOREIGN KEY (location_id) REFERENCES location(location_id)
);

create table race(
  race_id int generated as identity constraint PK_race_id primary key,
  name varchar(64),
  image varchar(256),
  description varchar(1024)
);

create table character(
  character_id int generated as identity constraint PK_character primary key,
  name varchar(64),
  race_id int,
  CONSTRAINT FK_Character_class FOREIGN KEY (race_id) REFERENCES race(race_id),
  class varchar(16),
  "level" int,
  player_id int,
  CONSTRAINT FK_Character FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE CASCADE,
  death_id int,
  FOREIGN KEY (death_id) REFERENCES Death(death_id)
);

create table character_adventure(
  character_adventure int generated as identity constraint PK_character_adventure primary key,
  character_id int NOT NULL,
  CONSTRAINT FK_char FOREIGN KEY (character_id) REFERENCES character(character_id) ON DELETE CASCADE,
  adventure_id int NOT NULL,
  CONSTRAINT  FK_adv FOREIGN KEY(adventure_id) REFERENCES adventure(adventure_id) ON DELETE CASCADE
);

create table equipment(
  equipment_id int generated as identity constraint PK_equipment primary key,
  type varchar(64)
);

create table character_equipment(
    character_equipment int generated as identity constraint PK_character_equipment primary key,
    quantity int,
    equipment_id int NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE,
    character_id int NOT NULL,
    FOREIGN KEY (character_id) REFERENCES character(character_id) ON DELETE CASCADE
);

create table game_element(
  element_id int generated as identity constraint PK_element primary key,
  name varchar(64)
);

create table map(
  scale varchar(64),
  element_id int generated as identity constraint PK_map primary key,
  CONSTRAINT FK_Map FOREIGN KEY (element_id) REFERENCES game_element ON DELETE CASCADE
);

create table enemy(
  race_id int,
  CONSTRAINT FK_enemy_race FOREIGN KEY (race_id) REFERENCES race(race_id),
  "level" int,
  element_id int generated as identity constraint PK_enemy primary key,
  CONSTRAINT FK_Enemy FOREIGN KEY (element_id) REFERENCES game_element ON DELETE CASCADE
);

create table campaign(
  campaign_id int generated as identity constraint PK_campaign primary key,
  difficulty int,
  objective varchar(64)
);

create table adventure_campaign(
  adventure_campaign_id int generated as identity constraint PK_adventure_campaign primary key,
  campaign_id int NOT NULL,
  FOREIGN KEY (campaign_id) REFERENCES campaign(campaign_id) ON DELETE CASCADE,
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id) ON DELETE CASCADE
);

create table sessions(
  session_id int generated as identity constraint PK_session primary key,
  "date" date,
  place varchar(64)
);

create table adventure_game_element(
  adventure_game_element_id int generated as identity constraint PK_adventure_game_element primary key,
  game_element int NOT NULL,
  FOREIGN KEY (game_element) REFERENCES game_element(element_id) ON DELETE CASCADE,
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id) ON DELETE CASCADE
);

create table adventure_session(
  adventure_session_id int generated as identity constraint PK_adventure_session primary key,
  session_id int NOT NULL,
  FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE,
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id) ON DELETE CASCADE
);

-- INSERTING DUMMY DATA
INSERT INTO PLAYER ("NAME", "GOLD", "KILLS", "PASSWORD") VALUES ('Alex', 12, 6, '$2b$12$fVF90LTwy1JcaMK5TdyTfuuIae5uCBaO9ChOGMhn/oEfBr7XwJjeu');
INSERT INTO LOCATION ("NAME") VALUES ('Lost woods');
INSERT INTO DEATH ("date", "LOCATION_ID") VALUES (TO_DATE('2015/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'), 1);
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Elf', 'images/race/elf.png', 'Elfové jsou magičtí lidé z jiných světů, kteří žijí ve světě, ale nejsou jeho součástí. Žijí v místech éterické krásy, uprostřed prastarých lesů nebo ve stříbřitých věžích, které se třpytí světlem luštěnin, kde se vzduchem rozlévá jemná hudba a jemný vůně vane. Zbarvení elfů zahrnuje normální lidský rozsah a zahrnuje také kůži v odstínech mědi, bronzu a téměř modrobílé, vlasy zelené nebo modré a oči jako kaluže tekutého zlata nebo stříbra.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Dwarf', 'images/race/dwarf.png', 'Království bohaté na prastarou majestátnost, sály vytesané do kořenů hor, ozvěny výběhů a kladiv v hlubokých dolech a planoucí kovárny - tyto společné nitě spojují všechny trpaslíky. Trpaslíci mohou žít více než 400 let, takže nejstarší žijící trpaslíci si často pamatují velmi odlišný svět. Například někteří z nejstarších trpaslíků žijících v citadele Felbarru si možná vzpomenou na den, kdy orkové dobyli pevnost a vzali je do exilu, který trval více než 250 let.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Gnome', '/static/images/race/gnome.png', 'Trvalé hučení rušných činností proniká do válek a sousedství, kde trpaslíci utvářejí své blízké komunity. Hlučné zvuky přerušují ostřejší zvuky: tu je broušení broušených ozubených kol, menší výbuch, kvílení překvapení nebo triumfu, a zejména výbuchy smíchu. Gnomové se radují ze života, užívají si každý okamžik vynálezu, zkoumání, vyšetřování, stvoření a hry. Vousy mužského gnome, na rozdíl od jeho divokých vlasů, jsou pečlivě zastřižené, ale často stylizované do zvědavých vidlic nebo úhledných bodů.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Dragonborn', '/static/images/race/dragonborn.png', 'Narozený z draků, jak jejich jméno prohlašuje, dragonborn pyšně prochází světem, který je přivítá strašlivým nepochopením. Ve tvaru drakonických bohů nebo samotných draků se dragonborn původně vylíhl z drakových vajec jako jedinečná rasa, kombinující nejlepší vlastnosti draků a humanoidů. Někteří dragonborn jsou věrní služebníci opravdovým drakům, jiní tvoří řady vojáků ve velkých válkách, a jiní se ocitnou v nouzi, s jasným povoláním v životě.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Human', '/static/images/race/human.png', 'Ve většině světových výpočtů jsou lidé nejmladší ze společných ras, pozdě na světě, a krátkotrvající ve srovnání s trpaslíky, elfy a draky. Možná je to kvůli jejich kratším životům, že se snaží dosáhnout co nejvíce let. Nebo snad cítí, že mají něco, co mohou udělat pro starší rasy, a proto stavět své mocné říše na základech dobývání a obchodu. Bez ohledu na to, co je řídí, jsou lidé inovátory, úspěchy a průkopníci světů.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Tiefling', '/static/images/race/tiefling.png', 'Chcete-li být uvítáni pohledy a šeptem, trpět násilím a urážet na ulici, vidět nedůvěru a strach v každém oku: to je spousta tieflingu. A aby se otočil nůž, věří ti, že je to proto, že pakt zasáhl generace, které před nedávnem naplnily esenci Asmodeus - vládce Devíti pekel - do jejich pokrevní linie. Jejich vzhled a jejich povaha nejsou jejich vinou, ale výsledkem starodávného hříchu, za který budou vždy zodpovědní oni i jejich děti a děti jejich dětí.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Half elf', '/static/images/race/half_elf.png', 'Polovina elfů, kteří jsou ve dvou světech, ale skutečně patří k těm, kteří jsou s nimi spojeni, kombinují to, co někteří říkají, jsou nejlepší kvality jejich elfů a lidských rodičů: lidská zvědavost, vynalézavost a ambice zmírněné rafinovanými smysly a uměleckými chutí elfů. Někteří poloviční elfové žijí mezi lidmi, odděleni svými emocionálními a fyzickými odlišnostmi, sledují přátele a blízké, zatímco čas se jich sotva dotýká. Jiní žijí s elfy, rostou neklidně, když dosáhnou dospělosti v nadčasových elfích říších.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Half orc', '/static/images/race/half_orc.png', 'Ať už byli spojeni pod vedením mocného čaroděje nebo bojovali po nekolika letech konfliktu, ork a lidské kmeny někdy tvoří spojenectví, spojující síly do větší hordy k teroru civilizovaných zemí v okolí. Když jsou tato aliance uzavřena sňatky, narodí se polovina orků. Někteří poloviční orkové se stávají hrdými náčelníky orků, jejich lidská krev jim dává výhodu nad jejich plnokrevnými orky.');
INSERT INTO RACE ("NAME", "IMAGE", "DESCRIPTION") VALUES ('Halfling', '/static/images/race/halfling.png', 'Komfort domova je cílem většiny životů polovinců: místo, kde se můžete usadit v klidu a míru, daleko od mariting monster a střetu armád; planoucí oheň a velkorysé jídlo; jemný nápoj a skvělá konverzace. I když někteří z nich žijí své dny v odlehlých zemědělských komunitách, jiní tvoří kočovní kapely, které neustále cestují, lákají otevřenou cestou a širokým obzorem, aby objevili zázraky nových zemí a národů.');
INSERT INTO CHARACTER ("NAME", "RACE_ID", "CLASS", "level", "PLAYER_ID", "DEATH_ID") VALUES ('Frodo', 1, 'Warlock', 3, 1, 1);
INSERT INTO CHARACTER ("NAME", "RACE_ID", "CLASS", "level", "PLAYER_ID") VALUES ('Ocean Almondflame', 2, 'Cleric', 6, 1);
INSERT INTO EQUIPMENT ("TYPE") VALUES ('Battleaxe');
INSERT INTO EQUIPMENT ("TYPE") VALUES ('Arrows');
INSERT INTO CHARACTER_EQUIPMENT ("QUANTITY", "EQUIPMENT_ID", "CHARACTER_ID") VALUES (1, 1, 1);
INSERT INTO CHARACTER_EQUIPMENT ("QUANTITY", "EQUIPMENT_ID", "CHARACTER_ID") VALUES (20, 2, 2);
INSERT INTO CHARACTER_EQUIPMENT ("QUANTITY", "EQUIPMENT_ID", "CHARACTER_ID") VALUES (1, 1, 2);
INSERT INTO ADVENTURE ("DIFFICULTY", "OBJECTIVE", "PJ_ID", "LOCATION_ID") VALUES (3, 'Kill dragon', 1, 1);
INSERT INTO CHARACTER_ADVENTURE ("CHARACTER_ID", "ADVENTURE_ID") VALUES (1, 1);
INSERT INTO CHARACTER_ADVENTURE ("CHARACTER_ID", "ADVENTURE_ID") VALUES (2, 1);
INSERT INTO AUTHOR ("NAME") VALUES ('Daniel Smith');
INSERT INTO AUTHOR ("NAME") VALUES ('Rose Hope');
INSERT INTO ADVENTURE_AUTHOR("ADVENTURE_ID", AUTHOR_ID) VALUES (1, 1);
INSERT INTO ADVENTURE_AUTHOR("ADVENTURE_ID", AUTHOR_ID) VALUES (1, 2);
INSERT INTO CAMPAIGN ("DIFFICULTY", "OBJECTIVE") VALUES (3, 'Kill King');
INSERT INTO ADVENTURE_CAMPAIGN ("CAMPAIGN_ID", "ADVENTURE_ID") VALUES (1, 1);
INSERT INTO SESSIONS ("date", "PLACE") VALUES (TO_DATE('2019/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'), 'The Black Cat');
INSERT INTO ADVENTURE_SESSION ("SESSION_ID", "ADVENTURE_ID") VALUES (1, 1);
INSERT INTO GAME_ELEMENT ("NAME") VALUES ('Bitterblack Isle');
INSERT INTO MAP ("SCALE") VALUES ('1000:20');
INSERT INTO ADVENTURE_GAME_ELEMENT ("GAME_ELEMENT", "ADVENTURE_ID") VALUES (1, 1);
INSERT INTO GAME_ELEMENT ("NAME") VALUES ('Heraldo');
INSERT INTO ENEMY ("RACE_ID", "level") VALUES (1, 15);
INSERT INTO ADVENTURE_GAME_ELEMENT ("GAME_ELEMENT", "ADVENTURE_ID") VALUES (2, 1);
INSERT INTO PLAYER ("NAME", "GOLD", "KILLS", "PASSWORD") VALUES ('Matej', 42, 3, '$2b$12$fVF90LTwy1JcaMK5TdyTfuuIae5uCBaO9ChOGMhn/oEfBr7XwJjeu');
INSERT INTO LOCATION ("NAME") VALUES ('Forgotten dungeon');
INSERT INTO EQUIPMENT ("TYPE") VALUES ('Sword');
INSERT INTO EQUIPMENT ("TYPE") VALUES ('Bow');
INSERT INTO AUTHOR ("NAME") VALUES ('J. R. Tolkien');
INSERT INTO CHARACTER ("NAME", "RACE_ID", "CLASS", "level", "PLAYER_ID") VALUES ('Gibblegill', 3, 'Orc', 5, 2);
INSERT INTO CHARACTER_EQUIPMENT ("QUANTITY", "EQUIPMENT_ID", "CHARACTER_ID") VALUES (10, 3, 3);
INSERT INTO CHARACTER_EQUIPMENT ("QUANTITY", "EQUIPMENT_ID", "CHARACTER_ID") VALUES (1, 4, 3);
INSERT INTO DEATH ("date", "LOCATION_ID") VALUES (TO_DATE('2019/03/20 20:02:44', 'yyyy/mm/dd hh24:mi:ss'), 2);
UPDATE CHARACTER SET DEATH_ID = 2 WHERE CHARACTER_ID = 3;
INSERT INTO ADVENTURE ("PJ_ID", "LOCATION_ID", "OBJECTIVE", "DIFFICULTY") VALUES (2, 2, 'Kill the Smorg', 4);
INSERT INTO CHARACTER_ADVENTURE ("CHARACTER_ID", "ADVENTURE_ID") VALUES (3, 2);
INSERT INTO ADVENTURE_AUTHOR ("ADVENTURE_ID", "AUTHOR_ID") VALUES (2, 1);
INSERT INTO SESSIONS ("date", "PLACE") VALUES (TO_DATE('2019/03/20 20:02:44', 'yyyy/mm/dd hh24:mi:ss'), 'At Merlin''s home');
INSERT INTO ADVENTURE_SESSION ("ADVENTURE_ID", "SESSION_ID") VALUES (2, 2);
INSERT INTO CAMPAIGN ("DIFFICULTY", "OBJECTIVE") VALUES (8, 'Conquer castle of dragons');
INSERT INTO ADVENTURE_CAMPAIGN ("ADVENTURE_ID", "CAMPAIGN_ID") VALUES (2, 2);
INSERT INTO GAME_ELEMENT ("NAME") VALUES ('Map of Midgard');
INSERT INTO MAP ("SCALE") VALUES ('1:34');
INSERT INTO GAME_ELEMENT ("NAME") VALUES ('Elre Valamin');
INSERT INTO ENEMY ("RACE_ID", "level") VALUES (1, 2);
INSERT INTO ADVENTURE_GAME_ELEMENT ("GAME_ELEMENT", "ADVENTURE_ID") VALUES (3, 2);
INSERT INTO ADVENTURE_GAME_ELEMENT ("GAME_ELEMENT", "ADVENTURE_ID") VALUES (4, 2);

COMMIT
