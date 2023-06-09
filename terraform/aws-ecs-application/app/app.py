#!/usr/bin/env python
# vim: set syntax=python:
#
# Owner: Ali Jabir
# Email: syedalijabir@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import socket
import redis
from flask import Flask, render_template, request, make_response

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(('8.8.8.8', 80))
server_ip_address = s.getsockname()[0]

if os.environ.get("REDIS_URL"):
    # Connect to Redis
    host = os.environ.get("REDIS_URL").replace('tcp://','').split(':')[0]
    port = os.environ.get("REDIS_URL").replace('tcp://','').split(':')[1].split('/')[0]
    db = os.environ.get("REDIS_URL").replace('tcp://','').split(':')[1].split('/')[1]
    redis_client = redis.Redis(host=host, port=port, db=db)
    use_redis = True
else:
    use_redis = False


app = Flask(__name__, static_folder='static')
app.request_count = 0

@app.before_request
def count_requests():
    app.request_count += 1

@app.route('/')
def index():
    global server_ip_address
    if use_redis:
        if redis_client.exists('request_count'):
            visitor_number = redis_client.get('request_count').decode()
        else:
            visitor_number = 0
    else:
        visitor_number = app.request_count
    message = "You are visitor number: {}".format(visitor_number)
    # Update visitor number in redis
    redis_client.set('request_count', int(visitor_number)+1)

    if os.environ.get("REGION"):
        region = "Im located in {}".format(os.environ.get("REGION"))
    else:
        region = ""

    # Use Flask's render_template function to generate the HTML content
    html_content = render_template(
        'index.html',
        message=message,
        source_ip=request.headers.get('X-Forwarded-For', request.remote_addr), # AWS ALB forwarded client IP address
        my_ip=server_ip_address,
        region=region
    )

    # Save the generated HTML content as a static file on the server
    with open('static/index.html', 'w') as f:
        f.write(html_content)

    # Return the generated HTML content to the client
    return html_content

@app.route('/healthz')
def healthz():
    return make_response('Success', 200)


if __name__ == '__main__':
    app.run(host="0.0.0.0")
