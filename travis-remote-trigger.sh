#!/bin/bash

# Trigger st2-docker-umccr travis build using Travis API
# See: https://docs.travis-ci.com/user/triggering-builds/

body='{
"request": {
"branch":"master"
}}'

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token $TRAVIS_ACCESS_TOKEN" \
   -d "$body" \
   https://api.travis-ci.org/repo/umccr%2Fst2-docker-umccr/requests
