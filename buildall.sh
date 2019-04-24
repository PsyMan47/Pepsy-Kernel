#!/bin/bash

NAME="Pepsy-Kernel"
VERSION="-v1.8 EAS"

curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$NAME$VERSION build started!" -d chat_id=@pepsykernel;
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Changelog:" -d chat_id=@pepsykernel;
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$(cat changelog.txt)" -d chat_id=@pepsykernel;

bash builder-mi5.sh
bash builder-mi5s.sh
bash builder-mi5splus.sh
bash builder-mimix.sh
bash builder-minote2.sh

