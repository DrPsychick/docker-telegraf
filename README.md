# [Docker image: drpsychick/telegraf](https://hub.docker.com/r/drpsychick/telegraf/)

[![Docker image](https://img.shields.io/docker/image-size/drpsychick/telegraf?sort=date)](https://hub.docker.com/r/drpsychick/telegraf/tags)
[![CircleCI](https://img.shields.io/circleci/build/github/DrPsychick/docker-telegraf)](https://app.circleci.com/pipelines/github/DrPsychick/docker-telegraf)
[![DockerHub pulls](https://img.shields.io/docker/pulls/drpsychick/telegraf.svg)](https://hub.docker.com/r/drpsychick/telegraf/)
[![GitHub stars](https://img.shields.io/github/stars/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf)
[![DockerHub stars](https://img.shields.io/docker/stars/drpsychick/telegraf.svg)](https://hub.docker.com/r/drpsychick/telegraf/)
[![Contributors](https://img.shields.io/github/contributors/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/graphs/contributors)
[![Paypal](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FTXDN7LCDWUEA&source=url)
[![GitHub Sponsor](https://img.shields.io/badge/github-sponsor-blue?logo=github)](https://github.com/sponsors/DrPsychick)

[![GitHub last commit (branch)](https://img.shields.io/github/last-commit/drpsychick/docker-telegraf/master.svg)](https://github.com/drpsychick/docker-telegraf)
[![license](https://img.shields.io/github/license/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/pulls)
[![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/drpsychick/docker-telegraf.svg)](https://github.com/drpsychick/docker-telegraf/pulls?q=is%3Apr+is%3Aclosed)


based on telegraf:alpine docker image

## Purpose
* make it fully configurable through environment variables
* use one image to run them all
* run stateless, environment configured containers (see https://12factor.net/)

## Usage

### **UPDATE 2021-04-28**
**BC Breaking Change** in the environments:

The image is now using a small go utility (`toml_update`) to read, modify and write a valid `toml` configuration file.
```shell
# before
conf_templates="telegraf.conf.tmpl:/etc/telegraf/telegraf.conf"
conf_var_prefix=TEL_
conf_vars_telegrafconf=${conf_vars_telegrafconf:-'TEL_GLOBAL_TAGS TEL_AGENT TEL_OUTPUTS TEL_PROCESSORS TEL_AGGREGATORS TEL_INPUTS'}
TEL_AGENT_HOSTNAME=hostname = "myhostname"
TEL_OUTPUTS_INFLUXDB_URLS=urls = ["http://yourinfluxhost:8086"]
TEL_INPUTS_CPU_FLAGS = "percpu = true\ntotalcpu = true"
# after
CONF_UPDATE=/etc/telegraf/telegraf.con
CONF_PREFIX=TEL
TEL_AGENT_NAMEDOESNOTMATTER=agent.hostname=myhostname
TEL_REALLYDOESNOTMATTER=outputs.influxdb.urls=["https://yourinfluxhost:8086"]
TEL_CPUFLAG1=inputs.cpu.percpu=true
TEL_CPUFLAG2=inputs.cpu.totalcpu=true
```

Try it in 3 steps

### 1 create your own telegraf.env
```
docker run --rm -it drpsychick/telegraf:latest cat /default.env > telegraf.env
```

### 2 configure it
Edit at least your hostname and output (influxdb or sth. else) in `telegraf.env`:
```
TLG_AGENT_HOSTNAME=agent.hostname="myhostname"
TLG_INFLUXDB_URL=outputs.influxdb.urls=["http://yourinfluxhost:8086"]
```

You can add as many variables as you want for more inputs and their configuration, there are only a few rules:
1. the variable must start with a known prefix (the `CONF_PREFIX` variable in `default.env`) 
2. the value must be a single row - due to Docker environment variables restrictions
3. use one variable for each setting 

For more examples see `default.env`
```
TLG_INPUTS_CPU_PERCPU=inputs.cpu.percpu=true
TLG_INPUTS_CPU_TOTAL=inputs.cpu.totalcpu=true
TLG_INPUTS_CPU_TIME=inputs.cpu.collect_cpu_time=false
TLG_INPUTS_CPU_ACTIVE=inputs.cpu.report_active=false
```
The `toml_update` tool will take the configured prefixes in order and update the configuration file from all matching variables one-by-one.

### 3 test and run it
Run in a separate teminal
```
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/telegraf:latest telegraf --test
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/telegraf:latest
```

Check your influxdb for new input

## Configure it to your needs
You can use any `TLG_` variable in your `telegraf.env`. They will be added to the config during container startup.

### Example 
```
TLG_INPUTS_DISK_FLAGS=inputs.disk.ignore_fs=["tmpfs", "devtmpfs", "devfs"]
```

## Run as `root`
Some plugins require root privileges to work, for example `smart`. You can simply start this container as root.

```shell
docker run --user root [...] --name telegraf-root drpsychick/telegraf:latest
```


**Beware**:

Docker only support *simple variables*. No ", no ' and especially no newlines in variables.
