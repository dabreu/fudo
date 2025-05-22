FROM ruby:3.2

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set app directory
WORKDIR /app

# Copy Gemfiles and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Expose the default Rack port (if using puma/thin)
EXPOSE 9292

# Default command (can be overridden in docker-compose)
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "9292"]
