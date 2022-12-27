echo "remove config..."
rm -rf ngrok ngrok.tgz > /dev/null 2>&1

echo "ngrok download..."
wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz > /dev/null 2>&1

echo "ngrok extract..."
tar -xf ngrok.tgz > /dev/null 2>&1

echo "ngrok config..."

read -p "ngrok authtoken: " authToken
./ngrok authtoken $authToken > /dev/null 2>&1
./ngrok config upgrade > /dev/null 2>&1

# --region
# us - United States (Ohio)
# eu - Europe (Frankfurt)
# ap - Asia/Pacific (Singapore)
# au - Australia (Sydney)
# sa - South America (Sao Paulo)
# jp - Japan (Tokyo)
# in - India (Mumbai)
echo "ngrok run..."
./ngrok tcp --region ap 3388 &>/dev/null &

echo "install rdp..."
docker pull danielguerra/ubuntu-xrdp > /dev/null 2>&1

echo "run rdp..."
docker run --rm -d -p 3388:3389 danielguerra/ubuntu-xrdp:20.04 > /dev/null 2>&1

echo "username : ubuntu"
echo "password : ubuntu"
echo "address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
