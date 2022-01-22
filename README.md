# Tonguys Pool miner package for HiveOS

It is a HiveOS package for tonguys_pool.

We use [ton-miner-client](https://github.com/tonguys/ton-miner-client) as a pool client and [pow-miner-gpu](https://github.com/tontechio/pow-miner-gpu) as an opencl miner

# Configuring in HiveOS 

## Getting wallet token

First of all, you need to register in our pool and get your wallet token. That's the way we identify you.
1) send any message or just `/start` to `@tonguys_pool_bot` in telegram
2) enter `/set_addres`
3) send the addres of your TON wallet as a single message.
4) When you a success message, enter `/show_wallet`
5) field `Token` is what you need. It should be like `e3624*****************6995`

## Setting up custom miner

1) Go to HiveOS Flight Sheets section and create new Flight Sheet
2) Set the field `Coin` to `TON`
3) Select your wallet
4) In field `Pool` select `Configure in miner`
5) Set the field `Miner` to `Custom` and click `Setup Miner Config`

Then set up custom miner config:
* Miner name: `tonguys_pool`
* Install Url: `https://github.com/tonguys/tonguys-hiveos/releases/download/v0.1.0/tonguys_pool-0.1.0.tar.gz`
* Hash algorithm: `----` (default)
* Wallet and Worker template: `%WAL%`
* Pool url: `null`
* Pass: `x`
* Extra config arguments:
```
token=<token from @tonguys_pool_bot>
gpus=[0-3,5] // this field contains ranges of gpus to use. 
// E.g. if you want miner to use gpus 0, 1, 2, 3 and 5 you should set this parameter to [0-3,5]
```

So, the latest step is to apply this flight sheet to any Rig, you created
