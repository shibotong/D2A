#!/bin/sh

# Add Secret
echo '{ "stratzToken": "'"$STRATZTOKEN"'" }' >> ../Shared/GraphQL/secrets.json
