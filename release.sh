set -ex

USERNAME=stormheg
IMAGE=nginx-php7-alpine

if [ -z "$1" ]
then
    $1=patch
fi

docker run --rm -v ${PWD}:/app treeder/bump@sha256:384d148edc0012013bb42568baf2931ec05c4394509920c951a12c21347a69a5 $1
version=`cat VERSION`
echo "Version: $version"

# Build image
./build.sh

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags

docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
