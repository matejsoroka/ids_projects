from flask_login import UserMixin
from model import model

model = model.Model()


class User(UserMixin):

    def __init__(self, user_id):
        self.id = user_id
        user = model.get_row("player", user_id)
        self.name = user[1]
        self.role = user[6]

    def get_name(self):
        return self.name

    def get_role(self):
        return self.role

    def __repr__(self):
        return {"id": self.id, "username": self.name, "role": self.role}
