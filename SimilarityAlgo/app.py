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
    similiarities = Cosine_Similiarity().compute_cosine_sim_all(data["user_dir"], data["conference_dir"], data["k"])
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

@app.route('/similiarity/v1/compare/single', methods = ['POST'])
def compare_paper_to_conference():
  """
  Method to compare two papers and return their similiarity score
  """
  resp = None
  if request.headers['Content-Type'] == 'application/json':
    app.logger.debug(request.data)
    data = request.get_json()
    try:
      similiarities = Cosine_Similiarity().compute_cosine_sim_one(data["user_file"], data["conference_paths"])
      resp = jsonify(similiarities)
      resp.status_code = 200
    except Exception as e:
      resp = jsonify({'error': '{}'.format(e)})
      resp.status_code = 500

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

# run in debug mode
#app.run(debug=True)

# run in production multithreaded
app.run(host='0.0.0.0', threaded=True)