from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class User(db.Model):
    """
    User Model
    """

    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    goals = db.relationship("Goal", cascade="delete")

    def __init__(self, **kwargs):
        """
        Initialize a User Object
        """
        self.name = kwargs.get("name", "")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "goals": [g.simple_serialize() for g in self.goals],
        }

    def simple_serialize(self):
        return {
            "id": self.id,
            "name": self.name,
        }


class Goal(db.Model):
    """
    Goal Model
    """

    __tablename__ = "goal"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    done = db.Column(db.Boolean, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    def __init__(self, **kwargs):
        """
        Initialize an Goal object.
        """
        self.title = kwargs.get("title", "")
        self.description = kwargs.get("description", "")
        self.done = kwargs.get("done", False)

    def serialize(self):
        """
        Serialize an Goal object.
        """
        user = User.query.filter_by(id=self.user_id).first()
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "course": user.simple_serialize(),
        }

    def simple_serialize(self):
        """
        Serialize an Goal object without the course field.
        """
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "done": self.done,
        }
