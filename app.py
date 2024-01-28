import json

from db import db
from db import User
from db import Goal
import users_dao
import datetime

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


def extract_token(request):
    """
    Helper function that extracts the token from the header of a request
    """
    auth_header = request.headers.get("Authorization")
    if auth_header is None:
        return False, failure_response("missing auth header")
    bearer_token = auth_header.replace("Bearer", "").strip()

    if not bearer_token:
        return False, failure_response("invalid auth header")

    return True, bearer_token


# your routes here


# -- AUNTHENTICATION -----------------------------------------------------------
@app.route("/register/", methods=["POST"])
def register_account():
    """
    Endpoint for registering a new user
    """
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password")

    if email is None or password is None:
        return json.dumps({"error": "Invalid email or password"})

    created, user = users_dao.create_user(email, password)

    if not created:
        return json.dumps({"error": "User already exists"})

    return json.dumps(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token,
        }
    )


@app.route("/login/", methods=["POST"])
def login():
    """
    Endpoint for logging in a user.
    """
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password")

    if email is None or password is None:
        return failure_response("Invalid email or passowrd", 400)

    success, user = users_dao.verify_credentials(email, password)

    if not success:
        return failure_response("Invalid email or password", 400)

    return json.dumps(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token,
        }
    )


@app.route("/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    success, update_token = extract_token(request)

    if not success:
        return update_token

    user = users_dao.renew_session(update_token)

    if user is None:
        return failure_response("invalid update token")

    return json.dumps(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token,
        }
    )


@app.route("/secret/", methods=["POST"])
def secret_message():
    """
    Endpoint for verifying a session token and returning a secret message.
    """
    success, session_token = extract_token(request)

    if not success:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return failure_response("invalid session token")

    return success_response({"message": "Implemented session token successfully"})


@app.route("/logout/", methods=["POST"])
def logout():
    """
    Endpoint for logging out a user.
    """
    success, session_token = extract_token(request)
    if not success:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)

    if not user or not user.verify_session_token(session_token):
        return failure_response("invalid session token", 400)

    user.session_expiration = datetime.datetime.now()
    db.session.commit()
    return success_response({"message": "User has successfully logged out."})


# -- USER ROUTES ---------------------------------------------------------------
@app.route("/")
def base_endpoint():
    """
    Endpoing for displaying welcome message.
    """
    return json.dumps({"message": "Welcome to Daredevil!"})


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
    return success_response({"uncompleted_goals": uncompleted_goals})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
