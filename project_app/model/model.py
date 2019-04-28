import cx_Oracle
import os


class Model:
    def __init__(self):
        db_user = os.environ.get('DBAAS_USER_NAME', 'xsorok02')
        db_password = os.environ.get('DBAAS_USER_PASSWORD', 'CJiBvpmS')
        db_connect = os.environ.get('DBAAS_DEFAULT_CONNECT_DESCRIPTOR',
                                    "gort.fit.vutbr.cz:1521/orclpdb.gort.fit.vutbr.cz")
        self.db = cx_Oracle.connect(db_user, db_password, db_connect)
        self.cursor = self.db.cursor()

    def get_table(self, table):
        """Gets every row in table"""
        self.cursor.execute("SELECT * FROM {}".format(table))
        return self.cursor.fetchall()

    def get_pairs(self, table):
        """Gets every row in table in (id, name) format"""
        self.cursor.execute("SELECT * FROM {}".format(table))
        data = self.cursor.fetchall()
        array = []
        for item in data:
            array.append((int(item[0]), item[1]))
        return array

    def insert(self, table, data):
        """Inserts row into table where data = {col_name: data, ...}"""
        query = "INSERT INTO {} ".format(table)
        cols = values = ''
        i = 1
        for key, value in data.items():
            if key == "level":
                cols = cols + '"' + key + '"'
            else:
                cols = cols + key
            if isinstance(value, str):
                values = values + "'" + value + "'"
            else:
                values = values + str(value)
            if i != len(data):
                cols = cols + ','
                values = values + ","
            i = i + 1
        query = query + "(" + cols + ") VALUES (" + values + ")"
        self.cursor.execute(query)
        self.db.commit()

    def get_last_id(self, table):
        """Gets last inserted id from table"""
        self.cursor.execute("SELECT {}_id FROM {} ORDER BY {}_id DESC".format(table, table, table))
        return self.cursor.fetchone()[0]

    def get_last_element_id(self):
        """Gets last inserted id from table"""
        self.cursor.execute("SELECT element_id FROM {} ORDER BY element_id DESC".format("game_element"))
        return self.cursor.fetchone()[0]

    def get_row(self, table, row_id):
        """Gets row from table with specific id (doesn't work when table_name != table_name_id)"""
        self.cursor.execute("SELECT * FROM {} WHERE {}_id={}".format(table, table, row_id))
        row = self.cursor.fetchone()
        return row if row else None

    def get_player_by_username(self, username):
        """Gets row from table with specific id (doesn't work when table_name != table_name_id)"""
        self.cursor.execute("SELECT * FROM player WHERE name='{}'".format(username))
        return self.cursor.fetchone()

    def get_player_characters(self, player_id):
        self.cursor.execute("SELECT CHARACTER.CHARACTER_ID, CHARACTER.NAME, COUNT(*) as adventure_count "
                            "FROM CHARACTER, CHARACTER_ADVENTURE "
                            "WHERE CHARACTER.PLAYER_ID = {} AND "
                            "CHARACTER_ADVENTURE.CHARACTER_ID = CHARACTER.CHARACTER_ID "
                            "GROUP BY CHARACTER.CHARACTER_ID, CHARACTER.NAME "
                            "ORDER BY adventure_count DESC".format(player_id))
        return self.cursor.fetchall()

    def get_player_ids(self):
        self.cursor.execute("SELECT player_id FROM player")
        return self.cursor.fetchall()

    def delete_row(self, table, row_id):
        """Removes row from table with specific id (doesn't work when table_name != table_name_id)"""
        self.cursor.execute("DELETE FROM {} WHERE {}_id={}".format(table, table, row_id))
        self.db.commit()

    def get_player_best_character(self, player_id):
        self.cursor.execute('SELECT CHARACTER.name as character_name, CHARACTER."level", RACE.NAME as race_name, '
                            'RACE.IMAGE '
                            'from CHARACTER '
                            'join PLAYER on CHARACTER.player_id = PLAYER.player_id '
                            'join RACE on CHARACTER.RACE_ID = race.RACE_ID '
                            'where CHARACTER."level" = '
                            'ALL (SELECT max(CHARACTER."level") '
                            'from CHARACTER where CHARACTER.player_id = {})'.format(player_id))
        return self.cursor.fetchone()

    def get_character(self, player_id):
        self.cursor.execute('SELECT CHARACTER_ID, CHARACTER.NAME as character_name, CHARACTER.class, '
                            'character."level", PLAYER.PLAYER_ID as player_id , PLAYER.NAME as player_name, '
                            'RACE.NAME as race_name, RACE.IMAGE, RACE.DESCRIPTION '
                            'FROM CHARACTER '
                            'join RACE on CHARACTER.CHARACTER_ID = RACE.RACE_ID '
                            'join PLAYER on CHARACTER.PLAYER_ID = PLAYER.PLAYER_ID '
                            'WHERE CHARACTER_ID = {}'.format(player_id))
        return self.cursor.fetchone()

    def get_session(self, session_id):
        self.cursor.execute(
            'SELECT SESSIONS.session_id,SESSIONS.place, SESSIONS."date", SESSIONS.moderator, PLAYER.name FROM SESSIONS '
            'join PLAYER on SESSIONS.moderator = PLAYER.player_id '
            'where PLAYER.player_id = SESSIONS.moderator AND SESSIONS.session_id={}'.format(session_id))
        return self.cursor.fetchone()

    def get_session_adventures(self, session_id):
        self.cursor.execute(
            'SELECT a.adventure_id, a.objective FROM ADVENTURE a, ADVENTURE_SESSION ads, SESSIONS s '
            'WHERE s.session_id=ads.session_id AND a.adventure_id=ads.adventure_id AND s.session_id={}'
            .format(session_id))
        return self.cursor.fetchall()

    def get_adventure(self, adventure_id):
        self.cursor.execute(
            'SELECT a.ADVENTURE_ID, a.OBJECTIVE, a.DIFFICULTY, l.NAME, p.player_id, p.name '
            'FROM ADVENTURE a, LOCATION l, PLAYER p '
            'WHERE l.LOCATION_ID=a.LOCATION_ID AND a.PJ_ID=p.PLAYER_ID AND a.ADVENTURE_ID = {}'.format(adventure_id))
        return self.cursor.fetchone()

    def get_adventure_characters(self, adventure_id):
        self.cursor.execute(
            'SELECT c.character_id, c.name '
            'FROM ADVENTURE a, CHARACTER c, CHARACTER_ADVENTURE ca '
            'WHERE a.adventure_id=ca.adventure_id AND c.character_id=ca.character_id AND a.adventure_id={}'
            .format(adventure_id))
        return self.cursor.fetchall()

    def get_pjs_adventures(self, player_id):
        self.cursor.execute('SELECT a.adventure_id, a.objective FROM ADVENTURE a WHERE a.PJ_ID = {}'.format(player_id))
        return self.cursor.fetchall()
