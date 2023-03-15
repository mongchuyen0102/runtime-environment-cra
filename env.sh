#!/bin/sh

sed -i 's#__API_URL__#'"$API_URL"'#g' env.js

exec "$@"