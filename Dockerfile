FROM kylef/swiftenv:swift3

RUN mkdir -p /code
WORKDIR /code
ADD . /code

