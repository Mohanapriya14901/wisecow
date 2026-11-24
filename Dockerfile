
FROM ubuntu:24.04

# Install application dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash \
       fortune-mod \
       fortunes-min \
       cowsay \
       netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Add the location of fortune and cowsay to PATH
ENV PATH="/usr/games:${PATH}"

# Set the working directory inside the container
WORKDIR /app

# Copy application script into the container
COPY wisecow.sh .

# Give execution permission
RUN chmod +x wisecow.sh

# Document the port used by the application
EXPOSE 4499

# Start the application when the container starts
CMD ["./wisecow.sh"]