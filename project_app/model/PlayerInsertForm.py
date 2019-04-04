from wtforms import StringField, validators, IntegerField
from flask_wtf import FlaskForm


class PlayerInsertForm(FlaskForm):
    username = StringField('Username', [validators.Length(min=4, max=25)])
    gold = IntegerField('Gold')
    kills = IntegerField('Kills')