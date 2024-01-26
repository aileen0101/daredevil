import json

from db import db
from db import User
from db import Goal

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


# -- USER ROUTES ---------------------------------------------------------------
@app.route("/")
@app.route("/api/users/", methods=["GET"])
def get_users():
    """
    Endpoint for getting all users
    """
    users = [user.serialize() for user in User.query.all()]
    return success_response({"users": users})


@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    Endpoint for creating a new user.
    """
    body = json.loads(request.data)
    input_name = body.get("name")

    if input_name is None:
        return failure_response("Missing name field!", 400)
    new_user = User(
        name=input_name,
    )
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)


# -- GOAL ROUTES ---------------------------------------------------------------
@app.route("/api/users/<int:user_id>/goal/", methods=["POST"])
def create_goal(user_id):
    """
    Endpoint for creating a goal for a user.
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    title = body.get("title")
    description = body.get("description")
    done = body.get("done")
    if title is None or description is None or done is None:
        return failure_response("Missing field!", 400)
    goal = Goal(title=title, description=description, done=done, user_id=user_id)
    db.session.add(goal)
    db.session.commit()
    return success_response(goal.serialize(), 201)


@app.route("/api/users/<int:user_id>/goal/all/", methods=["GET"])
def get_all_goals(user_id):
    """
    Endpoint for getting all goals of a specific user.
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    user_dict = user.serialize()
    goals = user_dict["goals"]
    return success_response({"goals": goals})


@app.route("/api/goals/<int:goal_id>/", methods=["POST"])
def mark_goal_complete(goal_id):
    """
    Endpoint for marking a user's specific goal as completed.
    """
    goal = Goal.query.filter_by(id=goal_id).first()
    if goal is None:
        return failure_response("Goal not found!")
    body = json.loads(request.data)
    done = body.get("done")
    if done is None:
        return failure_response("Missing field!", 400)
    # goal.update_goal_by_id(done)
    goal.done = done
    db.session.commit()
    return success_response(goal.serialize(), 201)


@app.route("/api/<int:user_id>/goals/uncompleted/", methods=["GET"])
def get_uncompleted_goals(user_id):
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
    return success_response({"uncompleted goals": uncompleted_goals})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
