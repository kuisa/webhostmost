#!/bin/bash

# ============ 配置参数 ============
PORT=35000
CMD_PATH="/home/xlswatbz/domains/fin.baozong.dpdns.org/public_html/ttyd"   # ============ 改为自己路径============
AUTH="town:ts521"
LOGFILE="/home/xlswatbz/domains/fin.baozong.dpdns.org/public_html/ttyd.log"  # ============ 改为自己路径============
MAX_SIZE=10485760  # 10MB = 10 * 1024 * 1024 bytes

# ============ 清理超大日志 ============
if [ -f "$LOGFILE" ]; then
    FILESIZE=$(stat -c%s "$LOGFILE")
    if [ "$FILESIZE" -ge "$MAX_SIZE" ]; then
        echo "$(date): Log file exceeded 10MB, clearing..." > "$LOGFILE"
    fi
fi

# ============ 检查是否运行 ============
if ! pgrep -f "$CMD_PATH" > /dev/null; then
    echo "$(date): ttyd not running, starting..." >> "$LOGFILE"
    setsid "$CMD_PATH" -p "$PORT" -c "$AUTH" -W bash >> "$LOGFILE" 2>&1 &
else
    echo "$(date): ttyd is running" >> "$LOGFILE"
fi
