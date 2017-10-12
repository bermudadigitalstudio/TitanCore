# A Dockerfile for running Swift unit tests inside an Ubuntu Linux container
FROM swift:4

WORKDIR /code

COPY Package@swift-4.0.swift /code/Package.swift
RUN swift package resolve

# Assuming that tests change less than code, so put Tests before Sources copy
COPY ./Tests /code/Tests
COPY ./Sources /code/Sources
RUN swift --version
CMD swift test
