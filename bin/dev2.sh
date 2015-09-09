#!/bin/bash
exec erl -sname ms_kv_dev2 \
         -pa ebin deps/*/ebin test \
         -config config/dev2 \
         -boot start_sasl \
         -s ms_kv_app \
         -setcookie secret
