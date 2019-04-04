from flask import Flask, render_template
# import cx_Oracle
import os

app = Flask(__name__)

db_user = os.environ.get('DBAAS_USER_NAME', 'xsorok02')
db_password = os.environ.get('DBAAS_USER_PASSWORD', 'CJiBvpmS')
db_connect = os.environ.get('DBAAS_DEFAULT_CONNECT_DESCRIPTOR', "gort.fit.vutbr.cz:1521/orclpdb.gort.fit.vutbr.cz")
service_port = port=os.environ.get('PORT', '1521')

@app.route('/')
def index():
    # connection = cx_Oracle.connect(db_user, db_password, db_connect)
    # cur = connection.cursor()
    # cur.execute("SELECT * FROM PLAYER")
    # players = cur.fetchall()
    # cur.close()
    # connection.close()
    return render_template("index.html")

@app.route('/players')
def players():
    # connection = cx_Oracle.connect(db_user, db_password, db_connect)
    # cur = connection.cursor()
    # cur.execute("SELECT * FROM PLAYER")
    # players = cur.fetchall()
    # cur.close()
    # connection.close()
    return render_template("players.html", players=[(1, 'Alex', 12, 6), (2, 'Matej', 42, 3)])


if __name__ == '__main__':
    app.run()
