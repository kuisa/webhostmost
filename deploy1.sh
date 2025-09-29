#!/bin/bash
set -e

# ========== 用户与输入 ==========
cd ~ || { echo "❌ 无法切换到主目录"; exit 1; }
USERNAME="$(basename "$PWD")"
echo "🧑 当前用户名: $USERNAME"

read -p "请输入绑定的域名（如 us.example.com）: " DOMAIN
[ -z "$DOMAIN" ] && { echo "❌ 域名不能为空"; exit 1; }

read -p "请输入 UUID（用于 WebSocket 鉴权）: " UUID
[ -z "$UUID" ] && { echo "❌ UUID 不能为空"; exit 1; }

read -p "是否安装哪吒探针？[y/n] [n]: " input
input=${input:-n}
if [ "$input" != "n" ]; then
  read -p "输入 NEZHA_SERVER（如 nz.xxx.com:5555）: " nezha_server
  [ -z "$nezha_server" ] && { echo "❌ NEZHA_SERVER 不能为空"; exit 1; }

  read -p "输入 NEZHA_PORT（默认443，留空用443）: " nezha_port
  nezha_port=${nezha_port:-443}

  read -p "输入 NEZHA_KEY（v1面板为 NZ_CLIENT_SECRET）: " nezha_key
  [ -z "$nezha_key" ] && { echo "❌ NEZHA_KEY 不能为空"; exit 1; }
fi

# ========== 路径和参数 ==========
APP_ROOT="/home/$USERNAME/domains/$DOMAIN/public_html"
NODE_VERSION="22.16.0"
NODE_ENV_VERSION="22"
STARTUP_FILE="app.js"
NODE_VENV_BIN="/home/$USERNAME/nodevenv/domains/$DOMAIN/public_html/$NODE_ENV_VERSION/bin"
LOG_DIR="/home/$USERNAME/.npm/_logs"
RANDOM_PORT=$((RANDOM % 40001 + 20000))

# ========== 准备目录 ==========
echo "📁 创建应用目录: $APP_ROOT"
mkdir -p "$APP_ROOT"
cd "$APP_ROOT" || exit 1

# ========== 写入 app.js ==========
cat > "$APP_ROOT/app.js" << 'EOF'
const os = require('os');
const http = require('http');
const { Buffer } = require('buffer');
const fs = require('fs');
const axios = require('axios');
const path = require('path');
const net = require('net');
const { exec } = require('child_process');
const { WebSocket, createWebSocketStream } = require('ws');

// 环境变量
const UUID = process.env.UUID || 'b28f60af-d0b9-4ddf-baaa-7e49c93c380b';
const uuid = UUID.replace(/-/g, "");
const DOMAIN = process.env.DOMAIN || 'example.com';
const NAME = process.env.NAME || 'Node-WS';
const port = process.env.PORT || 3000;

// 哪吒探针环境变量
const NEZHA_SERVER = process.env.NEZHA_SERVER || '';
const NEZHA_PORT = process.env.NEZHA_PORT || '';
const NEZHA_KEY = process.env.NEZHA_KEY || '';

// 创建HTTP路由
const httpServer = http.createServer((req, res) => {
  if (req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello, World\n');
  } else if (req.url === '/sub') {
    const vlessURL = `vless://${UUID}@${DOMAIN}:443?encryption=none&security=tls&sni=${DOMAIN}&type=ws&host=${DOMAIN}&path=%2F#${NAME}`;
    const base64Content = Buffer.from(vlessURL).toString('base64');
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end(base64Content + '\n');
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found\n');
  }
});

httpServer.listen(port, () => {
  console.log(`HTTP Server is running on port ${port}`);
});

// 判断系统架构
function getSystemArchitecture() {
  const arch = os.arch();
  if (arch === 'arm' || arch === 'arm64') {
    return 'arm';
  } else {
    return 'amd';
  }
}

// 下载对应系统架构的 ne-zha
function downloadFile(fileName, fileUrl, callback) {
  const filePath = path.join("./", fileName);
  const writer = fs.createWriteStream(filePath);
  axios({
    method: 'get',
    url: fileUrl,
    responseType: 'stream',
  })
    .then(response => {
      response.data.pipe(writer);
      writer.on('finish', function() {
        writer.close();
        callback(null, fileName);
      });
    })
    .catch(error => {
      callback(`Download ${fileName} failed: ${error.message}`);
    });
}

function getFilesForArchitecture(architecture) {
  if (architecture === 'arm') {
    return [{ fileName: "nezha", fileUrl: "https://github.com/eooce/test/releases/download/ARM/swith" }];
  } else if (architecture === 'amd') {
    return [{ fileName: "nezha", fileUrl: "https://github.com/eooce/test/releases/download/bulid/swith" }];
  }
  return [];
}

function authorizeFiles() {
  const filePath = './nezha';
  const newPermissions = 0o775;
  fs.chmod(filePath, newPermissions, (err) => {
    if (err) {
      console.error(`Empowerment failed:${err}`);
    } else {
      console.log(`Empowerment success`);
      if (NEZHA_SERVER && NEZHA_PORT && NEZHA_KEY) {
        let NEZHA_TLS = NEZHA_PORT === '443' ? '--tls' : '';
        const command = `./nezha -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${NEZHA_TLS} --skip-conn --disable-auto-update --skip-procs --report-delay 4 >/dev/null 2>&1 &`;
        try {
          exec(command);
          console.log('nezha agent is running');
        } catch (error) {
          console.error(`nezha agent error: ${error}`);
        }
      } else {
        console.log('NEZHA variable is empty, skip running');
      }
    }
  });
}

function downloadFiles() {
  const architecture = getSystemArchitecture();
  const filesToDownload = getFilesForArchitecture(architecture);
  if (filesToDownload.length === 0) {
    console.log(`Can't find a file for the current architecture`);
    return;
  }
  let downloadedCount = 0;
  filesToDownload.forEach(fileInfo => {
    downloadFile(fileInfo.fileName, fileInfo.fileUrl, (err, fileName) => {
      if (err) {
        console.log(`Download ${fileName} failed`);
      } else {
        console.log(`Download ${fileName} successfully`);
        downloadedCount++;
        if (downloadedCount === filesToDownload.length) {
          setTimeout(() => authorizeFiles(), 3000);
        }
      }
    });
  });
}
downloadFiles();

// WebSocket 服务器
const wss = new WebSocket.Server({ server: httpServer });
wss.on('connection', ws => {
  console.log("WebSocket 连接成功");
  ws.on('message', msg => {
    if (msg.length < 18) {
      console.error("数据长度无效");
      return;
    }
    try {
      const [VERSION] = msg;
      const id = msg.slice(1, 17);
      if (!id.every((v, i) => v == parseInt(uuid.substr(i * 2, 2), 16))) {
        console.error("UUID 验证失败");
        return;
      }
      let i = msg.slice(17, 18).readUInt8() + 19;
      const port = msg.slice(i, i += 2).readUInt16BE(0);
      const ATYP = msg.slice(i, i += 1).readUInt8();
      const host = ATYP === 1 ? msg.slice(i, i += 4).join('.') :
        (ATYP === 2 ? new TextDecoder().decode(msg.slice(i + 1, i += 1 + msg.slice(i, i + 1).readUInt8())) :
          (ATYP === 3 ? msg.slice(i, i += 16).reduce((s, b, i, a) => (i % 2 ? s.concat(a.slice(i - 1, i + 1)) : s), []).map(b => b.readUInt16BE(0).toString(16)).join(':') : ''));
      console.log('连接到:', host, port);
      ws.send(new Uint8Array([VERSION, 0]));
      const duplex = createWebSocketStream(ws);
      net.connect({ host, port }, function () {
        this.write(msg.slice(i));
        duplex.on('error', err => console.error("E1:", err.message)).pipe(this).on('error', err => console.error("E2:", err.message)).pipe(duplex);
      }).on('error', err => console.error("连接错误:", err.message));
    } catch (err) {
      console.error("处理消息时出错:", err.message);
    }
  }).on('error', err => console.error("WebSocket 错误:", err.message));
});
EOF

# ========== 写入 cron.sh ==========
cat > "/home/$USERNAME/cron.sh" << EOF
#!/bin/bash
# 检查 Node 应用是否存活，不在则重启
pgrep -f "node app.js" > /dev/null 2>&1
if [ \$? -ne 0 ]; then
  echo "⚠️ Node 进程未运行，尝试重启"
  cd "$APP_ROOT" || exit 1
  "$NODE_VENV_BIN/node" app.js &
fi
EOF
chmod +x /home/$USERNAME/cron.sh

# ========== 写入 package.json ==========
cat > "$APP_ROOT/package.json" << EOF
{
  "name": "node-ws",
  "version": "1.0.0",
  "description": "Node.js Server",
  "main": "app.js",
  "author": "eoovve",
  "repository": "https://github.com/eoovve/node-ws",
  "license": "MIT",
  "private": false,
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "ws": "^8.14.2",
    "axios": "^1.6.2"
  },
  "engines": {
    "node": ">=14"
  }
}
EOF

# ========== 配置 CloudLinux Node 环境 ==========
echo "📄 复制 cloudlinux-selector 为本地 cf 命令"
cp /usr/sbin/cloudlinux-selector ./cf

echo "🗑️ 尝试销毁旧环境（如存在）"
./cf destroy --json --interpreter=nodejs --user="$USERNAME" --app-root="$APP_ROOT" || true

echo "⚙️ 创建新 Node 环境"
./cf create \
  --json \
  --interpreter=nodejs \
  --user="$USERNAME" \
  --app-root="$APP_ROOT" \
  --app-uri="/" \
  --version="$NODE_VERSION" \
  --app-mode=Production \
  --startup-file="$STARTUP_FILE" \
  --env="UUID=$UUID,DOMAIN=$DOMAIN,PORT=$RANDOM_PORT,NEZHA_SERVER=$nezha_server,NEZHA_PORT=$nezha_port,NEZHA_KEY=$nezha_key"

# ========== 安装依赖 ==========
echo "📦 安装依赖 via npm"
"$NODE_VENV_BIN/npm" install

# ========== 清理日志 ==========
echo "🧹 清理 npm 日志"
[ -d "$LOG_DIR" ] && rm -f "$LOG_DIR"/*.log || echo "📂 无日志目录，跳过"

# ========== 设置定时任务 ==========
echo "⏱️ 写入 crontab 每分钟执行一次 cron.sh"
echo "*/1 * * * * cd $APP_ROOT && /home/$USERNAME/cron.sh" > ./mycron
crontab ./mycron
rm ./mycron

# ========== 结束提示 ==========
echo "✅ 应用部署完成！"
echo "🌐 域名: $DOMAIN"
echo "🧾 UUID: $UUID"
echo "📡 本地监听端口: $RANDOM_PORT"
[ "$input" = "y" ] && echo "📟 哪吒探针已配置: $nezha_server"

# ========== 可选：自毁脚本 ==========
# rm -- "$0"
