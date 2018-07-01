 #!/bin/bash

DEPLY_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARBOR_FOLDER=$DEPLY_ROOT/harbor
SCHEME=http
SERVER_IP=192.168.247.130
DOCKER_VERSION=1.12.6-0~ubuntu-xenial

function pre-install () {
	echo "Before install Harbor......."
	install-docker
	install-compose
	install-python
}

function install-compose () {
	echo "Installing Docker compose......."
	curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	docker-compose --version

}

function install-docker() {
	echo "Installing Docker engine......."
	apt-get update
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
	apt-cache policy docker-engine
	apt-get install -y docker-engine=${DOCKER_VERSION}
	usermod -aG docker $(whoami)

}

function install-python () {
	echo "Installing Python2.7......."
	apt-get install python2.7
	if [ ! -f /usr/bin/python ]; then
        echo "Building Python Link ......"
        ln -s /usr/bin/python2.7 /usr/bin/python
fi

}

function install-harbor () {
	cd ${HARBOR_FOLDER}
	sed -i "s/<HARBOR-IP>/${SERVER_IP}/g" install.sh
	source install.sh 
}

function down_modules () {
	cd ${HARBOR_FOLDER}
	docker-compose down -v
	sleep 3
}

function up_modules () {
	cd ${HARBOR_FOLDER}
        docker-compose up -d
}

function swagger-load () {
	set -e
	#echo "Doing some clean up..."
	#rm -f *.tar.gz
	if [ ! -f ${DEPLY_ROOT}/swagger.tar.gz]; then
		echo "Downloading Swagger UI release package..."
		wget https://github.com/swagger-api/swagger-ui/archive/v2.1.4.tar.gz -O swagger.tar.gz
	else
		echo "swagger.tar.gz has been existing..."
	fi
	echo "Untarring Swagger UI package to the static file path..."
	mkdir -p /src/ui/static/vendors
	tar -C /src/ui/static/vendors -zxf swagger.tar.gz swagger-ui-2.1.4/dist
	echo "Executing some processes..."
	sed -i.bak 's/http:\/\/petstore\.swagger\.io\/v2\/swagger\.json/'$SCHEME':\/\/'$SERVER_IP'\/static\/resources\/yaml\/swagger\.yaml/g' \
	/src/ui/static/vendors/swagger-ui-2.1.4/dist/index.html
	sed -i.bak '/jsonEditor: false,/a\        validatorUrl: null,' /src/ui/static/vendors/swagger-ui-2.1.4/dist/index.html
	mkdir -p /src/ui/static/resources/yaml
	if [ ! -f ${DEPLY_ROOT}/swagger.tar.gz]; then
                echo "Downloading Swagger.yaml from Harbor project"
                wget https://raw.githubusercontent.com/vmware/harbor/master/docs/swagger.yaml
        else
                echo "Swagger.yaml has been existing..."
        fi
	cp swagger.yaml /src/ui/static/resources/yaml
	sed -i.bak 's/host: localhost/host: '$SERVER_IP'/g' /src/ui/static/resources/yaml/swagger.yaml
	sed -i.bak 's/  \- http$/  \- '$SCHEME'/g' /src/ui/static/resources/yaml/swagger.yaml
	echo "Finish preparation for the Swagger UI."
}

function RESTful_Create () {
	curl -u admin:Emotibot1 -X POST --header 'Content-Type: application/json' --header 'Accept: text/plain' -d '{"project_name": "emotibot-k8s","public": 0,"enable_content_trust": true,"prevent_vulnerable_images_from_running": true,"prevent_vulnerable_images_from_running_severity": "string","automatically_scan_images_on_push": true}' "http://$SERVER_IP/api/projects"
}

pre-install
swagger-load
install-harbor
echo "sleep 10 seconds........... , waiting for harbor"
sleep 10
#RESTful_Create
