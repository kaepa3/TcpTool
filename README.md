# how to use

## tcp server
gave args

```
$ ruby tcp_server.rb [ip] [port] [config yaml]
```

## tcp client

```
$ ruby tcp_client.rb [ip] [port] [config yaml]
```

## config yaml
setting this
```yml
file_loder_path : spec/test_dispatcher.yml #dispatch yaml path
cycle_files : # cycle setting
  - path : spec/test_text.txt #send filepath
    process : read_text       #send filekind
    time : 3                  #send file span
  - path : spec/test_text.txt
    process : read_text
    time : 2
```


## dispatch yaml

```yml
index : 2 #judge byte index
len : 2   #judge data size
dispatch :
  - code : 1283 #judge data value
    path : spec/test_text.txt #send file
    process : read_text       #file kind
```
