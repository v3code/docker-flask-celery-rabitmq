import os

import celery.states as states
from flask import Flask, Response
from flask import url_for, jsonify
from api.worker import celery

dev_mode = True
app = Flask(__name__)


@app.route('/check/<string:task_id>')
def check_task(task_id: str) -> str:
    res = celery.AsyncResult(task_id)
    if res.state == states.PENDING:
        return res.state
    else:
        return str(res.result)


@app.route('/health_check')
def health_check() -> Response:
    return jsonify("OK")


def run_server():
    port = os.environ.get('PORT', 5001)
    host = os.environ.get('HOST', '0.0.0.0')
    app.run(host=host, port=port)


if __name__ == '__main__':
    run_server()
