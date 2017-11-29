# Mailing Dropbox Storage Docker Container

### This docker container upload a file to dropbox and send a mail with this file link

### Usage

         docker run -it --rm -e FROM='test@gmail.com' -e TO='test@gmail.com' -e SUBJECT='topic' -e DROPBOX_ACCESS_TOKEN='token' -e DROPBOX_FOLDER='folder' -e FILE_NAME='test.file' -v $PWD:/tmp/ --name mail-app mail-dropbox-storage
