from wtforms import StringField, validators, SubmitField
from flask_wtf import FlaskForm


class MapInsertForm(FlaskForm):
    name = StringField('Name', [validators.Length(min=3)])
    scale = StringField('Scale', [validators.Length(min=3)])
    submit = SubmitField('Přidat')

