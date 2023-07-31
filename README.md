<p  align="center">

<img  src="https://github.com/Open-Core-Initiative/sturdynet-openwrt-images/assets/41849970/e7f79858-9353-4587-be5c-89e10fa2eace">

</p>

---

## Repository Contents

| File                       | Description                                         |
| :------------------------ | :-------------------------------------------------------- |
| `files/PROFILE_NAME`               | Configurations for the particular device that you want to build the image for can be saved here. Use the device profile name as the directory name.                | 
| `ipks`       | .ipk files of the Openwrt packages to be included in the image can be saved here.                |
| `keys`      | Access key for the remote package repository can be saved here.        |
| `build.sh`       | Build script that executes the imagebuilder make command. Links to package repositories can be added or removed from here. |
| `generate-webpage.sh` | Script that generates an HTML page to be made public for image download        |
| `repositories.conf` | Default Openwrt repository configuration. To be used as a boilerplate in the build process.        |
| `.github/workflows/main.yml` | Yaml file used by GitHub action to build images.        |

---

## Prerequisites

1. Github Runner assigned to the project. A runner needs to be running Ubuntu and has Docker installed. You can learn about self-hosted runners [here](#how-to-setup-a-self-hosted-github-runner).
2. Imagebuilder docker image of the intended build target created from [sturdynet-openwrt-imagebuilder repository](https://github.com/Open-Core-Initiative/sturdynet-openwrt-imagebuilder) repository.
3. Working Openwisp instance with Admin access (Only needed if planning to upload an image to Openwisp).

---

## How to build images?

1. Create a new folder using the device profile as the name in the `files` directory, if not already there.
2. Add or modify any configuration files inside that folder.
3. Steps **1** and **2** can be repeated for any number of devices of the same target.
4. Add any `.ipk` files you want to add to the image to the **ipks** directory.
5. You can also add links to any custom package repository by going to `build.sh` file and paste the link here:

   ```
     ## Custom Repository
     src/gz custom_packages https://open-core-initiative.github.io/sturdynet-openwrt-packages/main/releases/${OPENWRT_VERSION}/packages/${OPENWRT_ARCH}/custom
   ```
6. Using a custom repository will also require an access key which can be added to the `keys` directory.
7. Package then needs to be mentioned in the make command as well in the same `build.sh` file

    ```
    make -j${nproc} image \
	  PROFILE=${I##*/} \
	  PACKAGES='netifyd netify-fwa luci mwan3 luci-app-mwan3 rtty tcpdump bmon iftop netcat socat jq comgt usb-modeswitch rtty-mbedtls luci-app-statistics collectd-mod-    unixsock collectd-mod-mqtt wifischedule luci-app-wifischedule l7stats flow_broker python3-ubus python3-uci curl uhttpd-mod-lua kmod-mii kmod-usb-net kmod-usb-wdm       kmod-usb-net-qmi-wwan uqmi openwisp-config openwisp-monitoring netjson-monitoring openvpn-mbedtls luci-app-openvpn luci-proto-modemmanager' \
	  FILES=${I} \
	  BIN_DIR='${GITHUB_WORKSPACE}/bin' || exit 1

    ```
8. You can then make a commit to the branch with all the changes and it will trigger the build process.
9. Build process can also be triggered manually by going to `Actions` -> `Your Workflow` -> `Run Workflow`

---

## How to build images other than the default target?

By default, we have set the target to **ipq40xx** and are using the imagebuilder of the same target, however, if you want a different target you can follow these steps:

1. If you are building images for a target other than `ipq40xx`, create a new branch for your target from the ipq40xx branch. Make sure to use the target name as the branch name.
2. Open the `.github/workflows/main.yml` and change the container name to your imagebuilder docker image name:
   
     ```
     container: YOUR_DOCKERHUB_USERNAME/YOUR_IMAGEBUILDER_DOCKER_IMAGE
     ```
3. Add the branch name to the `branches`:

     ```
     on:
      push:
        branches: ["ipq40xx", "NEW_BRANCH_NAME"]
     ```
4. Save the file.
5. To enable GitHub page deployment, go to repository setting -> `Environments` -> `github-pages` -> `Add deployment branch rule` -> Write your branch name -> `Add rules`.
6. You can then follow the steps mentioned in the above section to build images for this target.

---

## How to access the images that are built?

To access the built images, just go to the link: https://open-core-initiative.github.io/sturdynet-openwrt-images/GITHUB_BRANCH_NAME/.

For example, if want to access **ipq40xx** images, go to: https://open-core-initiative.github.io/sturdynet-openwrt-images/ipq40xx/

---

## How to upload an image to Openwisp?

1. Create a [category](https://openwisp.io/docs/user/firmware-upgrades.html#create-a-category) in Openwisp.
2. Create a [build object](https://openwisp.io/docs/user/firmware-upgrades.html#create-the-build-object).
3. Enable Openwisp [Rest API](https://github.com/openwisp/openwisp-firmware-upgrader/tree/1.0#rest-api)
4. [Obtain Authentication Token](https://github.com/openwisp/openwisp-users#obtain-authentication-token)
5. Add a [Custom image type](https://github.com/openwisp/openwisp-firmware-upgrader/tree/1.0#openwisp_custom_openwrt_images)
6. Go to the Github repository setting -> `Actions secrets and variables` and add the following 4 secrets:
   
    | Secret name                       | Description                                         |
    | :------------------------ | :-------------------------------------------------------- |
    | `OWISP_BASE_URL`               | Home URL of your Openwisp instance.                | 
    | `OWISP_BUILD_ID`       | Id of the build object you created. Can be obtained from its URL.                |
    | `OWISP_PASSWORD`      | Password of the Openwisp user, which will be used to generate bearer token.        |
    | `OWISP_USERNAME`       | Username of the Openwisp user, which will be used to generate bearer token. |

7. Open the `.github/workflows/main.yml` and change the firmware file name to the custom image name, this generated image will be uploaded to the Openwisp:
   
     ```
     run: echo "FIRMWARE_FILE_NAME=YOUR_CUSTOM_FILENAME_HERE" >> $GITHUB_ENV
     ```
8. That's it for Openwisp setup. You can also comment out the entire Openwisp code from the main.yml file if you are not using that.

---

## How to setup a self-hosted Github runner?

To create a self-hosted runner for this project we need to have a Ubuntu running instance with [Docker installed](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository). AWS EC2 instance recommended.

1. Go to the Github repository setting -> `Actions` -> `Runners` -> `New self-hosted runner`.
2. Follow the steps for `Linux`
3. In your Ubuntu instance terminal, run `sudo ./svc.sh install`
4. Give access to docker, run `sudo usermod -a -G docker <GITHUB_RUNNER_USER>`
5. Run `sudo ./svc.sh start`
