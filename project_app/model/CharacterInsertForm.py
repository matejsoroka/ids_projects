from wtforms import StringField, validators, IntegerField, SelectField
from flask_wtf import FlaskForm


class CharacterInsertForm(FlaskForm):
    player = SelectField('Player', coerce=int)
    name = StringField('Name', [validators.Length(min=4, max=25)])
    race = SelectField('Race', coerce=int)
    c_class = StringField('Class')
    level = IntegerField('Level')
