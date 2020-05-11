# Docker for Nginx Route

이 도커의 목적은 NginX를 이용하여 여러 서버에 라우팅, 로드벨런싱을 셋팅하기 위함이다.
<br>
# 도커 설치
<br>
최초 사용 이전 몇가지 요소를 설치해준다
<br>
서버 업데이트
<pre>
sudo apt-get update
</pre>
<br>
요소 설치
<pre>
sudo apt install apt install apt-transport-https
sudo apt install apt-transport-https
sudo apt install ca-certificates
sudo apt install curl
sudo apt install software-properties-common
</pre>
<br>
도커 설치
<pre>
#curl을 통해 도커 다운받을수 있게 apt에 추가해주기
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#스테이블 설치
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

#다시 apt 업데이트 해주기
sudo apt update

#docker-ce 설치
apt-cache policy docker-ce
sudo apt install docker-ce
#설치 확인
sudo systemctl status docker

#도커 실행기 권한 설정
sudo chmod 666 /var/run/docker.sock
</pre>


<br><br>

# 도커 이미지 빌드

기본적으로 nginx 설치, vi editer, certbot 등을 설치를 진행한다.
<br>
깃 클론
<pre>
cd ~
git clone https://github.com/Kein-chronicle/nginx_route_docker.git
</pre>
<br><br>
클론 받은 폴더로 이동
<pre>
cd nginx_route_docker
</pre>
<br><br>
도커파일 빌드
<pre>
docker build -t nginxdocker .
</pre>
<br><br>
빌드가 끝나면 도커 이미지가 제대로 생성되었는지 확인한다.
<pre>
docker images
</pre>
<br><br>
nginxdocker가 제대로 빌드된 것을 확인하면 실행한다.
443 포트와 80 포트를 연결해서 실행한다.
<pre>
docker run --name nginxdocekr -p 80:80 -p 443:443 nginxdocker
</pre>
<br><br>
# 도커 이미지 내부 작업
실행이 되고나면 터미널에서 컨트롤이 불가능하므로 새로운 터미널을 열어준다
<pre>
docker ps -a
# 이미지 확인 후
docker exec -it imageId /bin/bash
</pre>
<br><br>
기본 사이트 설정 파일을 수정해준다.
<pre>
vi /etc/nginx/sites-enabled/default
</pre>
<br><br>
수정될 설정 파일에서 최초 80 포트에 접속되는 설정을 모두 #으로 주석처리 진행한다.
지워도 무관하다
그 이후 연결할 서버들을 맨 밑에 추가해준다.
추가하고자 하는 서버 개수만큼 아래 코드를 삽입해준다.
<pre>
upstream upstream1 {
        server route_server;
}

server {
       listen 80;
       listen [::]:80;

       server_name site_name1;

       location / {
                proxy_set_header Host $host;
                proxy_pass http://upstream1;
       }
}

upstream upstream2 {
        server route_server;
}

server {
       listen 80;
       listen [::]:80;

       server_name site_name2;

       location / {
                proxy_set_header Host $host;
                proxy_pass http://upstream2;
       }
}
</pre>
<br><br>
SSL을 추가해준다
두개의 서버를 연결했다는 가정하의 예시
<pre>
certbot --nginx -d server_name1 -d server_name2

#email 넣으라고 나옴
#동의하냐 나오는데 (A)gree
#메일 받을거냐 묻는데 (N)o 하면 됨
</pre>
<br><br>
마지막으로 SSL 자동갱신을 할 수 있도록 셋팅
<pre>
certbot renew --dry-run
</pre>
<br><br>
끝.
