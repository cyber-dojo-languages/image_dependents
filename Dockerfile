FROM cyberdojo/ruby-base
LABEL maintainer=jon@jaggersoft.com

COPY .  /app

ENTRYPOINT [ "ruby", "/app/src/dependents.rb" ]
