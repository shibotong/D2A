#!/bin/sh

# Add Secret
echo '{ "stratzToken": "'"$STRATZTOKEN"'" }' > ../Resources/graphql/secrets.json
