from wtforms import StringField, validators, SelectMultipleField, DateTimeField, SelectField
from flask_wtf import FlaskForm


class SessionInsertForm(FlaskForm):
    place = StringField("Place")
    date = DateTimeField("Date")
    moderator = SelectField("Moderator")
    adventures = SelectMultipleField("Adventures")
