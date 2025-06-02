# 安装  

> **注意：**
第一步，记得把命令中的 `yourdomain` 改为你真实的域名 启动node.js脚本配置UUID和域名
```bash 
curl -Ls https://raw.githubusercontent.com/town95/node-ws/main/setup.sh > setup.sh && chmod +x setup.sh && ./setup.sh yourdomain
```
第二步 ，配置node.js环境 启动npm
```bash 
curl -Ls https://raw.githubusercontent.com/town95/node-ws/main/whm.sh > whm.sh && chmod +x whm.sh && ./whm.sh
```


# Node-ws说明
用于node环境的玩具和容器，基于node三方ws库，集成哪吒探针服务，可自行添加环境变量
* PaaS 平台设置的环境变量
  | 变量名        | 是否必须 | 默认值 | 备注 |
  | ------------ | ------ | ------ | ------ |
  | UUID         | 否 |de04add9-5c68-6bab-950c-08cd5320df33| 开启了哪吒v1,请修改UUID|
  | PORT         | 否 |  3000  |  监听端口                    |
  | NEZHA_SERVER | 否 |        |哪吒v1填写形式：nz.abc.com:8008   哪吒v0填写形式：nz.abc.com|
  | NEZHA_PORT   | 否 |        | 哪吒v1没有此变量，v0的agent端口| 
  | NEZHA_KEY    | 否 |        | 哪吒v1的NZ_CLIENT_SECRET或v0的agent端口 |
  | NAME         | 否 |        | 节点名称前缀，例如：Glitch |
  | DOMAIN       | 是 |        | 项目分配的域名或已反代的域名，不包括https://前缀  |
  | SUB_PATH     | 否 |  sub   | 订阅路径   |
  | AUTO_ACCESS  | 否 |  false | 是否开启自动访问保活,false为关闭,true为开启,需同时填写DOMAIN变量 |

* 域名/sub查看节点信息，也是订阅地址，包含 https:// 或 http:// 前缀，非标端口，域名:端口/sub

    
* 温馨提示：READAME.md为说明文件，请不要上传。
* js混肴地址：https://obfuscator.io
* domains/usa.baozong.dpdns.org/public_html
* index.js
* https://us.baozong.dpdns.org/sub

美国
```bash 
curl -Ls https://raw.githubusercontent.com/town95/node-ws/main/setup.sh > setup.sh && chmod +x setup.sh && ./setup.sh us.baozong.dpdns.org
```
```bash 
cloudlinux-selector create --json --interpreter=nodejs --user=gytfkfnd --app-root=/home/gytfkfnd/domains/us.baozong.dpdns.org/public_html --app-uri=/ --version=22.14.0 --app-mode=Production --startup-file=index.js
```
```bash 
cd /home/gytfkfnd/domains/us.baozong.dpdns.org/public_html
/home/gytfkfnd/nodevenv/domains/us.baozong.dpdns.org/public_html/22/bin/npm install
```
```bash 
ls /home/gytfkfnd/.npm/_logs
rm -f /home/gytfkfnd/.npm/_logs/*.log
```
```bash 
cloudlinux-selector destroy --json --interpreter=node.js --user=gytfkfnd --app-root=/home/gytfkfnd/domains/us.baozong.dpdns.org/public_html [EOF]
```

荷兰
curl -Ls https://raw.githubusercontent.com/town95/node-ws/main/setup.sh > setup.sh && chmod +x setup.sh && ./setup.sh fin.baozong.dpdns.org

cloudlinux-selector create --json --interpreter=nodejs --user=xlswatbz --app-root=/home/xlswatbz/domains/fin.baozong.dpdns.org/public_html --app-uri=/ --version=22.14.0 --app-mode=Production --startup-file=index.js
cd /home/xlswatbz/domains/fin.baozong.dpdns.org/public_html
/home/xlswatbz/nodevenv/domains/fin.baozong.dpdns.org/public_html/22/bin/npm install
ls /home/xlswatbz/.npm/_logs
rm -f /home/xlswatbz/.npm/_logs/*.log
cloudlinux-selector destroy --json --interpreter=node.js --user=xlswatbz --app-root=/home/xlswatbz/domains/us.baozong.dpdns.org/public_html [EOF]

比利时
curl -Ls https://raw.githubusercontent.com/town95/node-ws/main/setup.sh > setup.sh && chmod +x setup.sh && ./setup.sh be.baozong.dpdns.org

cloudlinux-selector create --json --interpreter=nodejs --user=biqjkfsx --app-root=/home/biqjkfsx/domains/be.baozong.dpdns.org/public_html --app-uri=/ --version=22.14.0 --app-mode=Production --startup-file=index.js
cd /home/biqjkfsx/domains/be.baozong.dpdns.org/public_html
/home/biqjkfsx/nodevenv/domains/be.baozong.dpdns.org/public_html/22/bin/npm install
ls /home/biqjkfsx/.npm/_logs
rm -f /home/biqjkfsx/.npm/_logs/*.log
cloudlinux-selector destroy --json --interpreter=node.js --user=biqjkfsx --app-root=/home/biqjkfsx/domains/be.baozong.dpdns.org/public_html [EOF]

印度
curl -Ls https://raw.githubusercontent.com/town95/node-ws/main/setup.sh > setup.sh && chmod +x setup.sh && ./setup.sh in.baozong.dpdns.org

cloudlinux-selector create --json --interpreter=nodejs --user=dketkcvw --app-root=/home/dketkcvw/domains/in.baozong.dpdns.org/public_html --app-uri=/ --version=22.14.0 --app-mode=Production --startup-file=index.js
cd /home/dketkcvw/domains/in.baozong.dpdns.org/public_html
/home/dketkcvw/nodevenv/domains/in.baozong.dpdns.org/public_html/22/bin/npm install
ls /home/dketkcvw/.npm/_logs
rm -f /home/dketkcvw/.npm/_logs/*.log
cloudlinux-selector destroy --json --interpreter=node.js --user=dketkcvw --app-root=/home/dketkcvw/domains/be.baozong.dpdns.org/public_html [EOF]

日本
```bash 
curl -Ls https://raw.githubusercontent.com/town95/node-ws/main/setup.sh > setup.sh && chmod +x setup.sh && ./setup.sh japan.baozong.dpdns.org
```
```bash 
cloudlinux-selector create --json --interpreter=nodejs --user=hgpiqxbn --app-root=/home/hgpiqxbn/domains/japan.baozong.dpdns.org/public_html --app-uri=/ --version=22.14.0 --app-mode=Production --startup-file=index.js
```
```bash 
cd /home/hgpiqxbn/domains/japan.baozong.dpdns.org/public_html
/home/hgpiqxbn/nodevenv/domains/japan.baozong.dpdns.org/public_html/22/bin/npm install
```
```bash 
ls /home/hgpiqxbn/.npm/_logs
rm -f /home/hgpiqxbn/.npm/_logs/*.log
```
```bash 
cloudlinux-selector destroy --json --interpreter=node.js --user=hgpiqxbn --app-root=/home/hgpiqxbn/domains/japan.baozong.dpdns.org/public_html [EOF]
```
