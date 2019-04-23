from flask_login import UserMixin
from model import model

model = model.Model()


class User(UserMixin):

    def __init__(self, user_id):
        self.id = user_id
        user = model.get_row("player", user_id)
        self.name = user[1]
        self.role = "player"

    def __repr__(self):
        return "%d/%s/%s" % (self.id, self.name, self.role)
