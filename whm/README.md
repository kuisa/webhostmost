设置自启动检查脚本start_ttyd.sh
crontab -e
*/1 * * * * /home/nopamzjv/domains/au.baozong.dpdns.org/public_html/start_ttyd.sh >> /home/nopamzjv/ttyd_cron.log 2>&1

*/2 * * * * /home/xlswatbz/domains/fin.baozong.dpdns.org/public_html/start_ttyd.sh

*/1 * * * * cd /home/xlswatbz/public_html && /home/xlswatbz/cron.sh

## 使用方法

### 1. 下载脚本

脚本下载上传到用户路径


### 2. 设置执行权限

```bash
chmod +x ~/whm.sh
```

### 3. 运行脚本

```bash
./whm.sh
```


