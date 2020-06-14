### Kong Plugin Dubbo Proxy

插件安装

```bash
sudo luarocks install kong-plugin-dubbo-proxy-*.rockspec
```

插件启用需要修改 kong 的启动配置文件（`/etc/kong/kong.conf`）：

```text
plugins = bundled, dubbo-proxy
```

官方的 Dubbo Proxy 的请求规则为：

```text
{application Name}/​{Interface name}?version={version}&group={group}
```

比如：

```bash
curl "http://192.168.33.1:9000/dubbo-registry-zookeeper-provider-sample/org.apache.dubbo.spring.boot.sample.consumer.DemoService?version=1.0.0" -d '
{
    "methodName" : "sayHello",
    "paramTypes" : ["java.lang.String"],
    "paramValues": [
        "leo"
    ]
}'
```

我更改了 Dubbo Proxy 的请求规则，将 application、interface、version、group 等原来在路由中填充的信息，放入 HTTP POST 请求 body 中，同时将这些 Dubbo 服务元信息放入插件配置中。

启用 kong-plugin-dubbo-proxy：

```bash
curl -X POST \
  --url http://localhost:8001/services/dubbo-registry-zookeeper-provider-sample-service/plugins \
  --data 'name=dubbo-proxy' \
  --data 'config.application_name=dubbo-registry-zookeeper-provider-sample' \
  --data 'config.interface_name=org.apache.dubbo.spring.boot.sample.consumer.DemoService' \
  --data 'config.version=1.0.0' \
  --data 'config.group=' \
  --data 'config.method_name=sayHello' \
  --data 'config.param_types[]=java.lang.String'
```

配置 Service（这里直接使用 Service，实际可使用 Upstream 来做 Dubbo Proxy 的负载均衡：

```bash
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=dubbo-registry-zookeeper-provider-sample-service' \
  --data 'url=http://192.168.33.1:9000'

curl -i -X POST \
  --url http://localhost:8001/services/dubbo-registry-zookeeper-provider-sample-service/routes \
  --data 'paths[]=/demoservcie'
```

最后访问网关：

```bash
curl "http://localhost:8000/demoservcie" -d '["leo"]'
```

