from wtforms import StringField, validators, IntegerField, SelectField
from flask_wtf import FlaskForm


class CharacterInsertForm(FlaskForm):
    player = SelectField('Player', coerce=int)
    name = StringField('Name', [validators.Length(min=4, max=25)])
    race = StringField('Race', [validators.Length(min=2, max=25)])
    c_class = StringField('Class')
    level = IntegerField('Level')
