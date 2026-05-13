# Arch Linux Setup Guide


## 1. Pre-installation
> - [Overall video guide](https://www.youtube.com/watch?v=Xynotc9BKe8&t=2580s)
> - [btrfs + snapper guide](https://www.youtube.com/watch?v=maIu1d2lAiI)

### Sync system clock
```bash
timedatectl
```

### Partition the disk
```bash
lsblk
cfdisk /dev/<device>
```

### Format partitions
```bash
mkfs.fat -F32 /dev/<efi>
mkswap /dev/<swap>
swapon /dev/<swap>
mkfs.btrfs /dev/<main>
```

### Set up btrfs subvolumes
```bash
mount /dev/<main> /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
umount /mnt
```

### Mount subvolumes
```bash
mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@ /dev/<main> /mnt
mkdir -p /mnt/{boot,home,var/log}
mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@home /dev/<main> /mnt/home
mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@var_log /dev/<main> /mnt/var/log
mount /dev/<efi> /mnt/boot
```

Verify with `lsblk`.

---

## Base Install

### Pacstrap
```bash
# Choose either amd-ucode or intel-ucode
pacstrap -K /mnt base linux linux-firmware vim amd-ucode
```

### Generate fstab and chroot
```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

### Timezone and clock
```bash
ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
hwclock --systohc
```

### Localisation
Uncomment `en_US.UTF-8 UTF-8` in `/etc/locale.gen`, then:
```bash
locale-gen
```

Create `/etc/locale.conf`:
```
LANG=en_US.UTF-8
```

Create `/etc/vconsole.conf`:
```
KEYMAP=us
```

### Networking
Create `/etc/hostname` and add a hostname.

Create `/etc/hosts`:
```
127.0.0.1       localhost
::1             localhost
127.0.1.1       <hostname>.localdomain  <hostname>
```

### Root password
```bash
passwd
```

### Install packages
```bash
pacman -S grub efibootmgr networkmanager dialog wpa_supplicant mtools dosfstools \
          git reflector snapper bluez bluez-utils xdg-utils alsa-utils \
          pipewire pipewire-audio pipewire-pulse base-devel linux-headers \
          sudo cups bash-completion
```

### Configure mkinitcpio
In `/etc/mkinitcpio.conf`, set:
```
MODULES=(btrfs)
```

Then regenerate:
```bash
mkinitcpio -p linux
```

### Bootloader
```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### Enable services
```bash
systemctl enable NetworkManager
systemctl enable cups
systemctl enable bluetooth
systemctl enable pipewire-pulse
```

### Create user
```bash
useradd -mG wheel <username>
passwd <username>
```

Uncomment `%wheel ALL=(ALL:ALL) ALL` via: `EDITOR=vim visudo`

### Reboot
```bash
exit
umount -a
reboot
```

---

## Yay

```bash
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si PKGBUILD
```

---

## Snapper

```bash
sudo snapper -c root create-config /
sudo chmod 750 /.snapshots
```

Configure `/etc/snapper/configs/root`:
```
ALLOW_USERS="<username>"

TIMELINE_MIN_AGE="3600"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_QUARTERLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

```bash
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

```bash
yay -S snap-pac-grub snapper-gui
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Boot backup pacman hook

```bash
sudo pacman -S rsync
sudo mkdir -p /etc/pacman.d/hooks
```

Create `/etc/pacman.d/hooks/50-bootbackup.hook`:
```ini
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

---

## 5. Packages

```bash
sudo pacman -S \
  xorg-server xorg-xinit \
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
  noto-fonts noto-fonts-emoji noto-fonts-extra noto-fonts-cjk \
  ttf-jetbrains-mono-nerd otf-latin-modern \
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
  tmux \
  htop \
  sof-firmware alsa-firmware \
  inetutils \
  redshift \
  rnote \
  fcitx5-im fcitx5-chinese-addons
```
---

## Configuration

### File structure
```
~
├── Downloads/
├── dev/
│   ├── projs/
│   ├── temp/
│   ├── tools/
│   └── containers/
├── Pictures/
│   └── Screenshots/
└── OneDrive/
```

### Dotfiles
Clone dotfiles to replace `.config`, then run `link.sh` to set up symlinks.

### Machine-specific adjustments
- Polybar: font sizes for text and rounded edges
- `~/.config/X11/Xresources`: set DPI to match display (e.g. `Xft.dpi: 144`)
- Wallpaper: default path `~/.config/wallpapers/chill.png` — update path in i3 config if different

## JavaScript / Node

```bash
nvm install --lts
npm install -g yarn
```

### Configuration
- Set nvm directory: `$NVM_DIR`
- Set npm config location: `$NPM_CONFIG_USERCONFIG`
- In the `.npmrc` file, configure `prefix` and `cache`

---

## Neovim
Just build from source, less painful that way
```bash
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

---

## 9. NVIDIA

```bash
sudo pacman -S nvidia-utils nvidia-settings nvidia-open
sudo nvidia-xconfig
```

Add to `~/.xinitrc`:
```bash
nvidia-settings --load-config-only
```

Verify: `lsmod | grep nvidia`

```bash
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
```

Create `/etc/modprobe.d/nvidia.conf`:
```
options nvidia NVreg_PreserveVideoMemoryAllocations=1
```

Rebuild initramfs and reboot:
```bash
sudo mkinitcpio -P
reboot
```

Set DPI in `~/.config/X11/Xresources`:
```
Xft.dpi: 144
```

---

## Shell

### Set zsh as default
```bash
chsh -s $(which zsh)
```

---

##  Wallpaper & Lock

### Wallpaper
Add wallpaper to `~/.config/wallpaper/` and update the path in your i3 config (`feh` is used).

### Lock screen
```bash
sudo pacman -S xss-lock
yay -S betterlockscreen
betterlockscreen -u ~/.config/wallpaper/<image>
```

> Ensure the `betterlockscreen` systemd service is not enabled — it will conflict with `xss-lock`.

---

## SSH & GitHub

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Enable ssh-agent
```bash
systemctl --user enable --now ssh-agent
```

Create `~/.ssh/config`:
```
Host *
    AddKeysToAgent yes
    IdentityFile <path_to_private_key>
```

Alternatively, add to shell config (lazy option):
```bash
eval "$(ssh-agent -s)" &> /dev/null
ssh-add -q ~/path/to/key
```

Test: `ssh -T git@github.com`

---

## OCaml

```bash
sudo pacman -S opam
opam init -y
```

> Configure opam root location with `$OPAMROOT` **before** running `opam init`.

---

## 14. Vivado (via Distrobox)

```bash
sudo pacman -S distrobox podman
distrobox create --name vivado --image ubuntu:24.04
distrobox enter vivado
```

> Keep the container name `vivado` to match the zsh config at `~/.config/zsh/containers/vivado`.

---

## OneDrive

```bash
yay -S onedrive-abraunegg
onedrive --sync --single-directory="SharedDrive"
```
Still problematic

---

## Tmux

Clone TPM into your dev folder:
```bash
git clone https://github.com/tmux-plugins/tpm ~/dev/tools/tpm
```

Update the TPM path in `~/.config/tmux/tmux.conf` to match where you cloned it.

Start tmux, then press `<prefix>` followed by `Shift+I` to install plugins.

---

## Docker

```bash
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
```

> Log out and back in for the group change to take effect.

---

## XP Pen / Drawing Tablet

```bash
sudo pacman -S rnote
yay -S xp-pen-tablet
sudo usermod -aG input $USER
sudo modprobe uinput
echo 'KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"' \
  | sudo tee /etc/udev/rules.d/99-uinput.rules
reboot
```

---

## Chinese Input (fcitx5)

After installing `fcitx5-im` and `fcitx5-chinese-addons` (done in packages step), add to `.zshenv`:

```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

Start fcitx5 from your i3 config

Open fcitx5-configtools and add pinyin input method

---

## Redshift

```bash
cp /usr/share/doc/redshift/redshift.conf.example ~/.config/redshift.conf
```

Edit `~/.config/redshift.conf` and set your latitude/longitude.

---

## Boot Time Optimisation

```bash
sudo systemctl disable NetworkManager-wait-online.service
```

