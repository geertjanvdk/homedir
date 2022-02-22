# homedir - Geert's Homedir

This project is used to initialize a new home directory ($HOMEDIR) on Unices (Linux distribution, macOS).

## Usage

You need to have an account available in which you can sign in using SSH and forwared the authenication agent (`ssh -A ..`).

```shell
git clone --recurse-submodules git@github.com:geertjanvdk/homedir.git .homedir
.homedir/setup.sh
```
