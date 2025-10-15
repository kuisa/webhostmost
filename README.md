# 安装  

一键重建脚本(部署完后 用 域名/UUID 访问 )
首先需要cd到该目录下(该目录下有执行权限):
每个人目录不同，自己按照实际情况来
cd  /home/$USERNAME/domains/$DOMAIN/public_html

```bash 
curl -Ls https://raw.githubusercontent.com/TownMarshal/node-ws/main/deploy.sh > deploy.sh && chmod +x deploy.sh && ./deploy.sh  

```
