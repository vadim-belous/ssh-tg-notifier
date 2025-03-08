#!/usr/bin/env bash

# Environment variables
TG_BOT_TOKEN="" # CHANGE ME
TG_API_ENDPOINT="https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage"
TG_CHAT_ID="" # CHANGE ME

IPINFO_TOKEN="" # CHANGE ME

TIME="$(date "+%H:%M:%S")"
DATE="$(date "+%d %B %Y")"

IP="$PAM_RHOST"
SERVICE="$PAM_SERVICE"
TTY="$PAM_TTY"
USER="$PAM_USER"
HOST="$HOSTNAME"

# Parse ipinfo.io response
GEO_JSON=$(curl -s ipinfo.io/$IP?token=$IPINFO_TOKEN)
CITY=$(echo "$GEO_JSON" | jq -r '.city // "Unknown"')
REGION=$(echo "$GEO_JSON" | jq -r '.region // "Unknown"')
COUNTRY=$(echo "$GEO_JSON" | jq -r '.country // "Unknown"')
ORG=$(echo "$GEO_JSON" | jq -r '.org // "Unknown"')

# Telegram message with formatting
TG_MESSAGE="🔥 User *$USER* logged into *$HOST*

*User:* \`$USER\`
*Hostname:* \`$HOST\`
*Time:* \`$TIME\` (GMT+3)
*Date:* \`$DATE\`

*IP:* \`$IP\`
*Location:* \`$CITY, $REGION, $COUNTRY\`
*ISP:* \`$ORG\`

*Service:* \`$SERVICE\`
*TTY:* \`$TTY\`"

# Main command to send message via curl http client
curl -s --max-time 10 --retry 5 --retry-delay 2 --retry-max-time 10 \
    -d "chat_id=$TG_CHAT_ID&text=$TG_MESSAGE&parse_mode=Markdown&disable_web_page_preview=true" \
    $TG_API_ENDPOINT > /dev/null 2>&1 &
