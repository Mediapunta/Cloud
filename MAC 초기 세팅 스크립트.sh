#!/bin/bash

## Mac 초기설정
#홈브류 설치를 위한 권한설정
#You should change the ownership of these directories to your user.
#  sudo chown -R $(whoami) /usr/local/share/man/man5 /usr/local/share/man/man7
#sudo chown -R $(whoami) /usr/local/share/man/man5 /usr/local/share/man/man7

# 홈브류 설치
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 홈브류 삭제 ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

#홈브류 업데이트
brew update

#brew update //Homebrew 업데이트
#brew search <패키지 이름> //패키지 검색
#brew install <패키지 이름> //패키지 설치
#brew remove <패키지 이름> //패키지 삭제
#brew list //패키지 리스트
#brew upgrade <패키지 이름> //패키지 업데이트

#"cask"는 Safari, Chrome, Word 등과 같이 그래픽을 통해 작업하는 프로그램을 설치할 수 있게 해주는 패키지입니다.
# cask 설치
brew install cask

#크롬 설치
brew install caskroom/cask/google-chrome
brew cask install google-chrome

# Mounty 설치
# Mounty는 NTFS FileSystem 디스크를 Write 할수 있게 해주는 프로그램
brew cask install mounty

brew install --cask iterm2
brew install --cask cyberduck

# 파이썬을 설치하기 전에 C 컴파일러를 설치해야 합니다. 이를 위해서는 Xcode Command Line Tools을 설치하는 방법이 가장 빠릅니다. xcode-select --install
xcode-select --install

# 파이썬3 설치
brew install python3
# pip 설치 // brew로 python3 설치되면 pip3도 자동 설치 되므로 생략
# sudo easy_install pip

# 파이썬3를 기본 명령으로 지정하기
touch ~/.profile

echo "alias python='python3'" >> ~/.profile
echo "PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"" >> ~/.profile
echo "export PATH" >> ~/.profile

source ~/.profile

## zsh 설치     # brew reinstall zsh // 재설치
brew install zsh

## 기본shell zsh로 변경
chsh -s `which zsh`

## Oh my Zsh! 설치
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

plugins=(git colored-man colorize pip python brew osx zsh-syntax-highlighting)

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# AWS Python SDK 설치
sudo easy_install boto3

# NPM 설치
brew install npm

# wget 설치
brew install wget

# jq 설치 / json 포멧
brew install jq

#AWS CLI 설치
brew install awscli2

#AWS Shell 설치
brew install aws-shell

# s3cmd 설치
wget https://github.com/s3tools/s3cmd/archive/master.zip
unzip master.zip
cd s3cmd-master
sudo python setup.py install

#ECS CLI 설치
#sudo curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-darwin-amd64-latest

#Now, run
#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
#Install amazon-ecs-cli using brew
brew install amazon-ecs-cli

#바이너리에 실행 권한을 적용합니다.
sudo chmod +x /usr/local/bin/ecs-cli

#AWS SNS CLI
#Now, run
#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
#Install aws-sns-cli using brew
#brew install aws-sns-cli


# 파이썬 3.7로 기본 실행 변경 되었는지 확인
python -V

# datadog Python module 설치
#pip3 install datadog