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

    def get_row(self, table, id):
        """Gets row from table with specific id (doesn't work when table_name != table_name_id)"""
        self.cursor.execute("SELECT * FROM {} WHERE {}_id={}".format(table, table, id))
        return self.cursor.fetchone()

    def get_player_characters(self, player_id):
        self.cursor.execute("SELECT CHARACTER.CHARACTER_ID, CHARACTER.NAME, COUNT(*) as adventure_count "
                            "FROM CHARACTER, CHARACTER_ADVENTURE "
                            "WHERE CHARACTER.PLAYER_ID = {} AND "
                            "CHARACTER_ADVENTURE.CHARACTER_ID = CHARACTER.CHARACTER_ID "
                            "GROUP BY CHARACTER.CHARACTER_ID, CHARACTER.NAME "
                            "ORDER BY adventure_count DESC".format(player_id))
        return self.cursor.fetchall()

    def delete_row(self, table, id):
        """Removes row from table with specific id (doesn't work when table_name != table_name_id)"""
        self.cursor.execute("DELETE FROM {} WHERE {}_id={}".format(table, table, id))
        self.db.commit()
