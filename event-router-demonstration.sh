#!/usr/bin/sh

#Download the related projects
git clone https://github.com/bloodyrafo75/PoC-event-router-core-lib
git clone https://github.com/bloodyrafo75/PoC-core-event-API
git clone https://github.com/bloodyrafo75/PoC-core-event-router-CLI

export GO111MODULE=on

#Activate the API service.
cd PoC-core-event-API/third_parties
docker-compose up -d
cd ..
cp configs/.env.dist configs/.env
go run cmd/main.go &
echo "API server up"
sleep 3

#Activate the client.
echo ""
cd ../PoC-core-event-router-CLI
cp configs/.env.dist configs/.env
go run cmd/main.go & 
echo "API Client up"
sleep 3

#Activate the 'sender'.
echo ""
echo "Sending example message"
cd ../PoC-event-router-core-lib
cp configs/.env.dist configs/.env
go run cmd/main.go 

#sleep 2 #waits for 2 seconds and kills Api server (It's supposed to be listening at port 3000)
kill $(lsof -t -sTCP:LISTEN -i:3000)
