# LoL Team Creator

Simple web app that helps with team generating for Leauge of Legends:tm: custom games.

## Table of contents

- [General info](#general-info)
- [Technologies](#technologies)
- [Setup](#setup)

## General info

The App queries [WhatIsMyMMR](https://euw.whatismymmr.com) to get player's match making ranking and then generates teams of 5 with smallest possible skill disparity.

## Technologies

Project is created with:

- Ruby 3.1.0
- Sinatra 3.0.1

## Setup

To run this project, clone the repo:

```
$ cd lol-team-creator/
$ bundle install
$ ruby app.rb -p 8888
```

Then open http://localhost:8888/
