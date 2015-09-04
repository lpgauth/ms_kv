#!/bin/bash
exec erl -sname ms_kv_dev \
         -pa ebin deps/*/ebin test \
         -config config/dev \
         -boot start_sasl \
         -s ms_kv_app \
         -setcookie secret
