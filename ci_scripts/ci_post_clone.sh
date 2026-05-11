#!/bin/sh

# Create file

touch ../Resources/graphql/secrets.json

# Add Secret
echo '{ "stratzToken": "'"$STRATZTOKEN"'" }' > ../Resources/graphql/secrets.json
