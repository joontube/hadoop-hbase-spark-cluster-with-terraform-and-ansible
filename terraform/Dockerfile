FROM ubuntu:22.04

# 필수 패키지 설치 및 SSH 서버 설정
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get update

RUN apt-get upgrade -y && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd && \
    echo "root:password" | chpasswd

# SSH 설정 (비밀번호 인증 허용)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config


# SSH 포트 노출
EXPOSE 22
