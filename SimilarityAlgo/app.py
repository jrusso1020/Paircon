from flask import Flask, request, jsonify
from sim_algo_v1 import *

app = Flask(__name__)

@app.route('/similiarity/v1/compare', methods = ['GET'])
def compare_papers():
  """
  Method to compare two papers and return their similiarity score
  """
  resp = None
  if request.headers['Content-Type'] == 'application/json':
    data = request.get_json()
    print(type(data))
    similiarity = Cosine_Similiarity().compute_cosine_sim(data["paper1"], data["paper2"])
    resp = jsonify( { 'similiarity': similiarity} )
    resp.status_code = 200

  else:
    message = {
            'status': 404,
            'message': 'Incorrect Content-Type',
    }
    resp = jsonify(message)
    resp.status_code = 404

  return resp

app.run(debug=True)