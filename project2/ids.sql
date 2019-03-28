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

CREATE TABLE player(
  player_id int generated as identity constraint PK_player primary key,
  name varchar(255),
  gold int,
  kills int
);

create table author(
  author_id int generated as identity constraint PK_author primary key,
  name varchar(255)
);

create table location(
  location_id int generated as identity constraint PK_location primary key,
  name varchar(255)
);

create table adventure(
  adventure_id int generated as identity constraint PK_adventure primary key,
  difficulty int,
  objective varchar(255),
  pj_id int,
  location_id int,
  CONSTRAINT FK_Adventure FOREIGN KEY (pj_id) REFERENCES player(player_id),
  CONSTRAINT FK_Location FOREIGN KEY (location_id) REFERENCES location(location_id)
);

create table adventure_author(
  adventure_id int,
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
  name varchar(255),
  race varchar(255),
  class varchar(255),
  "level" int,
  player_id int,
  CONSTRAINT FK_Character FOREIGN KEY (player_id) REFERENCES player(player_id),
  death_id int,
  FOREIGN KEY (death_id) REFERENCES Death(death_id)
);

create table character_adventure(
  character_id int NOT NULL,
  CONSTRAINT FK_char FOREIGN KEY (character_id) REFERENCES character(character_id),
  adventure_id int NOT NULL,
  CONSTRAINT  FK_adv FOREIGN KEY(adventure_id) REFERENCES adventure(adventure_id)
);

create table equipment(
  equipment_id int generated as identity constraint PK_equipment primary key,
  type varchar(255)
);

create table character_equipment(
    quantity int,
    equipment_id int,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    character_id int,
    FOREIGN KEY (character_id) REFERENCES character(character_id)
);

create table game_element(
  element_id int generated as identity constraint PK_element primary key,
  name varchar(255)
);

create table map(
  element_id int,
  scale int,
  CONSTRAINT PK_Map PRIMARY KEY (element_id),
  CONSTRAINT FK_Map FOREIGN KEY (element_id) REFERENCES game_element ON DELETE CASCADE
);

create table enemy(
  race varchar(255),
  "level" int,
  element_id int,
  CONSTRAINT PK_Enemy PRIMARY KEY (element_id),
  CONSTRAINT FK_Enemy FOREIGN KEY (element_id) REFERENCES game_element ON DELETE CASCADE
);

create table campaign(
  campaign_id int generated as identity constraint PK_campaign primary key,
  difficulty int,
  objective varchar(255)
);

create table adventure_campaign(
  campaign_id int,
  FOREIGN KEY (campaign_id) REFERENCES campaign(campaign_id),
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id)
);

create table Sessions(
  session_id int generated as identity constraint PK_session primary key,
  "date" date,
  place varchar(255)
);

create table adventure_game_element(
  game_element int NOT NULL,
  FOREIGN KEY (game_element) REFERENCES game_element(element_id),
  adventure_id int,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id)
);

create table adventure_session(
  session_id int,
  FOREIGN KEY (session_id) REFERENCES sessions(session_id),
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES adventure(adventure_id)
);