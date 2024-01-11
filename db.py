from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    """
    User Model
    """
    __tablename__ = "user" 
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    name = db.Column(db.String, nullable = False)
    goals = db.relationship("Goal", cascade="delete")
    
    def __init__ (self, **kwargs):
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