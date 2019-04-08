from wtforms import StringField, validators, IntegerField, SelectMultipleField, SelectField
from flask_wtf import FlaskForm


class AdventureInsertForm(FlaskForm):
    objective = StringField('Objective', [validators.Length(min=4, max=25)])
    difficulty = IntegerField('Difficulty')
    location = SelectField('Location', coerce=int)
    authors = SelectMultipleField('Authors', coerce=int)
    game_elements = SelectMultipleField('Game elements', coerce=int)
    pj = SelectField('PJ', coerce=int)
