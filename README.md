[![Build Status](https://travis-ci.com/naryl/dithcord-tui.svg?branch=master)](https://travis-ci.com/naryl/dithcord-tui)

FAQ
===

What's this?
------------

Heavily WIP, but will eventually become an ncurses Discord client able to use
either bot or user account.

Currently dumps all messages you receive on all channels and all servers on
screen. Tested only on Linux+SBCL.

Is it a self-bot?
-----------------

Self-bot is the opposite of what Dithcord is. Self-bot is an automated user
account. Dithcord doesn't automate and is mostly tested with bot accounts. It
can use a user account too but...

So it's more like a 3rd-party Discord client?
---------------------------------------------

Kinda, except Discord's Terms of Service explicitly forbid implementing
3rd-party clients, so we legally can't introduce the bot as a user account. The
main differences between bot accounts and user accounts are outlined here:
(https://discordapp.com/developers/docs/topics/oauth2#bot-vs-user-accounts)

Installation
============

1. Install [quicklisp](https://www.quicklisp.org/beta/) if you haven't already.

2. Get [dithcord](https://github.com/naryl/dithcord/),
[lispcord](https://github.com/lispcord/lispcord), and
[cl-tui](https://github.com/naryl/cl-tui) and this repo into
~/quicklisp/local-projects

3. Run start.sh
