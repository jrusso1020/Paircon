from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin

from sim_algo_v1 import *
import sys

app = Flask(__name__)
app.config['CORS_HEADERS'] = 'Content-Type'

cors = CORS(app, resources={r"/similiarity/v1/*": {"origins": "*"}})

@app.route('/similiarity/v1/compare', methods = ['POST'])
def compare_papers():
  """
  Method to compare two papers and return their similiarity score
  """
  resp = None
  if request.headers['Content-Type'] == 'application/json':
    app.logger.debug(request.data)
    data = request.get_json()
    similiarities = Cosine_Similiarity().compute_cosine_sim(data["user_dir"], data["conference_dir"], data["k"])
    resp = jsonify(similiarities)
    resp.status_code = 200

  else:
    message = {
            'status': 404,
            'message': 'Incorrect Content-Type',
    }
    resp = jsonify(message)
    resp.status_code = 404

  return resp


@app.before_request
def before():
    pass

@app.after_request
def after(response):
  app.logger.debug(response.data)
  return response

app.run(debug=True)