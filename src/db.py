from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import datetime
import hashlib
import os
import bcrypt

db = SQLAlchemy()


class User(db.Model):
    """
    User Model
    """

    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    goals = db.relationship("Goal", cascade="delete")

    # Authentication information -- User info
    email = db.Column(db.String, nullable=False, unique=True)
    password_digest = db.Column(db.String, nullable=False)

    # Authentication information -- Session info
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        """
        Initialize a User Object
        """
        self.name = kwargs.get("name", "")
        self.email = kwargs.get("email")
        self.password_digest = bcrypt.hashpw(
            kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13)
        )
        self.renew_session()

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

    # Authentication methods
    def _urlsafe_base_64(self):
        """
        Randomly generates hashed tokens (used for session/update tokens)
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()

    def renew_session(self):
        """
        Renews the session, i.e.
        1. Creates a new session token
        2. Sets the expiration time of the session to be a day from now
        3. Creates a new update token
        """
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        """
        Verifies the password of a user.
        """
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    def verify_session_token(self, session_token):
        """
        Verifies the session token of a user.
        """
        return (
            session_token == self.session_token
            and datetime.datetime.now() < self.session_expiration
        )

    def verify_update_token(self, update_token):
        """
        Verifies the update token of a user
        """
        return update_token == self.update_token


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
        self.user_id = kwargs.get("user_id", 0)

    def serialize(self):
        """
        Serialize an Goal object.
        """
        user = User.query.filter_by(id=self.user_id).first()
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "done": self.done,
            "goal": user.simple_serialize(),
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

    def update_goal_by_id(self, is_done):
        """
        Update a Goal object.
        """
        self.done = is_done
