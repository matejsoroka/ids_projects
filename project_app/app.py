from flask import Flask, render_template, url_for, redirect
from model import PlayerInsertForm, AdventureInsertForm, model

app = Flask(__name__)
model = model.Model()


@app.route('/')
def index():
    return render_template("index.html")


@app.route('/adventures')
def adventures():
    return render_template("adventures.html", adventures=model.get_table("adventure"))


@app.route('/adventure-add', methods=('GET', 'POST'))
def adventure_add():
    form = AdventureInsertForm.AdventureInsertForm()
    #  setting default values for from elements
    form.authors.choices = model.get_pairs("author")
    form.pj.choices = model.get_pairs("player")
    form.location.choices = model.get_pairs("location")
    form.game_elements.choices = model.get_pairs("game_element")

    if form.validate_on_submit():  # on form submit
        adventure_insert = {"objective": form.objective.data, "difficulty": form.difficulty.data, "PJ_ID": form.pj.data,
                            "location_id": form.location.data}
        model.insert("adventure", adventure_insert)
        adventure_id = model.get_last_id("adventure")
        for author in form.authors.data:
            model.insert("adventure_author", {"adventure_id": adventure_id, "author_id": author})
        for game_element in form.game_elements.data:
            model.insert("adventure_game_element", {"adventure_id": adventure_id, "game_element": game_element})
        return redirect(url_for('adventures'))
    return render_template("adventure_add.html", form=form)


@app.route('/delete-adventure/<id>')
def delete_adventure(id):
    model.cursor.execute("DELETE FROM ADVENTURE WHERE adventure_id={}".format(id))
    model.db.commit()
    return redirect(url_for('adventures'))


@app.route('/players')
def players():
    return render_template("players.html", players=model.get_table("player"))


@app.route('/delete-player/<id>')
def delete_player(id):
    model.cursor.execute("DELETE FROM PLAYER WHERE player_id={}".format(id))
    model.db.commit()
    return redirect(url_for('players'))


@app.route('/player/<id>')
def player(id):
    player_data = model.get_row("player", id)
    character_data = model.get_player_characters(id)
    return render_template("player.html", player=player_data, characters=character_data)


@app.route('/player-add', methods=('GET', 'POST'))
def player_add():
    form = PlayerInsertForm.PlayerInsertForm()
    if form.validate_on_submit():
        model.insert("player", {"name": form.username.data, "gold": form.gold.data, "kills": form.kills.data})
        return redirect(url_for('players'))
    return render_template("player_add.html", form=form)


app.config['SECRET_KEY'] = 'foo'

if __name__ == '__main__':
    app.run()
