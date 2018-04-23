FROM ruby:2.3.1

RUN apt-get update
RUN apt-get install -y --no-install-recommends postgresql-client nodejs python-dev python-pip
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

# Install AWS CLI for S3
RUN pip install awscli
RUN mkdir /root/.local/bin -p
RUN ln -s /usr/local/bin/aws /root/.local/bin/aws

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
