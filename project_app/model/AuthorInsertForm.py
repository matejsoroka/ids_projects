from wtforms import StringField, validators, SubmitField
from flask_wtf import FlaskForm


class AuthorInsertForm(FlaskForm):
    name = StringField('Name', [validators.Length(min=4)])
    submit = SubmitField('Přidat')
