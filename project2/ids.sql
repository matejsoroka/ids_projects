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

-- CREATING TABLES
create table player(
  player_id int generated as identity constraint PK_player primary key,
  name varchar(64),
  gold int,
  kills int
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
  CONSTRAINT FK_Adventure FOREIGN KEY (pj_id) REFERENCES player(player_id),
  CONSTRAINT FK_Location FOREIGN KEY (location_id) REFERENCES location(location_id)
);

create table adventure_author(
  adventure_author_id int generated as identity constraint PK_adventure_author primary key,
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id),
  author_id int NOT NULL,
  FOREIGN KEY (author_id) REFERENCES author(author_id)
);

create table death(
  death_id int generated as identity constraint PK_death primary key,
  "date" date,
  location_id int,
  CONSTRAINT FK_Death FOREIGN KEY (location_id) REFERENCES location(location_id)
);

create table character(
  character_id int generated as identity constraint PK_character primary key,
  name varchar(64),
  race varchar(64),
  class varchar(64),
  "level" int,
  player_id int,
  CONSTRAINT FK_Character FOREIGN KEY (player_id) REFERENCES player(player_id),
  death_id int,
  FOREIGN KEY (death_id) REFERENCES Death(death_id)
);

create table character_adventure(
  character_adventure int generated as identity constraint PK_character_adventure primary key,
  character_id int NOT NULL,
  CONSTRAINT FK_char FOREIGN KEY (character_id) REFERENCES character(character_id),
  adventure_id int NOT NULL,
  CONSTRAINT  FK_adv FOREIGN KEY(adventure_id) REFERENCES adventure(adventure_id)
);

create table equipment(
  equipment_id int generated as identity constraint PK_equipment primary key,
  type varchar(64)
);

create table character_equipment(
    character_equipment int generated as identity constraint PK_character_equipment primary key,
    quantity int,
    equipment_id int NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    character_id int NOT NULL,
    FOREIGN KEY (character_id) REFERENCES character(character_id)
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
  race varchar(64),
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
  FOREIGN KEY (campaign_id) REFERENCES campaign(campaign_id),
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id)
);

create table sessions(
  session_id int generated as identity constraint PK_session primary key,
  "date" date,
  place varchar(64)
);

create table adventure_game_element(
  adventure_game_element_id int generated as identity constraint PK_adventure_game_element primary key,
  game_element int NOT NULL,
  FOREIGN KEY (game_element) REFERENCES game_element(element_id),
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id)
);

create table adventure_session(
  adventure_session_id int generated as identity constraint PK_adventure_session primary key,
  session_id int NOT NULL,
  FOREIGN KEY (session_id) REFERENCES sessions(session_id),
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id)
);

-- INSERTING DUMMY DATA
INSERT INTO PLAYER ("NAME", "GOLD", "KILLS") VALUES ('Alex', 12, 6);
INSERT INTO LOCATION ("NAME") VALUES ('Lost woods');
INSERT INTO DEATH ("date", "LOCATION_ID") VALUES (TO_DATE('2015/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'), 1);
INSERT INTO CHARACTER ("NAME", "RACE", "CLASS", "level", "PLAYER_ID", "DEATH_ID") VALUES ('Frodo', 'Elf', 'Warlock', 3, 1, 1);
INSERT INTO CHARACTER ("NAME", "RACE", "CLASS", "level", "PLAYER_ID") VALUES ('Ocean Almondflame', 'Gnome', 'Cleric', 6, 1);
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
INSERT INTO ENEMY ("RACE", "level") VALUES ('Elf', 15);
INSERT INTO ADVENTURE_GAME_ELEMENT ("GAME_ELEMENT", "ADVENTURE_ID") VALUES (2, 1);
INSERT INTO PLAYER ("NAME", "GOLD", "KILLS") VALUES ('Matej', 42, 3);
INSERT INTO LOCATION ("NAME") VALUES ('Forgotten dungeon');
INSERT INTO EQUIPMENT ("TYPE") VALUES ('Sword');
INSERT INTO EQUIPMENT ("TYPE") VALUES ('Bow');
INSERT INTO AUTHOR ("NAME") VALUES ('J. R. Tolkien');
INSERT INTO CHARACTER ("NAME", "RACE", "CLASS", "level", "PLAYER_ID") VALUES ('Gibblegill', 'Lizardfold', 'Orc', 5, 2);
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
INSERT INTO ENEMY ("RACE", "level") VALUES ('Elf', 2);
INSERT INTO ADVENTURE_GAME_ELEMENT ("GAME_ELEMENT", "ADVENTURE_ID") VALUES (3, 2);
INSERT INTO ADVENTURE_GAME_ELEMENT ("GAME_ELEMENT", "ADVENTURE_ID") VALUES (4, 2);

COMMIT



