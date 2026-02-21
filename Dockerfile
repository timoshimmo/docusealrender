FROM ruby:3.3.3

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  curl \
  wget \
  libvips \
  libffi-dev \
  libyaml-dev

# Install PDFium
RUN apt-get install -y libpdfium-dev

# Install yarn
RUN npm install -g yarn

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY package.json ./
RUN yarn install

COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
