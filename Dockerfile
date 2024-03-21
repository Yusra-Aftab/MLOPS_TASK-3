# Base image
FROM python:3.8-slim AS base

# Set working directory
WORKDIR /app

# Copy only requirements.txt to optimize caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Flask port
EXPOSE 5000

# Command to run the Flask application
CMD ["flask", "run", "--host=0.0.0.0"]

# Intermediate build stage for training the model
FROM base AS builder

# Install additional dependencies for model training
RUN pip install --no-cache-dir scikit-learn

# Train the model (replace this with your actual training code)
RUN python train_model.py

# Flask app stage
FROM base AS app

# Copy trained model from builder stage
COPY --from=builder /app/model.pkl /app

# Flask environment variable
ENV FLASK_APP=app.py

# Command to start the application
CMD ["flask", "run", "--host=0.0.0.0"]
