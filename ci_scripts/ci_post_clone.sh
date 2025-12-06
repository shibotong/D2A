#!/bin/sh

# Add Secret
echo '{ "stratzToken": "'"$STRATZTOKEN"'" }' > ../Shared/Backend/GraphQL/secrets.json
