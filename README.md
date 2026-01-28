# sys-autoclean

Linux 서버 자동 관리 스크립트 (메모리/디스크 모니터링 및 자동 정리)

## 포함 스크립트

| 스크립트 | 용도 |
|---------|------|
| `sysmon` | 시스템 상태 모니터링 |
| `sys-autoclean` | 자동 정리 및 관리 |

## 설치 방법

```bash
# 1. 스크립트 복사
mkdir -p ~/bin
cp sysmon sys-autoclean ~/bin/

# 2. 실행 권한 부여
chmod +x ~/bin/sysmon ~/bin/sys-autoclean

# 3. PATH 추가 (.bashrc에)
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 4. cron 등록
(crontab -l 2>/dev/null; echo "# 시스템 자동 관리 - 2시간마다 체크"; echo "0 */2 * * * $HOME/bin/sys-autoclean --auto"; echo "# 매일 새벽 3시 예방 정리"; echo "0 3 * * * $HOME/bin/sys-autoclean --daily") | crontab -
```

## 사용법

### sysmon (모니터링)

```bash
sysmon              # 현재 상태 확인
sysmon --watch      # 실시간 모니터링 (5초 갱신)
sysmon --clean      # VS Code 캐시 정리
sysmon --fix        # NODE_OPTIONS 4GB 설정
sysmon --help       # 도움말
```

### sys-autoclean (자동 관리)

```bash
sys-autoclean           # 현재 상태 확인
sys-autoclean --check   # 수동 체크 및 정리
sys-autoclean --clean   # 강제 캐시 정리
sys-autoclean --daily   # 일일 예방 정리
sys-autoclean --alerts  # 미확인 알림 보기
sys-autoclean --log     # 전체 로그 보기
sys-autoclean --help    # 도움말
```

## 기능

### 모니터링 항목
- 메모리 사용률
- CPU 사용률
- 디스크 사용률
- Swap 사용량
- VS Code 프로세스 상태
- NODE_OPTIONS 설정 확인

### 자동 정리 대상
- VS Code 오래된 로그 (7일 이상)
- VS Code 확장 캐시 (VSIX)
- /tmp 오래된 파일
- 썸네일 캐시

### 임계값 설정
```bash
# sys-autoclean 파일 상단에서 수정 가능
MEMORY_THRESHOLD=85      # 메모리 임계값 (%)
DISK_THRESHOLD=90        # 디스크 임계값 (%)
LOG_RETENTION_DAYS=7     # 로그 보관 기간 (일)
```

## cron 스케줄

| 주기 | 동작 |
|------|------|
| 2시간마다 | 임계값 초과 시 자동 정리 |
| 매일 새벽 3시 | 예방적 전체 정리 |

## 로그 파일

| 파일 | 위치 |
|------|------|
| 실행 로그 | `~/.sys-autoclean.log` |
| 알림 파일 | `~/.sys-alert` (문제 발생 시 생성) |

## 요구 사항

- Linux (Ubuntu/Debian 권장)
- bash 쉘
- 표준 유틸리티 (free, df, ps, find)

## 삭제되지 않는 파일 (안전)

- 소스 코드 (프로젝트 파일)
- Git 히스토리
- 설치된 VS Code 확장 프로그램
- 사용자 설정 (settings.json 등)
