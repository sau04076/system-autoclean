#!/bin/bash
#
# sys-autoclean 설치 스크립트
#

set -e

echo "=== sys-autoclean 설치 시작 ==="

# 스크립트 디렉토리 확인
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ~/bin 디렉토리 생성
mkdir -p ~/bin

# 스크립트 복사
cp "$SCRIPT_DIR/sysmon" ~/bin/
cp "$SCRIPT_DIR/sys-autoclean" ~/bin/

# 실행 권한 부여
chmod +x ~/bin/sysmon ~/bin/sys-autoclean

echo "스크립트 설치 완료: ~/bin/"

# PATH 추가 확인
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# 사용자 스크립트 경로" >> ~/.bashrc
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    echo "PATH 추가 완료: ~/.bashrc"
fi

# cron 등록 확인
if ! crontab -l 2>/dev/null | grep -q "sys-autoclean"; then
    (crontab -l 2>/dev/null; echo "# 시스템 자동 관리 - 2시간마다 체크"; echo "0 */2 * * * $HOME/bin/sys-autoclean --auto"; echo "# 매일 새벽 3시 예방 정리"; echo "0 3 * * * $HOME/bin/sys-autoclean --daily") | crontab -
    echo "cron 등록 완료"
else
    echo "cron 이미 등록됨 (스킵)"
fi

echo ""
echo "=== 설치 완료 ==="
echo ""
echo "사용법:"
echo "  source ~/.bashrc   # PATH 적용 (또는 새 터미널 열기)"
echo "  sysmon             # 시스템 모니터링"
echo "  sys-autoclean      # 자동 관리 상태 확인"
