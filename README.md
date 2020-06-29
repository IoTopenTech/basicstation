[![Build Status](https://travis-ci.com/lorabasics/basicstation.svg?branch=master)](https://travis-ci.com/lorabasics/basicstation)

# LoRa Basics™ Station using balena.io and RAK2245

This project deploys a TTN LoRa gateway with Basics Station Packet Forward protocol with balena. It runs on a Raspberry Pi or balenaFin with a RAK2245 Pi Hat. 


## Introduction

Deploy a The Things Network (TTN) LoRa gateway running the basics station Semtech Packet Forward protocol. We are using balena.io and RAK to reduce fricition for the LoRa gateway fleet owners.

The Basics Station protocol enables the LoRa gateways with a reliable and secure communication between the gateways and the cloud and it is becoming the standard Packet Forward protocol used by most of the LoRaWAN operators.


## Getting started

### Hardware

* Raspberry Pi 4 or [balenaFin](https://www.balena.io/fin/)
* [RAK 2245 pi hat](https://store.rakwireless.com/products/rak2245-pi-hat)
* SD card in case of the RPi 4

### Software

* A TTN account ([sign up here](https://console.thethingsnetwork.org)
* A balenaCloud account ([sign up here](https://dashboard.balena-cloud.com/)
* [balenaEtcher](https://balena.io/etcher)

Once all of this is ready, you are able to deploy this repository following instructions below.


### Via [Balena Deploy](https://www.balena.io/docs/learn/deploy/deploy-with-balena-button/)

Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/balena-io-playground/basicstation)

Follow instructions, click Add a Device and flash an SD card with that OS image dowloaded from balenaCloud. Enjoy the magic 🌟Over-The-Air🌟!


### Via [Balena-Cli](https://www.balena.io/docs/reference/balena-cli/)

If you are a [balena CLI](https://www.balena.io/docs/reference/balena-cli/) expert, feel free to use balena CLI.

- Sign up on [balena.io](https://dashboard.balena.io/signup)
- Create a new application on balenaCloud.
- Clone this repository to your local workspace.
- Using [Balena CLI](https://www.balena.io/docs/reference/cli/), push the code with `balena push <application-name>`
- See the magic happening, your device is getting updated 🌟Over-The-Air🌟!


### Before configure your LoRa gateway

The LoRa gateways are manufactured with a unique 64 bits (8 bytes) identifier, called EUI, which can be used to register the gateway on The Things Network. To get the EUI from your board it’s important to know the Ethernet MAC address of it. The TTN EUI will be the Ethernet mac address (6 bytes), which is unique, expanded with 2 more bytes (FFFE). This is a standard way to increment the MAC address from 6 to 8 bytes.

To get the Ethernet mac address of your board go to your balenaCloud dashboard. Go to the terminal box and click "Select a target", then “HostOS”. Once you are inside the shell, type:

```cat /sys/class/net/eth0/address ```

See an example below.

```
// original mac address
b8:27:eb:f0:4f:10
// delete the :
b827ebf04f10
// add FFFE
b827ebFFFEf04f10
```

### Configure your The Things Network gateway

1. Sign up at [The Things Network console](https://console.thethingsnetwork.org/). 
2. Click Gateways button.
3. Click the "Register gateway" link.
4. Check “I’m using the legacy packet forwarder” checkbox.
5. Paste the EUI from the Ethernet mac address of the board (calculated above)
6. Complete the form and click Register gateway.

Once successfully registered, copy the The Things Network gateway KEY to configure your board variables on balenaCloud.

1. Go to balenaCloud dashboard and get into your LoRa gateway device site.
2. Click "Device Variables" button on the left menu and add these variables.

#### Balena LoRa Basics Station Service Variables

Variable Name | Value | Description | Default
------------ | ------------- | ------------- | -------------
**`GW_GPS`** | `STRING` | Enables GPS | true or false
**`GW_ID`** | `STRING` | TTN Gateway EUI | (EUI)
**`GW_KEY`** | `STRING` | Unique TTN Gateway Key | (Key pasted from TTN console)
**`GW_RESET_PIN`** | `STRING` | Pin number that resets | 11 
**`SPI_SPEED`** | `STRING` | The Raspberry Pi and RAK2245 uses SPI to communicate and needs to use a specific speed | 20000000
**`TC_URI`** | `STRING` | basics station TC URI to get connected | ```wss://lns.eu.thethings.network:443```

At this moment your The Things Network gateway should be up and running. Check on the TTN console if it shows the connected status.


## Attribution

- This is an adaptation of the [Semtech Basics Station repository](https://github.com/lorabasics/basicstation). Documentation [here][Basic Station](https://doc.sm.tc/station).
- This is in part working thanks of the work of Jose Marcelino and Marc Pous.
- This is in part based on excellent work done by the Balena.io team.
