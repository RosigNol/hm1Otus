docker pull structurizr/lite
xcopy %userprofile%\Documents\GitHub\c4-hm1\lib\ %userprofile%\Documents\GitHub\c4-hm1\mp\lib\ /e /y /r
docker run -it --rm -p 8080:8080 -v %userprofile%\Documents\GitHub\c4-hm1\mp\:/usr/local/structurizr structurizr/lite
