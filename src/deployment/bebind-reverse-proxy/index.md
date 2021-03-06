---
title: Bind domain with reverse proxy server
description: Bind domain with reverse proxy server
keywords: 'abtnode,deployment,proxy'
author: zhenqiang
category: abtnode
layout: documentation
tags:
  - forge
---

Because ABT Node may contain multiple Blocklets, and almost every Blocklet requires at least one port (not required for static Blocklets), ABT Node and Blocklet will require multiple ports, so in production environments, they often need to be with a reverse proxy server to deploy.
This document will take Nginx as an example to introduce how to deploy ABT Node with a reverse proxy server, and bind a domain name to ABT Node Daemon and a Blocklet respectively.

::: warning
Make sure the latest version of ABT Node is installed
:::

## Preparation Requirements

- BT Node daemon service running on port 8089
- Blocklet Manager blocklet running on port 8090
- Proxy server: Nginx
- Two domain names:
  - ABT Node: abtnode.com
  - Blocklet Manager blocklet: blocklet.abtnode.com

## Nginx Configuration

Nginx configuration:

```
server {
    listen 80;
    server_name abtnode.com;

    location / {
        proxy_pass http://127.0.0.1:8089;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
server {
    listen 80;
    server_name blocklet.abtnode.com;

    location / {
        proxy_pass http://127.0.0.1:8090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

This configuration binds the domain name `abtnode.com` to port 8089, and binds the domain name `blocklet.abtnode.com` to port 8090.
At the same time, it should be noted that the Host header needs to be passed to the upstream service through the proxy server.

## Update ABT Node Configuration

After configuring the proxy, you need to modify the configuration file of ABT Node and update the domain name of ABT Node to the configuration file:

```yaml
node:
  name: 'ABT Node [polunzh]'
  description: Container of useful blocklets from ArcBlock and its Developer Community
  sk: >-
    0x4000d4f04d39c700003838f04e0eb7c4006a841a2f12ed762b577b2c8ab07acbe63acb6d74f30db68cbec0977d1398ee40af85d62647624969fb7eae832348f9
  pk: '0xe63acb6d74f30db68cb0c0907d1398ee40af85d62647624969fb7eae832348f9'
  did: zNKmYKcs84YViFyocUJKMJ5HRw001oH1K2y2
  dataDir: /home/demo/.abtnode
  domain: 'abtnode.com'
  ip: 192.168.0.1
  port: 8089
  https: true
  secret: '0xa5cd176753101e5f12e604b6a741fed382c19ecfe45cd9d32a5d231404b41f23'
  owner:
    pk: ''
    did: ''
blocklet:
  port: 8089
  registry: 'https://blocklet.arcblock.io'
  owner:
    pk: ''
    did: ''
```

::: success
If HTTPS is enabled, you need to set the `https` property in the configuration file to `true`. As in the configuration file above.
:::

After modifying the configuration file, you need to restart the ABT Node node and update the configuration. You can restart it through the ABT Node CLI command:

```
abtnode start -u
```

After restarting the service, you can use the domain name to access the node normally.

## Configure the domain name of the blocklet

On the **Blocklets -> Detail -> Setting** page, you can configure the domain name of the Blocklet, fill in the domain name and click Save, then **Restart Blocklet**

![blocklet domain setting](./images/blocklet-domain-setting.png)

::: warning
Restarting the blocklet will make the modified domain name take effect
:::

## Others

You can find all the environment variables when the Blocklet is running, such as the port, current domain name, IP, etc., on the **Blocklets -> Detail -> Environment** page.

![blocklet domain setting](./images/blocklet-environments.png)

## 注意事项

- Currently, you can only modify the node's IP and domain name by manually modifying the node's configuration file
- If HTTPS is enabled, HTTPS needs to be enabled for ABT Node Daemon and all blocklets
