#!/bin/bash

echo "Generating traffic... Press [CTRL+C] to stop."

while true; do
  # Nazgûl (authorized) attempts to access the Palantir
  kubectl exec -n mordor deploy/nazgul -- curl -s -o /dev/null -w "Nazgûl request to /v1/palantir: %{http_code}\n" http://barad-dur/v1/palantir

  # Hobbit (unauthorized) attempts to access the Palantir
  kubectl exec -n mordor deploy/hobbit -- curl -s -o /dev/null -w "Hobbit request to /v1/palantir: %{http_code}\n" http://barad-dur/v1/palantir

  sleep 2
done