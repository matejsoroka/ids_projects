from wtforms import StringField, validators, PasswordField
from flask_wtf import FlaskForm


class PlayerInsertForm(FlaskForm):
    username = StringField('Username', [validators.Length(min=4, max=32)])
    password = PasswordField('Password', [validators.Length(min=6, max=32)])
    email = StringField('Email')