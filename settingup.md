# Setting up machine

## Initial set up
Video guides
* Overall video guide: https://www.youtube.com/watch?v=Xynotc9BKe8&t=2580s&pp=ygUNYnRyZnMgc25hcHBlcg%3D%3D\
* btrfs and snapper:  https://www.youtube.com/watch?v=maIu1d2lAiI&pp=ygUNYnRyZnMgc25hcHBlcg%3D%3D

### Update system clock
```
timedatectl
```

### Setting up partitions
List partitions using:
```
lsblk
```

Create partitions:
```
cfdisk /dev/<device_name>
```

Formatting:
```
mkfs.fat -F32 /dev/<efi>
mkswap /dev/<swap>
swapon /dev/<swap>
mkfs.btrfs /dev/<main partition>
```

#### Setting up btrfs and mounting
```
mount /dev/<main partition> /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var_log
umount/mnt
mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@ /dev/<main parttion> /mnt
mkdir -p /mnt/{boot,home,var_log}
mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@home /dev/<main parttion> /mnt/home
mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@var_log /dev/<main parttion> /mnt/var_log
```

```
mount /dev/<boot> /mnt/boot
```

`lsblk` to then verify 


### Install essential packages
```
pacstrap -K /mnt base linux linux-firmware vim <amd-ucode|intel-ucode>
```

### Configure the system
```
genfstab - U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
hwclock --systohc
```


#### Localisation
Uncomment `en_US.UTF-8 UTF-8` within `/etc/locale.gen`

```
locale-gen
```

Create `/etc/locale.conf`
```
LANG=en_US.UTF-8
```

Create `/etc/vconsole.conf`
```
KEYMAP=us
```

#### Networking
Create `/etc/hostname` and add a hostname

Create `/etc/hosts` and add
```
127.0.0.1       localhost
::1             localhost
127.0.1.1       <hostname>.localdomain  <hostname> 
```

#### Setting root password
```
passwd
```

#### Install more stuff
```
pacman -S grub efibootmgr networkmanager dialog wpa_supplicant mtools dosfstools git reflector snapper bluez bluez-utils xdg-utils alsa-utils pipewire-audio pipewire-pulse base-devel linux-headers sudo cups bash-completion 
```

in `/etc/mkinitcpio.conf`, set `MODULES=(btrfs)`

```
mkinitcpio -p linux
```
#### Boot loader
```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Enabling services

```
systemctl enable NetworkManager
systemctl enable cups
systemctl enable bluetooth`
systemctl enable pipewire-pulse
```

### User creation
```
useradd -mG wheel <username>
passwd <username>
```

`EDITOR=vim visudo` and uncomment `%wheel...`

### Reboot
```
exit
umount -a
reboot
```

### Yay
```
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si PKGBUILD
```

### Snapper stuff
```
sudo snapper -c root create-config /
sudo chmod 750 /.snapshots
```

Configure `/etc/snapper/configs/root`
```
ALLOW_USERS="<username>"


# limits for timeline cleanup
TIMELINE_MIN_AGE="3600"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_QUARTERLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

```
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

```
yay -S snap-pac-grub snapper-gui
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Create pacman hooks
```
sudo pacman -S rsync
```

create this file /etc/pacman.d/hooks/50-bootbackup.hook (will also need to first create the directory)
```
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = boot/*

[Action]
Depends = rsync
Description = Backing up /boot...
When = PreTransaction
Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
```


### Install packages
```
sudo pacman -S xorg-server xorg-xinit \
               i3-wm \ 
               firefox \ 
               kitty \ 
               openssh \ 
               zsh zsh-syntax-highlighting \
               blueman \
               pavucontrol \
               unzip zip \ 
               cmake \ 
               maim xdotool xclip \ 
               fzf fd \ 
               noto-fonts noto-fonts-emoji noto-fonts-extra noto-fonts-cjk ttf-jetbrains-mono-nerd otf-latin-modern\ 
               feh \ 
               picom \ 
               python \ 
               nvm \
               polybar \ 
               python-pynvim \
               ripgrep \ 
               gimp libreoffice \ 
               zathura texlive biber texlive-langchinese zathura-pdf-mupdf \ 
               thunar \ 
               wget \ 
               tmux
```

## Configuration

### Summaryy of things to change
* polybar text sizes for the text and the rounded edge
* Xresources resolution
* wallpaper, default location to `config/wallpapers/chill.png`. Otherwise change the wallpaper path within i3

### Opiniated file structure
```
- Downloads
- dev  // most of user stuff here
 - projs
 - temp
 - tools
 - containers
- Pictures
 - Screenshots
- OneDrive
```

After git clone dotfiles to replace `.config`, run `link.sh` to setup all the symbolic links

### Nvim
Just build from source, less painful that way

```
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

### Making nvidia stuff and display work properly
```
sudo pacman -S nvidia-utils nvidia-settings nvidia-open 
sudo nvidia-xconfig
nvidia-settings --load-config-only   // add this to xinitrc
```

Verify with `lsmod | grep nvidia`

```
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
```

Create `/etc/modprobe.d/nvidia.conf` and add `options nvidia NVreg_PreserveVideoMemoryAllocations=1` then `sudo mkinitcpio -P` and reboot

Within `.config/X11/Xresources` set appropriate resolution
```
`Xft.dpi: <resolution. eg: 144>`
```

### Change to zsh as default
`chsh -s $(which zsh)`

### Wallpaper
Add wallpaper picture to `.config/wallpaper` (also tweak i3 to set correct path for wallpaper which uses feh)

### Lock
```
yay -S betterlockscreen
betterlockscreen -u .config/wallpaper/... //update wallpaper
systemctl enable betterlockscreen@$USER
```

### SSH for github
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

#### Adding of key
```
systemctl --user enable --now ssh-agent
```

Add `config` to .ssh folder
```
Host *
    AddKeysToAgent yes
    IdentityFile PRIVATE_KEY_PATH
```

**If lazy, then just add directly to shell config**:
```
eval "$(ssh-agent -s)" &> /dev/null
ssh-add -q ~/key_path;
```

To test connection: `ssh -T git@github.com`


### javascript
```
nvm install --lts
npm install -g yarn
```
#### Configuration
* Configure nvm folder location with `$NVM_DIR`
* Configure npm config location with `$NPM_CONFIG_USERCONFIG`
and in the npmrc file set prefix and cache

### OCaml
```
sudo pacman -S opam
opam init -y
```

#### Configuration
Configure opam root location using $OPAMROOT before `opam init`

### Vivado

Setup distrobox
```
sudo pacman -S distrobox podman
distrobox create --name vivado --image ubuntu:24.04 // keep the name to use the vivado zsh within `.config/zsh/containers/vivado`
distrobox enter vivado 
```

### Onedrive
```
yay -S onedrive-abraunegg
```

```
onedrive --sync --single-directory="SharedDrive"
```

Then remember to enable the custom sync service instead of onedrive default one which is monitor mode which seems to have issue when you repeatedly save in nvim.


### Tmux
Getting tpm to work:

In the dev folder:
```
git clone https://github.com/tmux-plugins/tpm
```

Within `.config` change the intiailisation of tpm path to the actual path which you git cloned the tpm executable to

Start tmux, then press <prefix> then release and press <kbd>Shift</kbd> + <kbd>i</kbd>

