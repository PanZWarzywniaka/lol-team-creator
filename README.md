# LoL Team Creator

Simple web app that helps with team generating for Leauge of Legends:tm: custom games.
<img src="https://user-images.githubusercontent.com/38562250/213929401-5c41bfa9-f5b1-48e7-956a-f19f30e5d754.png" width="1000" height="500">
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

## Screen shot



## Setup

To run this project, clone the repo:

```
$ cd lol-team-creator/
$ bundle install
$ ruby app.rb -p 8888
```

Then open http://localhost:8888/
