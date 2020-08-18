# [Docker image: telegraf](https://hub.docker.com/r/drpsychick/telegraf/)

[![DockerHub build status](https://img.shields.io/docker/cloud/build/drpsychick/telegraf.svg)](https://hub.docker.com/r/drpsychick/telegraf/builds/) [![DockerHub build](https://img.shields.io/docker/cloud/automated/drpsychick/telegraf.svg)](https://hub.docker.com/r/drpsychick/telegraf/builds/) [![DockerHub pulls](https://img.shields.io/docker/pulls/drpsychick/telegraf.svg)](https://hub.docker.com/r/drpsychick/telegraf/) [![GitHub stars](https://img.shields.io/github/stars/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf) [![DockerHub stars](https://img.shields.io/docker/stars/drpsychick/telegraf.svg)](https://hub.docker.com/r/drpsychick/telegraf/) 

[![Contributors](https://img.shields.io/github/contributors/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/graphs/contributors) [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/drpsychick/docker-telegraf/master.svg)](https://github.com/drpsychick/docker-telegraf) [![license](https://img.shields.io/github/license/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/issues) [![GitHub closed issues](https://img.shields.io/github/issues-closed/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/issues?q=is%3Aissue+is%3Aclosed) [![GitHub pull requests](https://img.shields.io/github/issues-pr/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/pulls) [![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/pulls?q=is%3Apr+is%3Aclosed)


based on telegraf:alpine docker image

## Purpose
* make it fully configurable through environment variables
* use one image to run them all
* run stateless, environment configured containers (see https://12factor.net/)

## Usage

Try it in 3 steps

### 1 create your own telegraf.env
```
docker run --rm -it drpsychick/telegraf:latest --test
docker run --rm -it drpsychick/telegraf:latest --export > telegraf.env
```

### 2 configure it
Edit at least your hostname and output (influxdb or sth. else) in `telegraf.env`:
```
TEL_AGENT_HOSTNAME=hostname = "myhostname"
TEL_OUTPUTS_INFLUXDB_URLS=urls = ["http://yourinfluxhost:8086"]
```

You can add as many variables as you want for more inputs and their configuration, there are only a few rules:
1. the variable must start with `TEL_` (the prefix) and must be a single row (can contain `\n` though)
2. if you use multiple variables to build an ordered section, be sure that the alphabetical order is correct.

For more examples see `default.env`
```
TEL_INPUTS_CPU_0=[[inputs.cpu]]
TEL_INPUTS_CPU_FLAGS=percpu = true\ntotalcpu = true\ncollect_cpu_time = false\nreport_active = false
```

### 3 test and run it
Run in a separate teminal
```
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/telegraf:latest --test
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/telegraf:latest telegraf --test
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/telegraf:latest
```

Check your influxdb for new input

## Configure it to your needs
You can use any `TEL_` variable in your `telegraf.env`. They will be added to the config during container startup.

### Example 
```
TEL_INPUTS_DISK_0=[[inputs.disk]]
TEL_INPUTS_DISK_FLAGS=ignore_fs = ["tmpfs", "devtmpfs", "devfs"]
```

**Beware**:

Docker only support *simple variables*. No ", no ' and especially no newlines in variables.
To define a multiline variable, look at the `TEL_INPUTS_CPU_FLAGS` variable in the example output.
