from wtforms import StringField, validators, SelectMultipleField, DateTimeField
from flask_wtf import FlaskForm


class SessionInsertForm(FlaskForm):
    place = StringField("Place")
    date = DateTimeField("Date")
    adventures = SelectMultipleField("Adventures")
