#so we used python for our base image cause we want to run a flask
FROM python:3
# we have to create some enviroment variable so the pipenv can run
ENV PYBASE /pybase 
ENV PYHTONUSERBASE $PYBASE 
ENV PATH $PYBASE/bin:$PATH
# we install pipenv
RUN pip install pipenv


#since we dont want the pipfile to not stay in our file we set the WORKDIR to tmp
WORKDIR /tmp
# we copy the pipfile from our current directory to the new WORKDIR and we use '.' cause we are alrady in the directory
COPY Pipfile .
#we run pipenv lock
RUN pipenv lock
#we use pip to install some of the things we need for the app to work
RUN PIP_USER=1 PIP_IGORE_INSTALLED=1 pipenv install -d --system --ignore-pipfile

#we copy all our files from host into the /app/notes directory of the container
COPY . /app/notes
#we set the /app/notes dir as our new WORKDIR
WORKDIR /app/notes
#we expose the port to port 80 so we can access the app from portthe host
EXPOSE 80
#we run our commands 
CMD ["flask", "run", "--port=80", "--host=0.0.0.0"]
