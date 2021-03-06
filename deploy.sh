# Catatan
# - File config kita (di folder k8s) mengambil image dari Stephengrider (pembuat course) agar lebih aman. Jadi 
# di sini kita mem-build dan mengepush image ke Dockerhub senzdamsik tapi mengambil imagenya dari Dockerhub Stephengrider

# - Beda halnya dengan update image. Saat kita mengupdate image (rubah script => rebuild image => push project
#   ke Github => send ke Travis), dia tidak akan memakai perintah "kebectl apply" tapi menggunakan "kubectl set".
#   Hal ini membuat kita tidak mengambil image dari Stephengrider (berdasarkan folder k8s) tapi mengambil image dari Senzdamsik

docker build -t senzdamsik/multi-client:latest -t senzdamsik/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t senzdamsik/multi-server:latest -t senzdamsik/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t senzdamsik/multi-worker:latest -t senzdamsik/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push senzdamsik/multi-client:latest
docker push senzdamsik/multi-server:latest
docker push senzdamsik/multi-worker:latest

docker push senzdamsik/multi-client:$SHA
docker push senzdamsik/multi-server:$SHA
docker push senzdamsik/multi-worker:$SHA

# Catatan
# - Kalau jalanin project ini pertama kali, dia akan mengeksekusi "kubectl apply" tapi tidak akan mengeksekusi "kubectl set"
# - Kalau kita mengupdate project ini, dia akan mengeksekusi "kubectl set" tapi tidak akan mengeksekusi "kubectl apply"
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=senzdamsik/multi-server:$SHA
kubectl set image deployments/client-deployment client=senzdamsik/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=senzdamsik/multi-worker:$SHA