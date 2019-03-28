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
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Adventure';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Character';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Player';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Death';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Location';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Equipment';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Author';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Map';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Enemy';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Game_element';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Campaign';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'Sessions';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

CREATE TABLE Player(
  player_id int generated as identity constraint PK_player primary key,
  name varchar(255),
  gold int,
  kills int
);

create table Author(
  author_id int generated as identity constraint PK_author primary key,
  name varchar(255)
);

create table Location(
  location_id int generated as identity constraint PK_location primary key,
  name varchar(255)
);

create table Adventure(
  adventure_id int generated as identity constraint PK_adventure primary key,
  difficulty int,
  objective varchar(255),
  pj_id int,
  location_id int,
  CONSTRAINT FK_Adventure FOREIGN KEY (pj_id) REFERENCES Player(player_id),
  CONSTRAINT FK_Location FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

create table adventure_author(
  adventure_id int,
  FOREIGN KEY (adventure_id) REFERENCES Adventure(adventure_id),
  author_id int NOT NULL,
  FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

create table Death(
  death_id int generated as identity constraint PK_death primary key,
  "date" int,
  location_id int,
  CONSTRAINT FK_Death FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

create table Character(
  character_id int generated as identity constraint PK_character primary key,
  name varchar(255),
  race varchar(255),
  class varchar(255),
  "level" int,
  player_id int,
  CONSTRAINT FK_Character FOREIGN KEY (player_id) REFERENCES Player(player_id),
  death_id int,
  FOREIGN KEY (death_id) REFERENCES Death(death_id)
);

create table character_adventure(
  character_id int NOT NULL,
  CONSTRAINT FK_char FOREIGN KEY (character_id) REFERENCES Character(character_id),
  adventure_id int NOT NULL,
  CONSTRAINT  FK_adv FOREIGN KEY(adventure_id) REFERENCES Adventure(adventure_id)
);

create table Equipment(
  equipment_id int generated as identity constraint PK_equipment primary key,
  type varchar(255)
);

create table character_equipment(
    quantity int,
    equipment_id int,
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id),
    character_id int,
    FOREIGN KEY (character_id) REFERENCES Character(character_id)
);

create table Game_element(
  element_id int generated as identity constraint PK_element primary key,
  name varchar(255)
);

create table Map(
  element_id int,
  scale int,
  CONSTRAINT PK_Map PRIMARY KEY (element_id),
  CONSTRAINT FK_Map FOREIGN KEY (element_id) REFERENCES Game_element ON DELETE CASCADE
);

create table Enemy(
  race varchar(255),
  "level" int,
  element_id int,
  CONSTRAINT PK_Enemy PRIMARY KEY (element_id),
  CONSTRAINT FK_Enemy FOREIGN KEY (element_id) REFERENCES Game_element ON DELETE CASCADE
);

create table Campaign(
  campaign_id int generated as identity constraint PK_campaign primary key,
  difficulty int,
  objective varchar(255)
);

create table adventure_campaign(
  campaign_id int,
  FOREIGN KEY (campaign_id) REFERENCES Campaign(campaign_id),
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES Adventure(adventure_id)
);

create table Sessions(
  session_id int generated as identity constraint PK_session primary key,
  "date" int,
  place varchar(255)
);

create table adventure_game_element(
  game_element int NOT NULL,
  FOREIGN KEY (game_element) REFERENCES Game_element(element_id),
  adventure_id int,
  FOREIGN KEY (adventure_id) REFERENCES Adventure(adventure_id)
);

create table adventure_session(
  session_id int,
  FOREIGN KEY (session_id) REFERENCES Sessions(session_id),
  adventure_id int NOT NULL,
  FOREIGN KEY (adventure_id) REFERENCES Adventure(adventure_id)
);