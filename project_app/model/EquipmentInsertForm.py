from wtforms import StringField, validators, SubmitField
from flask_wtf import FlaskForm


class EquipmentInsertForm(FlaskForm):
    type = StringField('Type', [validators.Length(min=4)])
    submit = SubmitField('Přidat')
