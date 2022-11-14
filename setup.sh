#/bin/bash
cat << "HDR"

d8888b. d88888b db      db        db    db d8888b. .d8888.   .d888b.    d8888b. d8888b. d88888b  .o88b. d888888b .d8888. d888888b  .d88b.  d8b   db 
88  `8D 88'     88      88        `8b  d8' 88  `8D 88'  YP   8P   8D    88  `8D 88  `8D 88'     d8P  Y8   `88'   88'  YP   `88'   .8P  Y8. 888o  88 
88   88 88ooooo 88      88         `8bd8'  88oodD' `8bo.     `Vb d8'    88oodD' 88oobY' 88ooooo 8P         88    `8bo.      88    88    88 88V8o 88 
88   88 88~~~~~ 88      88         .dPYb.  88~~~     `Y8b.    d88C dD   88~~~   88`8b   88~~~~~ 8b         88      `Y8b.    88    88    88 88 V8o88 
88  .8D 88.     88booo. 88booo.   .8P  Y8. 88      db   8D   C8' d8D    88      88 `88. 88.     Y8b  d8   .88.   db   8D   .88.   `8b  d8' 88  V888 
Y8888D' Y88888P Y88888P Y88888P   YP    YP 88      `8888Y'   `888P Yb   88      88   YD Y88888P  `Y88P' Y888888P `8888Y' Y888888P  `Y88P'  VP   V8P                                                                                                                                        
HDR

cat <<"SDR"

db    db d8888b. db    db d8b   db d888888b db    db   .d888b.    d8888b. d88888b d8888b. d888888b  .d8b.  d8b   db       dD    d88b  .d8b.  .88b  d88. .88b  d88. db    db Cb       .d8888. d88888b d888888b db    db d8888b. 
88    88 88  `8D 88    88 888o  88 `~~88~~' 88    88   8P   8D    88  `8D 88'     88  `8D   `88'   d8' `8b 888o  88     d8'     `8P' d8' `8b 88'YbdP`88 88'YbdP`88 `8b  d8'  `8b     88'  YP 88'     `~~88~~' 88    88 88  `8D 
88    88 88oooY' 88    88 88V8o 88    88    88    88   `Vb d8'    88   88 88ooooo 88oooY'    88    88ooo88 88V8o 88    d8        88  88ooo88 88  88  88 88  88  88  `8bd8'     8b    `8bo.   88ooooo    88    88    88 88oodD' 
88    88 88~~~b. 88    88 88 V8o88    88    88    88    d88C dD   88   88 88~~~~~ 88~~~b.    88    88~~~88 88 V8o88   C88        88  88~~~88 88  88  88 88  88  88    88       88D     `Y8b. 88~~~~~    88    88    88 88~~~   
88b  d88 88   8D 88b  d88 88  V888    88    88b  d88   C8' d8D    88  .8D 88.     88   8D   .88.   88   88 88  V888    V8    db. 88  88   88 88  88  88 88  88  88    88       8P    db   8D 88.        88    88b  d88 88      
~Y8888P' Y8888P' ~Y8888P' VP   V8P    YP    ~Y8888P'   `888P Yb   Y8888D' Y88888P Y8888P' Y888888P YP   YP VP   V8P     V8.  Y8888P  YP   YP YP  YP  YP YP  YP  YP    YP     .8P     `8888Y' Y88888P    YP    ~Y8888P' 88      
                                                                                                                          VD                                                CP                                                 
SDR

cat << "WCB"
Welcome this script will setup your Dell XPS or Precision (SoonTM) for Ubuntu or Debian 22.04!
This script will ask you basic Yes or No questions!


WCB

#Setup for the Dell XPS 13
while true; do
read -p "Is this Device an XPS 13 (y/n)" choice
  case "$choice" in 
    y|Y ) 
echo "Install Kernel and Drivers for XPS 13"
cat <<"xps13-1" | sudo tee /etc/apt/sources.list.d/oem-somerville-tentacool-meta.list
deb http://dell.archive.canonical.com/ jammy somerville
# deb-src http://dell.archive.canonical.com/ jammy somerville
deb http://dell.archive.canonical.com/ jammy somerville-tentacool
# deb-src http://dell.archive.canonical.com/ jammy somerville-tentacool
xps13-1
cat <<"xps13-2" | sudo tee /etc/apt/sources.list.d/oem-solutions-engineers-ubuntu-oem-projects-meta-jammy.list
deb https://ppa.launchpadcontent.net/oem-solutions-engineers/oem-projects-meta/ubuntu/ jammy main
# deb-src https://ppa.launchpadcontent.net/oem-solutions-engineers/oem-projects-meta/ubuntu/ jammy main
xps13-2

# Activate Repos and update list
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y 
sudo add-apt-repository restricted -y
sudo apt update

# Installing Drivers
sudo apt install \
    ubuntu-oem-keyring \
    oem-somerville-tentacool-meta \
    firmware-sof-signed \
    fprintd \
    libfprint-2-tod1 \
    libfprint-2-tod-dev \
    libpam-fprintd \
    libcamhal-ipu6ep-common \
    libipu6ep \
    gstreamer1.0-icamera \
    inxi \
    alsa-base \
    powertop \
    tlp \
    tlp-rdw -y -qq
sudo apt update

# Install OEM Kernel
sudo apt install linux-oem-22.04 -y -qq

# Starting Upgrade (Needed due to New Kernel and Drivers)
sudo apt update
sudo apt upgrade -y -qq 
sudo apt dist-upgrade -y -qq

# Setting Up Auth (Enable Finger Print Login)
sudo pam-auth-update

# Setting Up Persistant PowerTop
cat << PWM | sudo tee /etc/systemd/system/powertop.service
[Unit]
Description=PowerTOP auto tune

[Service]
Type=idle
Environment="TERM=dumb"
ExecStart=/usr/sbin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
PWM
sudo systemctl daemon-reload
sudo systemctl start powertop.service
sudo systemctl enable powertop.service; break;;
    n|N ) 
    echo "Skipping Install of Drivers and Updates"; break;;
    * ) echo "invalid";;
  esac
done
clear

while true; do
read -p "Start Install Basic Software and GPG-Keys (y/n)" choice
  case "$choice" in 
    y|Y ) 
echo "Install Basic Software and GPG-Keys"
# Install the Basics
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    mesa-utils \
    inetutils-ping \
    speedtest-cli \
    ufw \
    gufw \
    software-properties-common -y -qq

# Install GPG Keys and Repos (Best to have keys ready before needing them!)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/edge.list'
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser-release.list'
sudo apt update -y -qq

# Setting Firewall
sudo ufw enable

# Installing Snapd
sudo apt update
sudo apt install snapd
sudo snap install core

# Installing Flatpak
sudo apt install flatpak gnome-software-plugin-flatpak -y -qq
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Gestures
sudo add-apt-repository ppa:touchegg/stable
sudo apt install touchegg
flatpak install https://dl.flathub.org/repo/appstream/com.github.joseexposito.touche.flatpakref
sudo gpasswd -a $USER input

# Installing Applications (Apps that aren't Developer Orintated)
sudo apt install \
    neofetch \
    simplescreenrecorder \
    htop -y -qq; break;;
    n|N ) 
    echo "Skipping Install Basic Software and GPG-Keys"; break;;
    * ) echo "invalid";;
  esac
done
clear

while true; do
read -p "Do you want to remove FireFox (y/n)" choice
  case "$choice" in 
    y|Y ) 
echo "Removing FireFox Web Browser"
# Remove Applications (Firefox)
sudo apt purge firefox xul-ext-ubufox -y -qq; break;;
    n|N ) 
    echo "Skipping Firefox Removal"; break;;
    * ) echo "invalid";;
  esac
done
clear
while true; do
read -p "Do you want to Install Chrome (y/n)" choice 
  case "$choice" in 
    y|Y ) 
echo "Install Google Chrome"
# Install Google Chrome Browser (ok ok ok ok, have Chrome)
sudo apt install google-chrome-stable; break;;
    n|N ) 
    echo "Skipping Installation of Chrome"; break;;
    * ) echo "invalid";;
  esac
done
clear
while true; do
read -p "Do you want to Install Edge (y/n)" choice 
  case "$choice" in 
    y|Y ) 
echo "Installing Microsoft Edge Browser"
# Install Edge Browser (If you remove firefox you need a replacement no??)

sudo apt install microsoft-edge-stable -y -qq
sudo apt --fix-broken install; break;;
    n|N ) 
    echo "Skipping Installation of Edge"; break;;
    * ) echo "invalid";;
  esac
done
clear
while true; do
read -p "Do you want to Install Brave (y/n)" choice 
  case "$choice" in 
    y|Y ) 
echo "Installing Brave Web Browser"
# Install Brave Browser (If you hate edge and firefox thats leaves brave surely?)

sudo apt install brave-browser -y -qq; break;;
    n|N ) 
    echo "Skipping Installation of Brave"; break;;
    * ) echo "invalid";;
  esac
done
clear
while true; do
read -p "Do you want to Install Dev Tools (y/n)" choice 
  case "$choice" in 
    y|Y ) 
echo "Installing Developer Tools"
# Installing Developer Apps (Now the fun begins!!)
sudo apt install \
    device-tree-compiler \
    build-essential \
    gawk \
    gcc-multilib \
    flex \
    git \
    gettext \
    libncurses5-dev \
    libssl-dev \
    python3-distutils \
    zlib1g-dev \
    libncursesw5-dev \
    xsltproc \
    rsync \
    wget \
    unzip \
    python3 \
    rsync \
    subversion \
    swig \
    time  \
    libelf-dev \
    java-propose-classpath \
    ccache \
    ecj \
    fastjar \
    file \
    g++ \
    python3-setuptools \
    openjdk-11-jdk \
    bcc \
    libxml-parser-perl \
    libusb-dev \
    bin86 \
    sharutils \
    zip \
    fakeroot \
    make \
    sed \
    bison \
    autoconf \
    automake \
    python3 \
    patch \
    perl-modules* \
    python3-dev \
    bash \
    binutils \
    bzip2 \
    gcc \
    util-linux \
    intltool \
    help2man \
    python3 \
    python3-pip \
    python-is-python3 \
    openjdk-17-jdk \
    wireshark \
    nmap \
    whois \
    mtr \
    traceroute \
    tcptraceroute \
    cutecom \
    putty \
    subversion -y -qq

# Installing Developer Apps Still (You didn't think it was over did you?)
sudo apt install docker-ce docker-ce-cli docker-compose containerd.io code -y -qq
sudo python3 -m pip install -U pip setuptools wheel
python3 -m pip install --user black


# Setting groups for Software
sudo groupadd -f docker
sudo usermod -aG docker,adm,dialout $USER

# Setting up VSCode Sensible Defaults

code --install-extension ms-python.python
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension eamodio.gitlens
code --install-extension ms-azuretools.vscode-docker
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension felipecaputo.git-project-manager
code --install-extension FelixIcaza.andromeda
code --install-extension formulahendry.auto-rename-tag
code --install-extension henriqueBruno.github-repository-manager
code --install-extension jeanp413.test-java-extension-pack
code --install-extension magicstack.MagicPython
code --install-extension mhutchie.git-graph
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
code --install-extension ms-toolsai.jupyter-keymap
code --install-extension ms-toolsai.jupyter-renderers
code --install-extension oouo-diogo-perdigao.docthis
code --install-extension paragdiwan.gitpatch
code --install-extension pinage404.git-extension-pack
code --install-extension Pivotal.vscode-spring-boot
code --install-extension redhat.java
code --install-extension redhat.vscode-yaml
code --install-extension reduckted.vscode-gitweblinks
code --install-extension ritwickdey.LiveServer
code --install-extension rust-lang.rust
code --install-extension stylelint.vscode-stylelint
code --install-extension sumneko.lua
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension vscjava.vscode-java-debug
code --install-extension vscjava.vscode-java-dependency
code --install-extension vscjava.vscode-java-pack
code --install-extension vscjava.vscode-java-test
code --install-extension vscjava.vscode-maven
code --install-extension vscode-icons-team.vscode-icons

# Installing Dot Net
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt install dotnet-sdk-6.0 aspnetcore-runtime-6.0 -y -q
sudo flatpak install postman -y -q

## Install Go
wget https://go.dev/dl/go1.19.linux-amd64.tar.gz -O /tmp/go-amd64.tar.gz
sudo tar -C /usr/local -xzf /tmp/go-amd64.tar.gz

if ! grep -qF "export PATH=\$PATH:/usr/local/go/bin" /etc/profile; then
  sudo sh -c 'echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile'
fi

# Install Node.JS
sudo apt install nodejs npm -y -q

# Install RUST & Cargo
curl https://sh.rustup.rs -sSf | sh

# Install Yarn
sudo apt install yarn -y -q; break;;
    n|N ) 
    echo "Skipping Installation of Developer Apps"; break;;
    * ) echo "invalid";;
  esac
done
clear
while true; do
read -p "Do you want to Install Oh-My-Posh (y/n)" choice 
  case "$choice" in 
    y|Y ) 
echo "Installing Oh-My-Posh with Theme"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip
oh-my-posh font install CascadiaCode
oh-my-posh font install Terminus
cat << "THEME" | tee .theme.json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        {
          "background": "#c386f1",
          "foreground": "#ffffff",
          "leading_diamond": "\ue0b6",
          "style": "diamond",
          "template": " {{ .UserName }} ",
          "trailing_diamond": "\ue0b0",
          "type": "session"
        },
        {
          "background": "#ff479c",
          "foreground": "#ffffff",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "folder_separator_icon": " \ue0b1 ",
            "home_icon": "~",
            "style": "folder"
          },
          "style": "powerline",
          "template": " \uf74a  {{ .Path }} ",
          "type": "path"
        },
        {
          "background": "#fffb38",
          "background_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}#FF9248{{ end }}",
            "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#ff4500{{ end }}",
            "{{ if gt .Ahead 0 }}#B388FF{{ end }}",
            "{{ if gt .Behind 0 }}#B388FF{{ end }}"
          ],
          "foreground": "#193549",
          "leading_diamond": "\ue0b6",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "branch_max_length": 25,
            "fetch_stash_count": true,
            "fetch_status": true,
            "fetch_upstream_icon": true
          },
          "style": "powerline",
          "template": " {{ .UpstreamIcon }}{{ .HEAD }}{{ .BranchStatus }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \uf692 {{ .StashCount }}{{ end }} ",
          "trailing_diamond": "\ue0b4",
          "type": "git"
        },
        {
          "background": "#6CA35E",
          "foreground": "#ffffff",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "fetch_version": true
          },
          "style": "powerline",
          "template": " \uf898 {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }} ",
          "type": "node"
        },
        {
          "background": "#8ED1F7",
          "foreground": "#111111",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "fetch_version": true
          },
          "style": "powerline",
          "template": " \ue626 {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ",
          "type": "go"
        },
        {
          "background": "#4063D8",
          "foreground": "#111111",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "fetch_version": true
          },
          "style": "powerline",
          "template": " \ue624 {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ",
          "type": "julia"
        },
        {
          "background": "#FFDE57",
          "foreground": "#111111",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "display_mode": "files",
            "fetch_virtual_env": false
          },
          "style": "powerline",
          "template": " \ue235 {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ",
          "type": "python"
        },
        {
          "background": "#AE1401",
          "foreground": "#ffffff",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "display_mode": "files",
            "fetch_version": true
          },
          "style": "powerline",
          "template": " \ue791 {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ",
          "type": "ruby"
        },
        {
          "background": "#FEAC19",
          "foreground": "#ffffff",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "display_mode": "files",
            "fetch_version": false
          },
          "style": "powerline",
          "template": " \uf0e7{{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ",
          "type": "azfunc"
        },
        {
          "background_templates": [
            "{{if contains \"default\" .Profile}}#FFA400{{end}}",
            "{{if contains \"jan\" .Profile}}#f1184c{{end}}"
          ],
          "foreground": "#ffffff",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "display_default": false
          },
          "style": "powerline",
          "template": " \ue7ad {{ .Profile }}{{ if .Region }}@{{ .Region }}{{ end }} ",
          "type": "aws"
        },
        {
          "background": "#ffff66",
          "foreground": "#111111",
          "powerline_symbol": "\ue0b0",
          "style": "powerline",
          "template": " \uf0ad ",
          "type": "root"
        },
        {
          "background": "#83769c",
          "foreground": "#ffffff",
          "properties": {
            "always_enabled": true
          },
          "style": "plain",
          "template": "<transparent>\ue0b0</> \ufbab{{ .FormattedMs }}\u2800",
          "type": "executiontime"
        },
        {
          "background": "#00897b",
          "background_templates": [
            "{{ if gt .Code 0 }}#e91e63{{ end }}"
          ],
          "foreground": "#ffffff",
          "properties": {
            "always_enabled": true
          },
          "style": "diamond",
          "template": "<parentBackground>\ue0b0</> \ue23a ",
          "trailing_diamond": "\ue0b4",
          "type": "exit"
        }
      ],
      "type": "prompt"
    },
    {
      "segments": [
        {
          "background": "#0077c2",
          "foreground": "#ffffff",
          "style": "plain",
          "template": "<#0077c2,transparent>\ue0b6</> \uf489 {{ .Name }} <transparent,#0077c2>\ue0b2</>",
          "type": "shell"
        },
        {
          "background": "#1BD760",
          "foreground": "#111111",
          "invert_powerline": true,
          "powerline_symbol": "\ue0b2",
          "properties": {
            "paused_icon": "\uf04c ",
            "playing_icon": "\uf04b "
          },
          "style": "powerline",
          "template": " \uf167 {{ .Icon }}{{ if ne .Status \"stopped\" }}{{ .Artist }} - {{ .Track }}{{ end }} ",
          "type": "ytm"
        },
        {
          "background": "#f36943",
          "background_templates": [
            "{{if eq \"Charging\" .State.String}}#40c4ff{{end}}",
            "{{if eq \"Discharging\" .State.String}}#ff5722{{end}}",
            "{{if eq \"Full\" .State.String}}#4caf50{{end}}"
          ],
          "foreground": "#ffffff",
          "invert_powerline": true,
          "powerline_symbol": "\ue0b2",
          "properties": {
            "charged_icon": "\ue22f ",
            "charging_icon": "\ue234 ",
            "discharging_icon": "\ue231 "
          },
          "style": "powerline",
          "template": " {{ if not .Error }}{{ .Icon }}{{ .Percentage }}{{ end }}{{ .Error }}\uf295 ",
          "type": "battery"
        },
        {
          "background": "#2e9599",
          "foreground": "#111111",
          "invert_powerline": true,
          "leading_diamond": "\ue0b2",
          "style": "diamond",
          "template": " {{ .CurrentDate | date .Format }} ",
          "trailing_diamond": "\ue0b4",
          "type": "time"
        }
      ],
      "type": "rprompt"
    }
  ],
  "console_title_template": "{{ .Shell }} in {{ .Folder }}",
  "final_space": true,
  "version": 2
}

THEME
echo 'neofetch' >> ~/.bashrc
echo 'eval "$(oh-my-posh --init --shell bash --config ~/.theme.json)"' >> ~/.bashrc
source .bashrc; break;;
    n|N ) 
    echo "Skipping Installation of Oh-My-Posh"; break;;
    * ) echo "invalid";;
  esac
done
clear

# Clean up time 
sudo apt autoremove -y -qq
rm ~/*.deb
# Completed
while true; do
echo "Script Completed Reboot Time!"
read -p "Reboot Now? (y/n)" choice 
  case "$choice" in 
    y|Y ) 
echo "Rebooting System!"
sudo shutdown -r now; break;;
    n|N ) 
    echo "Please reboot your system soon!"; break;;
 esac
done
exit