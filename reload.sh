#!/bin/bash

zip -r ../diffbot-api-profile * -x "../diffbot-api-profile/.git/*" "log*.txt" "CLAUDE.md"
rm ../diffbot-api-profile.apip
mv ../diffbot-api-profile.zip ../diffbot-api-profile.apip