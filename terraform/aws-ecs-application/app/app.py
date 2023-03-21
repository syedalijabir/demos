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
from flask import Flask, render_template, request

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(('8.8.8.8', 80))
server_ip_address = s.getsockname()[0]

if os.environ.get("REDIS_HOST"):
    # Connect to Redis
    redis_client = redis.Redis(host=os.environ.get("REDIS_HOST"), port=6379, db=0)
    use_redis = True
else:
    use_redis = False


app = Flask(__name__)
app.request_count = 0

@app.before_request
def count_requests():
    app.request_count += 1
    if use_redis:
        redis_client.set('request_count', app.request_count)

@app.route('/')
def index():
    global server_ip_address
    if use_redis:
        visitor_number = redis_client.get('request_count').decode()
    else:
        visitor_number = app.request_count
    message = "You are visitor number: {}".format(visitor_number)
    if os.environ.get("REGION"):
        region = "Im located in {}".format(os.environ.get("REGION"))
    else:
        region = ""

    # Use Flask's render_template function to generate the HTML content
    html_content = render_template(
        'index.html',
        message=message,
        source_ip=request.remote_addr,
        my_ip=server_ip_address,
        region=region
    )

    # Save the generated HTML content as a static file on the server
    with open('static/index.html', 'w') as f:
        f.write(html_content)

    # Return the generated HTML content to the client
    return html_content

if __name__ == '__main__':
    app.run(host="0.0.0.0")
