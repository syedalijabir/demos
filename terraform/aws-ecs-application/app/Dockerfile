FROM python:alpine
WORKDIR /app

RUN apk add curl jq

COPY . .
RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 5000
CMD [ "scripts/run.sh" ]