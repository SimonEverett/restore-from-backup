#Restore from backup

## Getting installed

### Setup AWS keys

$echo "[effectReadOnlyBackups]" >> ~/.aws/credentials && echo "aws_access_key_id = AKIAQ" >> ~/.aws/credentials && echo "aws_secret_access_key = KdBjP5gCgGTHCxVQVctXAhoak" >> ~/.aws/credentials

### Install software dependencies
$brew install ansible

$sudo python3 -m pip install --upgrade pip

### Setup the alias

$echo "alias rfb='$(pwd)/restore.sh'" >> ~/.zshrc

### Useing
Drop a shell into an project thats already been setup and run:
$rfb

### Project dependencies

Some project need to use a .env and have the following environments variables adding

PRODUCITON_URL
BACKUP_BUCKET

Ontop of the normal;

DATABASE_HOST
DATABASE_USER
DATABASE_NAME
DATABASE_PASSWORD
