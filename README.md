![banner-by-MysticG](https://github.com/user-attachments/assets/ab61c6a0-11e0-41a8-830c-733f03323618)

# super mario bros. remastered android
this is an android port of the [Super Mario Bros. Remaster](https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public) by [JoeMama](https://github.com/JHDev2006) and [their team](https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public/graphs/contributors). as of release, this port is nearly feature complete. support me by clicking the dumb dog below!🤎

<p align="center">
  <a target="_blank" rel="noopener noreferrer" href="https://donate.yrkl.net">
    <img width="160" alt="thrilled" src="https://github.com/user-attachments/assets/9789b502-579c-435d-939a-1643f7540c04" />
  </a>
</p>

## features

- all levels, menus and settings work as they do on pc
- online level browser works as expected
- android native file picker for rom selection
- controller support
- on screen/touch controls, which star haptic feedback and a run lock button, and are hidden automatically, once a controller is connected
- skip transition screens by tapping on the screen
- optimized mobile renderer
- pre-baked shader cache within the apk

## limitations

- the level editor is still completely unimplemented. tracked [here](https://github.com/mircey/super-mario-bros.-remastered-android/issues/6)
- installing resource packs and custom characters can currently only be done manually, via accessing `/data/data/net.yrkl.smb1r/files`. tracked [here](https://github.com/mircey/super-mario-bros.-remastered-android/issues/2)

## download

get the latest universal release [here](https://github.com/mircey/super-mario-bros.-remastered-android/releases/latest)!

# how to contribute

im happy you want to help!! below are the steps to get a development environment, just like my own.

## how to fork
1. log in to your GitHub account
2. press the fork button on the top right of this page
3. keep the default name

## how to clone
1. open a powershell, i recommend [terminal](https://github.com/microsoft/terminal)
2. [install git](https://git-scm.com/downloads), if you havent yet
3. navigate to your projects folder using `cd`
4. replace `YOUR_NAME` with your GitHub username and run `git clone https://github.com/YOUR_NAME/super-mario-bros.-remastered-android.git`
5. run `cd super-mario-bros.-remastered-android; mkdir .\android\build\libs\release; curl https://github.com/mircowuffwuff/Godot-Android-Export-Template-libs/releases/download/4.6.1/godot-lib.template_release.aar -OutFile .\android\build\libs\release\godot-lib.template_release.aar; mkdir .\android\build\libs\debug; curl https://github.com/mircowuffwuff/Godot-Android-Export-Template-libs/releases/download/4.6.1/godot-lib.template_debug.aar -OutFile .\android\build\libs\debug\godot-lib.template_debug.aar`
6. [install Godot 4.6.1](https://godotengine.org/download/archive/4.6.1-stable/), if you havent yet
7. launch Godot
8. import `.\project.godot`

## how to debug
1. install the android-sdk by launching [android studio](https://developer.android.com/studio) for the first time or via [sdkmanager](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html#download-the-android-sdk)
2. open Godot
3. `Editor` -> `Editor Settings` -> `Export` -> `Android`
4. enter your java sdk and android sdk paths. see the [detailed official guide](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) by Godot if you need help.
5. plug an android device into your pc via usb
6. enable developer mode on the android device. this depends on the manufacturer, but generally:
   1. open settings
   2. select `Info`, `About this phone` or `Device`
   3. hit the android version number a couple of times. on Xiaomi devices, hit the MIUI or HyperOS version number instead
7. enable usb debugging and installation via usb on the android device
   1. open settings
   2. scroll down to `Additional settings`
   3. scroll down to `Developer options`
   4. find `USB Debugging` and toggle it on
   5. find `Install via USB` and toggle it on
8. open the project in Godot
9. find the `Remote Deploy` button around the top right corner of the window and press it
10. the game should build and finally launch on your android device, while showing real-time logs in the Godot console

## how to build an apk
1. open the project in Godot
2. `Project` -> `Export` -> `Android` -> `Export Project`
3. choose a target location and give it some time

## how to commit and push

1. `cd super-mario-bros.-remastered-android`
2. add all files, that are relevant to your changes, to git via `git add .\path\to\file.gd`
3. `git commit -a -m "describe your changes here"`
4. check your changes via console output. it should say something like `3 files changed, 21 insertions(+), 4 deletions(-)`. to check the exact changes, enter `git show`, use arrow keys to navigate and press `q` to exit.
5. push your locally committed changes to your forked repository via `git push`

## how to open a pull request
1. make sure your have thoroughly tested all of your changes and that they are ready to be merged into the main repository!!
2. navigate to your forked repository on GitHub
3. hit the contribute button above source
4. hit the open pull request button
5. follow the prompts

# credits

thanks to [JoeMama](https://github.com/JHDev2006), all their [contributors on github](https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public/graphs/contributors) and everyone else who helped bring the original [Windows/Linux version](https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public) of the game to life.

thanks to [Caz Wolf](https://cazwolf.itch.io/) for their amazing work on the [on screen/touch control sprites](https://cazwolf.itch.io/caz-pixel-keyboard?download)!

thanks to [WisconsiKnight](https://www.youtube.com/@WisconsiKnight), [Brackeys](https://www.youtube.com/@Brackeys) and [Gwizz](https://www.youtube.com/@Gwizz1027) for providing Godot tutorials

thanks to Milana for pushing me towards publishing my android port, instead of working on it exclusively privately

thanks to Ömer and Danny for alpha testing and thanks to Kenny for lending me various android devices

thanks to [Celizte](https://github.com/Celizte) for researching and implementing a robust fix for missing on screen/touch controls

thanks to [MysticG](https://www.youtube.com/channel/UC1gK8vwkCyQgJyVlfmVr6Ag) for their amazing work on the banner artwork at the top of the page🤎
