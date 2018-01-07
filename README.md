# docker-telegraf

based on telegraf:alpine docker image

Purpose:
* make it fully configurable through environment variables
* use one image to run them all
* run stateless, environment configured containers (see https://12factor.net/)

## Usage

Try it in 3 steps

### 1 create your own telegraf.env
```
docker run --rm -it drpsychick/docker-telegraf:latest --test
docker run --rm -it drpsychick/docker-telegraf:latest --export > telegraf.env
```

### 2 configure it
Edit at least your hostname and output (influxdb or sth. else) in `telegraf.env`:
```
TEL_AGENT_HOSTNAME=hostname = "myhostname"
TEL_OUTPUTS_INFLUXDB_URLS=urls = ["http://yourinfluxhost:8086"]
```

### 3 test and run it
Run in a separate teminal
```
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/docker-telegraf:latest --test
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/docker-telegraf:latest telegraf --test
docker run --rm -it --cap-add NET_ADMIN --env-file telegraf.env --name telegraf-1 drpsychick/docker-telegraf:latest
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

Docker only support "simple variables. No ", no ' and especially no newlines in variables.
To define a multiline variable, look at the `TEL_INPUTS_CPU_FLAGS` variable in the example output.
