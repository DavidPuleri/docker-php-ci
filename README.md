# docker-php-ci
�
1d12d15061bb        docker-registry.mycoachfootball.com:5000/mycoach-physio-web:latest   "nginx -g 'daemon of   11 days ago         Up 11 days          443/tcp, 0.0.0.0:8882->80/tcp    sad_bardeen

�
APP=$1
echo `incrementVersion .` > VERSION
VERSION_NUMBER=`cat VERSION`

echo "Version incremented to ${VERSION_NUMBER}"

git add .
git commit -m"Bump to version $VERSION_NUMBER"
GITDATA=`git log --pretty=format:"%h" | head -1`
git checkout master
git merge $GITDATA


echo "Packaging version : " ${APP}:${VERSION_NUMBER}


composer install --no-dev --optimize-autoloader

sudo rm -rf app/cache/*
sudo rm -rf app/log/*
sudo chmod -Rf 777 app/cache app/logs

#php app/console cache:clear --env=prod --no-debug
php app/console assetic:dump --env=prod

sudo chmod -Rf 777 app/cache app/logs

docker build -t docker-registry.mycoachfootball.com:5000/${APP}:${VERSION_NUMBER} .
docker push docker-registry.mycoachfootball.com:5000/${APP}:${VERSION_NUMBER}

git tag -a "${VERSION_NUMBER}" -m "Tag ready to deploy with its container docker-registry.mycoachfootball.com:5000/${APP}:${VERSION_NUMBER}"
git pull -r origin master
git push origin master --tags
