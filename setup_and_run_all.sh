#!/bin/bash
# 시작 시간을 기록 (초 단위)
start_time=$(date +%s)

echo "작업 시작 시간: $(date)"

# 경로 정의
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"  # 현재 스크립트가 위치한 디렉터리의 절대 경로를 설정
TERRAFORM_DIR="$BASE_DIR/terraform"       # Terraform 작업 디렉터리 경로 설정
SCRIPTS_DIR="$BASE_DIR/scripts"           # 스크립트 파일이 위치한 디렉터리 경로 설정
ANSIBLE_DIR="$BASE_DIR/ansible"           # Ansible 작업 디렉터리 경로 설정

# 1단계: Terraform 실행
echo "[INFO] Terraform apply 실행 중..."
cd "$TERRAFORM_DIR" || { echo "[ERROR] Terraform 디렉터리를 찾을 수 없습니다!"; exit 1; }
terraform init && terraform apply -auto-approve  # Terraform 초기화 및 적용 (-auto-approve 옵션으로 사용자 승인 없이 실행)
if [ $? -ne 0 ]; then  # $? 는 직전 명령의 종료 상태를 나타냄 (0이 아니면 오류 발생)
    echo "[ERROR] Terraform apply 실행 실패!"
    exit 1
fi

# 2단계: SSH 키 생성 스크립트 실행
echo "[INFO] SSH 키 생성 중..."
cd "$SCRIPTS_DIR" || { echo "[ERROR] Scripts 디렉터리를 찾을 수 없습니다!"; exit 1; }
chmod +x generate_ssh_key.sh  # 실행 권한 부여
./generate_ssh_key.sh  # SSH 키 생성 스크립트 실행
if [ $? -ne 0 ]; then
    echo "[ERROR] SSH 키 생성 실패!"
    exit 1
fi

# 기존 SSH 호스트 키 제거 (보안 문제 방지)
ssh-keygen -f ~/.ssh/known_hosts -R 172.18.0.2  # 특정 IP에 대한 기존 SSH 키 제거
ssh-keygen -f ~/.ssh/known_hosts -R 172.18.0.3
ssh-keygen -f ~/.ssh/known_hosts -R 172.18.0.4

# 3단계: Ansible 플레이북 실행
echo "[INFO] Ansible 플레이북 실행 중..."
cd "$ANSIBLE_DIR" || { echo "[ERROR] Ansible 디렉터리를 찾을 수 없습니다!"; exit 1; }
chmod +x run_playbooks.sh  # 실행 권한 부여
./run_playbooks.sh  # Ansible 플레이북 실행
if [ $? -ne 0 ]; then
    echo "[ERROR] Ansible 플레이북 실행 실패!"
    exit 1
fi

echo "[SUCCESS] 모든 작업이 성공적으로 완료되었습니다!"

# 종료 시간을 기록 (초 단위)
end_time=$(date +%s)
echo "작업 종료 시간: $(date)"

# 총 소요 시간 계산 (분 단위)
elapsed_time=$(( (end_time - start_time) / 60 ))

echo "총 소요 시간: ${elapsed_time} 분"

