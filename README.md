# Dotfiles & Configs

### Note: This dotfiles are inspired by the [Antonio Sarosi](https://github.com/antoniosarosi/) configuration files

# Table of Contents

- [Arch installation](#arch-installation)
- [Login and window manager](#login-and-window-manager)
- [Basic qtile configuration](#basic-qtile-configuration)
- [Basic system utilities](#basic-system-utilities)
  - [Wallpaper](#wallpaper)
  - [Fonts](#fonts)
  - [Audio](#audio)
  - [AUR helper](#aur-helper)
  - [Storage](#storage)
  - [Network](#network)
  - [Systray](#systray)
  - [Autolock](#autolock)
  - [Notifications](#notifications)
  - [Mousepad](#mousepad)
  - [Compositor](#compositor)
- [Other tools](#other-tools)
  - [Media Transfer Protocol](#media-transfer-protocol)
  - [File Manager](#file-manager)
- [Theming](#theming)
  - [GTK Theming](#gtk-theming)
  - [Lightdm theming](#lightdm-theming)
- [Installation](#installation)
- [Software](#software)

# Arch installation

The starting point of this guide is right after a complete clean Arch based
distro installation. The
**[Arch Wiki](https://wiki.archlinux.org/index.php/Installation_guide)**
doesn't tell you what to do after setting the root password, it suggests installing
a bootloader, but before that I would make sure to have working internet:

```bash
pacman -S networkmanager
systemctl enable NetworkManager
```

Now you can install a bootloader and test it "safely", this is how to do it on
modern hardware,
[assuming you've mounted the efi partition on /boot](https://wiki.archlinux.org/index.php/Installation_guide#Example_layouts):

```bash
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot
os-prober
grub-mkconfig -o /boot/grub/grub.cfg
```

Now you can create your user:

```bash
useradd -m username
passwd username
usermod -aG wheel,video,audio,storage username
```

In order to have root privileges we need sudo:

```bash
pacman -S sudo
```

Edit **/etc/sudoers** with nano or vim by uncommenting this line:

```bash
## Uncomment to allow members of group wheel to execute any command
# %wheel ALL=(ALL) ALL
```

Now you can reboot:

```bash
# Exit out of ISO image, unmount it and remove it
exit
umount -R /mnt
reboot
```

After logging in, your internet should be working just fine, but that's only if
your computer is plugged in. If you're on a laptop with no Ethernet ports, you
might have used **[iwctl](https://wiki.archlinux.org/index.php/Iwd#iwctl)**
during installation, but that program is not available anymore unless you have
installed it explicitly. However, we've installed
**[NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager)**,
so no problem, this is how you connect to a wireless LAN with this software:

```bash
# List all available networks
nmcli device wifi list
# Connect to your network
nmcli device wifi connect YOUR_SSID password YOUR_PASSWORD
```

Check [this page](https://wiki.archlinux.org/index.php/NetworkManager#nmcli_examples)
for other options provided by _nmcli_. The last thing we need to do before
thinking about desktop environments is installing **[Xorg](https://wiki.archlinux.org/index.php/Xorg)**:

```bash
sudo pacman -S xorg
```

# Login and window manager

First, we need to be able to login and open some programs like a browser and a
terminal, so we'll start by installing **[lighdm](https://wiki.archlinux.org/index.php/LightDM)**
and **[qtile](https://wiki.archlinux.org/index.php/Qtile)**. Lightdm will not
work unless we install a **[greeter](https://wiki.archlinux.org/index.php/LightDM#Greeter)**.
We also need
**[xterm](https://wiki.archlinux.org/index.php/Xterm)** because that's the
terminal emulator qtile will open by default, until we change the config file.
Then, a text editor is necessary for editing config files, I will use **[neovim](https://wiki.archlinux.org/index.php/Neovim)**. Last but not least,
we need a browser.

```bash
sudo pacman -S lightdm lightdm-gtk-greeter qtile xterm nvim firefox
```

Enable _lightdm_ service and restart your computer, you should be able to log into
Qtile through _lightdm_.

```bash
sudo systemctl enable lightdm
reboot
```

# Basic qtile configuration

Before doing anything else, if you don't have a US keyboard, you should
change it using _setxkbmap_. For example to
change your layout to spanish:

```bash
setxkbmap latam
```

Note that this change is not permanent, if you reboot you have to type that
command again. See [this section](#xprofile) for making it permanent, or
follow the natural order of this guide if you have enough time.

There is no menu by default, you have to launch programs through xterm. At this
point, you can pick your terminal emulator of choice and install a program
launcher.

```bash
# Install another terminal emulator if you want
sudo pacman -S kitty
```

Now open the config file:

```bash
nvim ~/.config/qtile/config.py
```

At the beginning, after imports, you should find an array called _keys_,
and it contains the following line:

```python
Key([mod], "Return", lazy.spawn("xterm")),
```

Change that line to launch your terminal emulator:

```python
Key([mod], "Return", lazy.spawn("kitty")),
```

Now you can delete xterm

```bash
sudo pacman -Rs xterm
```

Then install a program launcher called
**[rofi](https://wiki.archlinux.org/index.php/Rofi)**

```bash
sudo pacman -S rofi
```

Then add keybindings for that program:

```python
Key([mod], "m", lazy.spawn("rofi -show run")),
Key([mod, 'shift'], "m", lazy.spawn("rofi -show")),
```

Now restart Qtile with **mod + control + r**. You should be able to open your
menu and terminal emulator with keybindings. You can
change rofi's theme like so:

```bash
sudo pacman -S which
rofi-theme-selector
```

That's it for Qtile, now you can start hacking on it and make it your own.
But before that I would recommend configuring basic utilities like audio,
battery, mounting drives, etc.

# Basic system utilities

In this section we will install some basic programs to make our Arch useful. This sofware is required for the dotfiles in this repository.

## Wallpaper

First things first, your screen looks empty and black, so you might want to have
a wallpaper not to feel so depressed. Install
**[feh](https://wiki.archlinux.org/index.php/Feh)** and and set your wallpaper:

```bash
sudo pacman -S feh
feh --bg-scale path/to/wallpaper
```

## Fonts

Fonts in Arch Linux are basically a meme, before you run into any problems
you can just use the simple approach of installing these packages:

```bash
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts ttf-ubuntu-mono-nerd
```

To list all available fonts:

```bash
fc-list
```

## Audio

There is no audio at this point, we need
**[pulseaudio](https://wiki.archlinux.org/index.php/PulseAudio)**.
I suggest also installing a graphical program to control audio like
**[pavucontrol](https://www.archlinux.org/packages/extra/x86_64/pavucontrol/)**,
because we don't have keybindings for that yet, and [pamixer](https://www.archlinux.org/packages/community/x86_64/pamixer/) for a better CLI experience:

```bash
sudo pacman -S pulseaudio pavucontrol pamixer
```

On Arch,
[pulseaudio is enabled by default](https://wiki.archlinux.org/index.php/PulseAudio#Running),
but you might need to reboot in order for it to actually start. After rebooting,
you can open _pavucontrol_ through _rofi_, unmute the audio, and you should be
just fine.

## Brightness

If you're on a laptop, you might also want to control the brightness of your screen,
and for that I recommend
**[brightnessctl](https://www.archlinux.org/packages/community/x86_64/brightnessctl/)**:

```bash
sudo pacman -S brightnessctl
```

You can add these keybindings and restart Qtile after:

```python
# Brightness
Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
```

## AUR helper

Now that you have some software that allows you tu use your computer without
losing your patience, it's time to do more interesting stuff. First, install an
**[AUR helper](https://wiki.archlinux.org/index.php/AUR_helpers)**, I use
**[yay](https://github.com/Jguer/yay)**:

```bash
sudo pacman -S base-devel git
cd /opt/
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R username:username yay-git/
cd yay-git
makepkg -si
```

With an _Arch User Repository helper_, you can basically install
any piece of software on this planet that was meant to run on Linux.

## Storage

Another basic utility you might need is automounting external hard drives or
USBs. For that I use **[udisks](https://wiki.archlinux.org/index.php/Udisks)**
and **[udiskie](https://www.archlinux.org/packages/community/any/udiskie/)**.
_udisks_ is a dependency of _udiskie_, so we only need to install the last one.
Install also **[ntfs-3g](https://wiki.archlinux.org/index.php/NTFS-3G)**
package to read and write NTFS formatted drives:

```bash
sudo pacman -S udiskie ntfs-3g
```

## Network

We have configured the network through _nmcli_, but a graphical frontend is
more friendly. I use
**[nm-applet](https://wiki.archlinux.org/index.php/NetworkManager#nm-applet)**:

```bash
sudo pacman -S network-manager-applet
```

## Systray

By default, you have a system tray in Qtile, but there's nothing running in it.
You can launch the programs we've just installed like so:

```bash
udiskie -t &
nm-applet &
```

Now you should see icons that you can click to configure drives and networking.
Optionally, you can install tray icons for volume and battery:

```bash
sudo pacman -S volumeicon cbatticon
volumeicon &
cbatticon &
```

## Autolock

For this task you'll need to install two programs, [xautolock](https://archlinux.org/packages/community/x86_64/xautolock/) and [i3lock-fancy](https://aur.archlinux.org/packages/i3lock-fancy-git)

```bash
yay -S xautolock i3lock-fancy-git
```

Then type this command for locking your screen

```bash
i3lock-fancy
```

## Notifications

I like having desktop notifications as well, for that you need to install
[**libnotify**](https://wiki.archlinux.org/index.php/Desktop_notifications#Libnotify)
and [**notification-daemon**](https://www.archlinux.org/packages/community/x86_64/notification-daemon/):

```bash
sudo pacman -S libnotify notification-daemon
```

For a tiling window manager,
[this is how you can get notifications](https://wiki.archlinux.org/index.php/Desktop_notifications#Standalone):

```bash
# Create this file with nano or vim
sudo nano /usr/share/dbus-1/services/org.freedesktop.Notifications.service
# Paste these lines
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/lib/notification-daemon-1.0/notification-daemon
```

Test it like so:

```bash
notify-send "Hello World"
```

## Mousepad

This are some configurations that will make your mousepad work better. Follow this steps:

```bash
cd /etc/X11/xorg.conf.d/
sudo nvim 30-touchpad.conf
```

Then add this to the new file:

```ini
Section "Inputclass"
	Identifier "devname"
	Driver "libinput"
	Option "Tapping" "on"
	Option "NaturalScrolling" "false"
EndSection
```

## Compositor

Finally, for tranparency and fancy looking things, install a compositor:

```bash
sudo pacman -S picom
```

# Other tools

## Media Transfer Protocol

If you want to connect your phone to your computer using a USB port, you'll
need MTP implementation and some CLI to use it, like
[this one](https://aur.archlinux.org/packages/simple-mtpfs/):

```bash
sudo pacman -S libmtp
yay -S simple-mtpfs

# List connected devices
simple-mtpfs -l
# Mount first device in the previous list
simple-mtpfs --device 1 /mount/point
```

## File Manager

We've done all files stuff through a terminal up to this point, but you can
install a graphical file manager. I use
**[pcmanfm](https://wiki.archlinux.org/title/PCManFM)**

```bash
sudo pacman -S pcmanfm
```

# Theming

## GTK Theming

The moment you have been wating for has arrived, you are finally going to
install a dark theme. I use _Material Black Colors_, so go grab a flavor
[here](https://www.gnome-look.org/p/1316887/) and the matching icons
[here](https://www.pling.com/p/1333360/).

I suggest starting with
_Material-Black-Blueberry_ and _Material-Black-Blueberry-Suru_. You can find
other GTK themes [on this page](https://www.gnome-look.org/browse/cat/135/).
Once you have your theme folders downloaded, this is what you do:

```bash
# Assuming you have downloaded Material-Black-Blueberry
cd Downloads/
sudo pacman -S unzip
unzip Material-Black-Blueberry.zip
unzip Material-Black-Blueberry-Suru.zip
rm Material-Black*.zip
```

```bash
sudo mv Material-Black-Blueberry /usr/share/themes
sudo mv Material-Black-Blueberry-Suru /usr/share/icons
```

This will just install the theme, when you clone the dotfiles you will see the changes.

## Lightdm theming

We can also change the theme of _lightdm_ and make it look cooler, because why
not? We need another greeter, and some theme, namely
**[lightdm-webkit2-greeter](https://www.archlinux.org/packages/community/x86_64/lightdm-webkit2-greeter/)**
and **[lightdm-webkit-theme-aether](https://aur.archlinux.org/packages/lightdm-webkit-theme-aether/)**:

```bash
sudo pacman -S lightdm-webkit2-greeter
yay -S lightdm-webkit-theme-aether
```

These are the configs you need to make:

```ini
# /etc/lightdm/lightdm.conf
[Seat:*]
# ...
# Uncomment this line and set this value
greeter-session = lightdm-webkit2-greeter
# ...

# /etc/lightdm/lightdm-webkit2-greeter.conf
[greeter]
# ...
webkit_theme = lightdm-webkit-theme-aether
```

# Installation

Now you're able to clone this dotfiles. But first, we will install [stow](https://archlinux.org/packages/community/any/stow/), this tool will help us with the organization of our dotfiles.

```bash
sudo pacman -S stow
```

Now create a special directory on your home directory called _.dotfiles_.

```bash
mkdir ~/.dotfiles
```

Then clone this repository inside of that directory and use stow to set the dotfiles.

```bash
cd ~/.dotfiles
git clone https://github.com/LugpDev2022/dotfiles.git
stow .
```
