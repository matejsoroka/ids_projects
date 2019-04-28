from flask import Flask, flash, render_template, url_for, redirect
from model import PlayerInsertForm, AdventureInsertForm, CharacterInsertForm, SessionInsertForm, SignInForm, model, User
from model import AuthorInsertForm, EnemyInsertForm, EquipmentInsertForm, MapInsertForm
from flask_bcrypt import Bcrypt
from flask_login import LoginManager, login_required, login_user, logout_user, current_user

app = Flask(__name__)
model = model.Model()
bcrypt = Bcrypt(app)

# config
app.config.update(
    SECRET_KEY='foo'
)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'


@login_manager.user_loader
def load_user(user_id):
    return User.User(user_id) if model.get_row("player", user_id) else None


@app.route('/')
@login_required
def index():
    return render_template("index.html")


@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/adventures')
@login_required
def adventures():
    return render_template("adventures.html", adventures=model.get_table("adventure"))


@app.route('/adventure/<adventure_id>')
@login_required
def adventure(adventure_id):
    return render_template("adventure.html", adventure=model.get_adventure(adventure_id),
                           characters=model.get_adventure_characters(adventure_id))


@app.route('/sessions')
@login_required
def sessions():
    return render_template("sessions.html", sessions=model.get_table("sessions"))


@app.route('/session/<session_id>')
@login_required
def session(session_id):
    return render_template("session.html", session=model.get_session(session_id),
                           adventures=model.get_session_adventures(session_id))


@app.route('/session-add', methods=('GET', 'POST'))
@login_required
def session_add():
    form = SessionInsertForm.SessionInsertForm()
    #  setting default values for from elements
    form.adventures.choices = model.get_pairs("adventure")
    form.moderator.choices = model.get_pairs("player")
    form.moderator.process_data(current_user.get_id())

    if form.validate_on_submit():  # on form submit
        adventure_insert = {"date": form.date.data, "place": form.place.data, "moderator": form.moderator.data}
        model.insert("sessions", adventure_insert)
        session_id = model.get_last_id("sessions")
        for adv in form.adventures.data:
            model.insert("adventure_session", {"adventure_id": adv, "session_id": session_id})
        return redirect(url_for('adventures'))
    return render_template("session_add.html", form=form)


@app.route('/adventure-add', methods=('GET', 'POST'))
@login_required
def adventure_add():
    form = AdventureInsertForm.AdventureInsertForm()
    #  setting default values for form elements
    form.authors.choices = model.get_pairs("author")
    form.pj.choices = model.get_pairs("player")
    form.location.choices = model.get_pairs("location")
    form.game_elements.choices = model.get_pairs("game_element")
    form.characters.choices = model.get_pairs("character")
    form.pj.process_data(current_user.get_id())

    if form.validate_on_submit():  # on form submit
        adventure_insert = {"objective": form.objective.data, "difficulty": form.difficulty.data, "PJ_ID": form.pj.data,
                            "location_id": form.location.data}
        model.insert("adventure", adventure_insert)
        adventure_id = model.get_last_id("adventure")
        for author in form.authors.data:
            model.insert("adventure_author", {"adventure_id": adventure_id, "author_id": author})
        for char in form.characters.data:
            model.insert("character_adventure", {"adventure_id": adventure_id, "character_id": char})
        for game_element in form.game_elements.data:
            model.insert("adventure_game_element", {"adventure_id": adventure_id, "game_element": game_element})
        return redirect(url_for('adventures'))
    return render_template("adventure_add.html", form=form)


@app.route('/delete-adventure/<adventure_id>')
@login_required
def delete_adventure(adventure_id):
    if current_user.get_role() == "admin":
        model.delete_row('adventure', adventure_id)
        return redirect(url_for('adventures'))
    else:
        flash("Na tuto operaci nemáte oprávnění", "danger")
        return redirect(url_for('index'))


@app.route('/players')
@login_required
def players():
    return render_template("players.html", players=model.get_table("player"))


@login_manager.unauthorized_handler
def unauthorized():
    flash("Prosím, přihlaste se", "warning")
    return redirect(url_for('sign_in'))


@app.route('/delete-player/<player_id>')
@login_required
def delete_player(player_id):
    if current_user.get_role() == "admin":
        model.delete_row("player", player_id)
        return redirect(url_for('players'))
    else:
        flash("Na tuto operaci nemáte oprávnění", "danger")
        return redirect(url_for('index'))


@app.route('/delete-myself/')
@login_required
def delete_acc():
    user_id = current_user.get_id()
    model.delete_row("player", user_id)
    logout_user()
    flash("Užívatel byl uspěšně smazán", "success")
    return redirect(url_for('sign_in'))


@app.route('/player/<player_id>')
@login_required
def player(player_id):
    player_data = model.get_row("player", player_id)
    character_data = model.get_player_characters(player_id)
    champ = model.get_player_best_character(player_id)
    adv = model.get_pjs_adventures(player_id)
    return render_template("player.html", player=player_data, characters=character_data, champ=champ, adventures=adv)


@app.route('/character/<character_id>')
@login_required
def character(character_id):
    return render_template("character.html", character=model.get_character(character_id))


@app.route('/character-add/', methods=('GET', 'POST'))
@app.route('/character-add/<player_id>', methods=('GET', 'POST'))
def character_add(player_id=None):
    user_id = current_user.get_id()

    if current_user.get_role() == "admin" or user_id == player_id:
        form = CharacterInsertForm.CharacterInsertForm()
        form.player.choices = model.get_pairs('player')
        form.race.choices = model.get_pairs('race')
        form.player.process_data(player_id)
        if form.validate_on_submit():
            model.insert("character", {"name": form.name.data, "race": form.race.data, "class": form.c_class.data,
                                       "level": form.level.data, "player_id": form.player.data})
            return redirect(url_for('players'))
        return render_template("character_add.html", form=form)

    elif user_id != player_id:
        flash("Sem nesmíte", "danger")
        return redirect(url_for('index'))


@app.route('/admin/', methods=('GET', 'POST'))
@login_required
def admin():
    if current_user.get_role() != "admin":
        flash("Sem nesmíte", "danger")
        return redirect(url_for('index'))

    forms = {}

    forms["author"] = AuthorInsertForm.AuthorInsertForm()
    if forms["author"].validate_on_submit():
        model.insert("author", {"name": forms["author"].name.data})
        return redirect(url_for('admin'))

    forms["equipment"] = EquipmentInsertForm.EquipmentInsertForm()
    if forms["equipment"].validate_on_submit():
        model.insert("equipment", {"type": forms["equipment"].type.data})
        return redirect(url_for('admin'))

    forms["enemy"] = EnemyInsertForm.EnemyInsertForm()
    forms["enemy"].race.choices = model.get_pairs('race')
    if forms["enemy"].validate_on_submit():
        model.insert("game_element", {"name": forms["enemy"].name.data})
        element_id = model.get_last_element_id()
        model.insert("enemy", {"element_id": element_id, "level": forms["enemy"].level.data,
                               "race_id": forms["enemy"].race.data})
        return redirect(url_for('admin'))

    forms["maps"] = MapInsertForm.MapInsertForm()
    if forms["maps"].validate_on_submit():
        model.insert("game_element", {"name": forms["maps"].name.data})
        element_id = model.get_last_element_id()
        model.insert("map", {"scale": forms["maps"].scale.data, "element_id": element_id})
        return redirect(url_for('admin'))

    return render_template("admin.html", forms=forms)


@app.route('/sign-up', methods=('GET', 'POST'))
def sign_up():
    form = PlayerInsertForm.PlayerInsertForm()
    if form.validate_on_submit():
        model.insert("player", {"name": form.username.data,
                                "password": bcrypt.generate_password_hash(form.password.data).decode("utf-8"),
                                "email": form.email.data})
        return redirect(url_for('index'))
    return render_template("sign_up.html", form=form)


@app.route('/sign-in', methods=('GET', 'POST'))
def sign_in():
    form = SignInForm.SignInForm()
    if form.validate_on_submit():
        data = model.get_player_by_username(form.username.data)
        if data:
            if bcrypt.check_password_hash(data[5], form.password.data):
                user = User.User(data[0])
                login_user(user)
                flash('Přihlášení proběhlo úspěšně', "success")
                return redirect(url_for('index'))
            else:
                form.errors["Validace"] = ["Špatné heslo"]
        else:
            form.errors["Validace"] = ["Špatné přihlasovací jméno"]

    return render_template("sign_in.html", form=form)


if __name__ == '__main__':
    app.run()
