#!/bin/bash

echo "Generating traffic... Press [CTRL+C] to stop."

while true; do
  # TIE Fighter (authorized) attempts to access the exhaust port
  kubectl exec -n empire deploy/tiefighter -- curl -s -o /dev/null -w "TIE Fighter request to /v1/exhaust-port: %{http_code}\n" http://deathstar/v1/exhaust-port

  # X-Wing (unauthorized) attempts to access the exhaust port
  kubectl exec -n empire deploy/xwing -- curl -s -o /dev/null -w "X-Wing request to /v1/exhaust-port: %{http_code}\n" http://deathstar/v1/exhaust-port

  sleep 2
done