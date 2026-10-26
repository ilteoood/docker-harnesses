#!/bin/bash

apt-get update
apt-get full-upgrade -y
apt-get install curl git gnupg wget python3 procps jq unzip build-essential -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

. "$HOME/.cargo/env"

mkdir -p -m 755 /etc/apt/keyrings \
&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
&& cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& mkdir -p -m 755 /etc/apt/sources.list.d \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \

curl -sL https://raw.githubusercontent.com/kerolloz/go-installer/master/go.sh | bash

apt-get update
apt-get install gh -y
gh auth setup-git
gh extension install github/gh-stack

npm i -g skills pnpm @opencode/cli lighthouse

skills add https://github.com/ilteoood/harness -g -a pi -y

pi install npm:pi-wakatime
pi install npm:@upstash/context7-pi
pi install npm:pi-mcp-adapter
pi install npm:pi-hermes-memory
pi install npm:pi-lens
pi install npm:pi-subagents
pi install npm:@narumitw/pi-plan-mode
pi install npm:@juicesharp/rpiv-ask-user-question
pi install npm:@juicesharp/rpiv-todo
pi install npm:@quintinshaw/pi-dynamic-workflows
pi install npm:pi-web-access
pi install npm:pi-intercom
pi install npm:pi-goal-x
pi install npm:pi-simplify
pi install npm:@dietrichgebert/ponytail
pi install npm:pi-hashline-edit-pro
pi install npm:pi-btw
pi install npm:pi-keep-going
pi install npm:opencode-zen-oauth
pi install npm:billion-context
pi install npm:opencode-pi

npx impeccable install --providers=pi --scope=global --global

pi update --all

#gh release download --pattern "*aarch64-linux*" -O /tmp/tokensave.tar.gz -R aovestdipaperino/tokensave
#tar -xzf /tmp/tokensave.tar.gz -C /usr/local/bin
#rm /tmp/tokensave.tar.gz
#chmod +x /usr/local/bin/tokensave
#tokensave install --agent pi --git-hook global

git config --global user.email "matteopietro.dazzi@gmail.com"
git config --global user.name "Matteo Pietro Dazzi"

paseo plugin add nkwib/doc-viewer || echo 'Already installed'
paseo plugin add ilteoood/opencode-zen-usage || echo 'Already installed'
paseo plugin update --all --yes
paseo daemon run
