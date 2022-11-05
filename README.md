# LoL Team Creator

## Table of contents

- [General info](#general-info)
- [Technologies](#technologies)
- [Setup](#setup)

## General info

Simple web app that helps generating teams for Leauge of Legends:tm: custom games.

The App queries euw.whatismymmr.com to get player's match making ranking and then generates most balanced teams of 5.

## Technologies

Project is created with:

- Ruby 3.1.0
- Sinatra 3.0.1

## Setup

To run this project, clone the repo:

$ cd lol-team-creator/
$ bundle install
$ ruby app.rb -p 8888

Then open http://localhost:8888/
