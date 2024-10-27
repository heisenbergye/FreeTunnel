FROM python:3.12-slim

WORKDIR /opt

COPY ./app .

### install requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

ENV SERVICE_PORT 8080

CMD ["python3", "app.py"]