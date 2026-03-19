#!/bin/bash
# OpenClaw Gateway Watchdog
# 定期检查 openclaw gateway 状态，自动重启并通知

set -e

# 配置
CHECK_INTERVAL=60           # 检查间隔（秒）
MAX_RESTART_TRIES=3         # 最大重启尝试次数
GATEWAY_PORT=18789          # Gateway 端口
OPENCLAW_BIN="/www/server/nodejs/v24.14.0/bin/openclaw"
IFLOW_BIN="/www/server/nodejs/v24.14.0/bin/iflow"
LOG_FILE="/var/log/openclaw-watchdog.log"
LOCK_DIR="/tmp/openclaw-0"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 检查 gateway 是否运行
check_gateway() {
    # 方法1: 检查健康端点
    if curl -s --max-time 5 "http://127.0.0.1:$GATEWAY_PORT/health" 2>/dev/null | grep -q '"ok":true'; then
        return 0
    fi
    
    # 方法2: 检查进程
    if pgrep -f "openclaw-gateway" > /dev/null; then
        # 进程存在但健康检查失败，可能处于异常状态
        log "警告: Gateway 进程存在但健康检查失败"
        return 1
    fi
    
    return 1
}

# 清理锁文件
cleanup_locks() {
    if [ -d "$LOCK_DIR" ]; then
        log "清理残留锁文件: $LOCK_DIR"
        rm -rf "$LOCK_DIR"
    fi
    # 清理其他可能的锁文件
    rm -f /tmp/openclaw-*/gateway.*.lock 2>/dev/null || true
}

# 停止 gateway
stop_gateway() {
    log "停止 gateway..."
    pkill -f "openclaw-gateway" 2>/dev/null || true
    sleep 2
    # 强制杀死
    pkill -9 -f "openclaw-gateway" 2>/dev/null || true
    cleanup_locks
}

# 启动 gateway
start_gateway() {
    log "启动 gateway..."
    nohup "$OPENCLAW_BIN" gateway > /tmp/openclaw-gateway.log 2>&1 &
    
    # 等待 Gateway 初始化（需要加载插件，较慢）
    local wait_time=0
    local max_wait=30
    
    while [ $wait_time -lt $max_wait ]; do
        sleep 2
        wait_time=$((wait_time + 2))
        if check_gateway; then
            log "Gateway 启动成功 (等待 ${wait_time}秒)"
            return 0
        fi
        log "等待 Gateway 初始化... (${wait_time}s)"
    done
    
    log "Gateway 启动失败 (等待 ${max_wait}秒后仍无响应)"
    return 1
}

# 使用 iflow 恢复 openclaw
recover_via_iflow() {
    log "Watchdog 自动恢复失败，委托 iflow 处理..."
    
    # 让 iflow 检查 openclaw 状态并尝试恢复
    "$IFLOW_BIN" -p "openclaw gateway 异常，请检查 openclaw 是否正常运行，如果没有正常运行请恢复它。检查步骤：1. 检查端口 18789 是否有服务监听 2. 检查 openclaw-gateway 进程是否存在 3. 如果异常，清理锁文件 /tmp/openclaw-0 后重启 openclaw gateway" -y 2>&1 | tee -a "$LOG_FILE" || true
    
    # 等待 iflow 处理完成后再次检查
    sleep 10
    if check_gateway; then
        log "iflow 成功恢复 openclaw"
        return 0
    else
        log "iflow 也无法恢复 openclaw"
        return 1
    fi
}

# 主检查逻辑
restart_gateway() {
    local try=1
    
    while [ $try -le $MAX_RESTART_TRIES ]; do
        log "重启尝试 $try/$MAX_RESTART_TRIES"
        
        stop_gateway
        sleep 2
        
        if start_gateway; then
            return 0
        fi
        
        try=$((try + 1))
        sleep 5
    done
    
    return 1
}

# 主循环
main() {
    log "OpenClaw Watchdog 启动 (检查间隔: ${CHECK_INTERVAL}秒)"
    
    while true; do
        if ! check_gateway; then
            log "检测到 Gateway 异常，尝试恢复..."
            
            if restart_gateway; then
                log "Gateway 已成功恢复"
            else
                log "错误: Gateway 重启失败，委托 iflow 处理..."
                recover_via_iflow
            fi
        fi
        
        sleep $CHECK_INTERVAL
    done
}

# 信号处理
trap 'log "收到终止信号，退出..."; exit 0' SIGTERM SIGINT

# 运行
main
