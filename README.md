# FreeTunnel

FreeTunnel是一款免费、安全、高效的内网穿透解决方案，无需复杂配置，即可让您轻松将内网服务暴露到互联网，适合开发测试和临时分享，支持命令行和容器两种使用方式。

FreeTunnel is a powerful tool for exposing your private services to the Internet via subdomains base on `gradio.live`.It provides URLs valid for 72 hours. With both command-line and container options available, setup is quick and easy. Whether for development testing or temporary sharing, FreeTunnel offers a free, secure, and efficient solution for network tunneling. Connect your local services to the world instantly with FreeTunnel!

### CLI

1. service bind to 0.0.0.0
```
$ ss -ltnp
State            Recv-Q           Send-Q                       Local Address:Port                       Peer Address:Port           Process                                       
LISTEN           0                4096                                     *:9090                                  *:*                                                    
LISTEN           0                4096                                     *:3000                                  *:* 
```
2. Execute on the EC2 instance where Grafana is deployed to expose the local Grafana service.
```
$ python3 cli/free-tunnel.py -p 3000                                
sevice access url: https://3d3c76fbf3a01ec384.gradio.live, it will keep available for 72h

$ sudo docker run -e SERVICE_PORT=3000 --network=host docker.io/heisenbergye/free-tunnel
```

### kubernetes

1. add free-tunnel as sidecar container sharing network namespace with grafna
```
......
    spec:
      containers:
      - image: docker.io/heisenbergye/free-tunnel
        imagePullPolicy: Always
        name: free-tunnel
        env:
        - name: SERVICE_PORT
          value: '3000'
      - name: grafana
        image: docker.io/grafana/grafana:9.3.6
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 3000
          name: http-grafana
          protocol: TCP
......

```

2. deploy and get url

```
$ kubectl replace -f grafana.yaml
$ kubectl logs grafana-xxxx -c free-tunnel
2024-10-27 03:24:05,537 - INFO - HTTP Request: GET https://api.gradio.app/v2/tunnel-request "HTTP/1.1 200 OK"
2024-10-27 03:24:05,553 - INFO - sevice access url：https://fcbb7df6b1e1f7539a.gradio.live, it will keep available for 72h
2024-10-27 03:24:15,554 - INFO - requesting new url...
2024-10-27 03:24:16,602 - INFO - HTTP Request: GET https://api.gradio.app/v2/tunnel-request "HTTP/1.1 200 OK"
2024-10-27 03:24:16,616 - INFO - sevice access url：https://a53531df0d962fed16.gradio.live, it will keep available for 72h
```
