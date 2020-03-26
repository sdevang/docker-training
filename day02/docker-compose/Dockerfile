# Build an image starting with the Python 3.7 image.
FROM python:3.7-alpine

# Set the working directory to /code.
WORKDIR /code

# Set environment variables used by the flask command.
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0

# Copy requirements.txt and install the Python dependencies.
RUN apk add --no-cache gcc musl-dev linux-headers

# Copy the current directory . in the project to the workdir . in the image.
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .

# Set the default command for the container to flask run.
CMD ["flask", "run"]