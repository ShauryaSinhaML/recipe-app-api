FROM python:3.7-alpine
MAINTAINER Shaurya Sinha

# this line sets the environment as python unbuffred which is suggested as
# for running python in a docker container
ENV PYTHONUNBUFFERED 1

# here we will be copying requirements.txt from the current directory
# into our focker container in a file called requirements.txt
COPY ./requirements.txt /requirements.txt
# install postgresql client
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev
#we will eun the file in the container
RUN pip install -r /requirements.txt
# delete the temp dependencies
RUN apk del .tmp-build-deps

# we will create a directory in the container
RUN mkdir /app
# we will set it up as the work directory
WORKDIR /app
# we will copy the contents from the app folder on hardisk to the
# work directory in the container.
COPY ./app /app

# we add a user -d specifies that the user can only run applications
RUN adduser -D user
# switches docker to the user that we have just created for security
# as now the user is a scope which limits the access to the root of the container
USER user
