from wtforms import StringField, validators, SubmitField, IntegerField, SelectField
from flask_wtf import FlaskForm


class EnemyInsertForm(FlaskForm):
    name = StringField('Name', [validators.Length(min=3)])
    level = IntegerField('Level')
    race = SelectField('Rasa', coerce=int)
    submit = SubmitField('Přidat')
