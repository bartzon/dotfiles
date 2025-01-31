#!/bin/sh

ping -c1 shopify.com > /dev/null

if [ $? -eq  0 ]
then
  exit 0
else
  say "No internet connection."
  echo "#[bg=red,fg=black]🔥 NO INTERNET CONNECTION 🔥#[fg=white,bg=black]"
  exit 1
fi
