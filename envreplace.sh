#!/bin/sh
set -e 

TEL_AGENT_0=${TEL_AGENT_0:-'[agent]'}
TEL_AGENT_INTERVAL=${TEL_AGENT_INTERVAL:-'interval = "10s"\nround_interval = true'}
TEL_AGENT_METRIC=${TEL_AGENT_METRIC:-'metric_batch_size = 1000\nmetric_buffer_limit = 10000'}
TEL_AGENT_FLUSH=${TEL_AGENT_FLUSH:-'flush_interval = "10s"\nflush_jitter = "0s"'}
TEL_AGENT_HOSTNAME=${TEL_AGENT_HOSTNAME:-'hostname = "localhost"'}

TEL_OUTPUTS_INFLUXDB_0=${TEL_OUTPUTS_INFLUXDB_0:-'[[outputs.influxdb]]'}
TEL_OUTPUTS_INFLUXDB_URLS=${TEL_OUTPUTS_INFLUXDB_URLS:-'urls = ["http://localhost:8086"]'}
TEL_OUTPUTS_INFLUXDB_DATABASE=${TEL_OUTPUTS_INFLUXDB_DATABASE:-'database = "telegraf"'}

TEL_INPUTS_CPU_0=${TEL_INPUTS_CPU_0:-'[[inputs.cpu]]'}
TEL_INPUTS_CPU_FLAGS=${TEL_INPUTS_CPU_FLAGS:-'percpu = true\ntotalcpu = true\ncollect_cpu_time = false\nreport_active = false'}

# generate configuration files from templates
var_prefix=TEL_
conf_file=/etc/telegraf/telegraf.conf
conf_tmpl=telegraf.conf.tmpl

eval "$(cat $conf_tmpl)" > $conf_file

if [ "$1" = "--test" ]; then
  echo "$conf_file:"
  echo "=================="
  cat $conf_file
  echo

  echo "Variables:"
  echo "=========="
  for v in $(set |grep ^${var_prefix}|sed -e 's/^\('${var_prefix}'[^=]*\).*/\1/' |sort |tr '\n' ' ' ); do
    [ -z "$v" ] && continue
    value=$(eval echo -n \""\$$v"\")
    echo -e "$v=\"$value\""
  done
  exit 0
fi

# export variables suitable for input for --env-file
if [ "$1" = "--export" ]; then
  # fetch all defined ${var_prefix} variables
  for v in $(set |grep ^${var_prefix}|sed -e 's/^\('${var_prefix}'[^=]*\).*/\1/' |sort |tr '\n' ' '); do
    [ -z "$v" ] && continue
    # get value and replace all newlines with \n (docker only supports single line variables)
    value=$(eval echo -n \""\$$v"\")
    echo "$v=$(echo -n "$value" | awk '{if (NR>1) {printf "%s\\n", $0}} END {print $0}')"
  done
  exit 0
fi

/entrypoint.sh "$@"
