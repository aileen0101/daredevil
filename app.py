import json

from db import db
from db import User

from flask import Flask, request

app = Flask(__name__)
db_filename = "daredevil.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


# generalized response formats
def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code


# your routes here
###### user routes ######
@app.route("/")
@app.route("/api/users/", methods = ["GET"])
def get_users():
    """
    Endpoint for getting all users
    """
    users = [user.serialize() for user in User.query.all()]
    return success_response ({"users": users}) 

@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    Endpoint for creating a new user.
    """
    body = json.loads(request.data)
    input_name = body.get("name")
    
    if (
        input_name is None
    ):
        return failure_response("Missing name field!", 400)
    new_user = User(
        name=input_name,
    )
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

####### goal routes ######
@app.route("/api/<int:user_id>/goals/uncompleted/", methods = ["GET"])
def get_uncompleted_goals():
    """
    Endpoint for getting uncompleted goals of a user
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")
    uncompleted_goals = []
    user_goals = user.serialize().get("goals")
    for goal in user_goals:
        if goal.get("done") == False:
            uncompleted_goals.append(goal)
    return success_response ({"uncompleted goals": uncompleted_goals}) 