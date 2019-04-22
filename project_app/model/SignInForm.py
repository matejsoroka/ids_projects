from wtforms import StringField, validators, IntegerField
from flask_wtf import FlaskForm


class SignInForm(FlaskForm):
    username = StringField('Username', [validators.Length(min=4, max=32)])
    password = StringField('Password', [validators.Length(min=6, max=32)])