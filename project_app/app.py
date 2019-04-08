from flask import Flask, render_template, request, url_for, redirect
from model import PlayerInsertForm, AdventureInsertForm
import cx_Oracle
import os

app = Flask(__name__)

db_user = os.environ.get('DBAAS_USER_NAME', 'xsorok02')
db_password = os.environ.get('DBAAS_USER_PASSWORD', 'CJiBvpmS')
db_connect = os.environ.get('DBAAS_DEFAULT_CONNECT_DESCRIPTOR', "gort.fit.vutbr.cz:1521/orclpdb.gort.fit.vutbr.cz")
service_port = port = os.environ.get('PORT', '1521')


@app.route('/')
def index():
    return render_template("index.html")


@app.route('/adventures')
def adventures():
    connection = cx_Oracle.connect(db_user, db_password, db_connect)
    cur = connection.cursor()
    cur.execute("SELECT * FROM ADVENTURE")
    fetch = cur.fetchall()
    cur.close()
    connection.close()
    return render_template("adventures.html", adventures=fetch)


@app.route('/adventure-add', methods=('GET', 'POST'))
def adventure_add():
    connection = cx_Oracle.connect(db_user, db_password, db_connect)
    cur = connection.cursor()
    cur.execute("SELECT * FROM AUTHOR")
    authors = cur.fetchall()
    form = AdventureInsertForm.AdventureInsertForm()
    insert_authors = []
    for author in authors:
        insert_authors.append((int(author[0]), author[1]))
    form.authors.choices = insert_authors

    cur.execute("SELECT * FROM LOCATION")
    locations = cur.fetchall()
    insert_location = []
    for location in locations:
        insert_location.append((int(location[0]), location[1]))
    form.location.choices = insert_location

    cur.execute("SELECT * FROM GAME_ELEMENT")
    game_elements = cur.fetchall()
    insert_game_element = []
    for game_element in game_elements:
        insert_game_element.append((int(game_element[0]), game_element[1]))
    form.game_elements.choices = insert_game_element

    if form.validate_on_submit():
        print(form)
        return redirect(url_for('adventures'))
    cur.close()
    connection.commit()
    connection.close()
    return render_template("adventure_add.html", form=form)


@app.route('/delete-adventure/<id>')
def delete_adventure(id):
    connection = cx_Oracle.connect(db_user, db_password, db_connect)
    cur = connection.cursor()
    cur.execute("DELETE FROM ADVENTURE WHERE adventure_id={}".format(id))
    cur.close()
    connection.commit()
    connection.close()
    return redirect(url_for('adventures'))


@app.route('/players')
def players():
    connection = cx_Oracle.connect(db_user, db_password, db_connect)
    cur = connection.cursor()
    cur.execute("SELECT * FROM PLAYER")
    fetch = cur.fetchall()
    cur.close()
    connection.close()
    return render_template("players.html", players=fetch)


@app.route('/delete-player/<id>')
def delete_player(id):
    connection = cx_Oracle.connect(db_user, db_password, db_connect)
    cur = connection.cursor()
    cur.execute("DELETE FROM PLAYER WHERE player_id={}".format(id))
    cur.close()
    connection.commit()
    connection.close()
    return redirect(url_for('players'))


@app.route('/player/<id>')
def player(id):
    connection = cx_Oracle.connect(db_user, db_password, db_connect)
    cur = connection.cursor()
    cur.execute("SELECT * FROM PLAYER WHERE player_id={}".format(id))
    player_data = cur.fetchone()
    cur.execute("SELECT CHARACTER.CHARACTER_ID, CHARACTER.NAME, COUNT(*) as adventure_count "
                "FROM CHARACTER, CHARACTER_ADVENTURE "
                "WHERE CHARACTER.PLAYER_ID = {} AND "
                "CHARACTER_ADVENTURE.CHARACTER_ID = CHARACTER.CHARACTER_ID "
                "GROUP BY CHARACTER.CHARACTER_ID, CHARACTER.NAME ORDER BY adventure_count DESC".format(id))
    character_data = cur.fetchall()
    cur.close()
    connection.close()
    return render_template("player.html", player=player_data, characters=character_data)


@app.route('/player-add', methods=('GET', 'POST'))
def player_add():
    form = PlayerInsertForm.PlayerInsertForm()
    if form.validate_on_submit():
        connection = cx_Oracle.connect(db_user, db_password, db_connect)
        cur = connection.cursor()
        query = "INSERT INTO PLAYER (NAME, GOLD, KILLS) VALUES ('{}', {}, {})".format(form.username.data,
                                                                                      form.gold.data,
                                                                                      form.kills.data)
        cur.execute(query)
        cur.close()
        connection.commit()
        connection.close()
        return redirect(url_for('players'))
    return render_template("player_add.html", form=form)


app.config['SECRET_KEY'] = 'foo'

if __name__ == '__main__':
    app.run()
