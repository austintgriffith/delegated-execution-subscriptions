# 🕰️⚙️ Delegated Execution Subscriptions [EIP1337 & EIP948]

Subscriber deploys and funds a proxy (identity) contract. Then, any whitelisted etherless account signs a single off-chain meta transaction that will be periodically sent on-chain and trigger an Ethereum transaction (contract call, token/eth transfer, proxy upgrade, contract deployment, etc).

[https://byoc.metatx.io](https://byoc.metatx.io)

Directly extended from: https://github.com/austintgriffith/token-subscription

Huge thanks to [Owocki](https://twitter.com/owocki) of [Gitcoin](https://gitcoin.co/) and [Andrew Redden](https://twitter.com/androolloyd) of [Groundhog](https://groundhog.network) for the guidance and opportunity to hack on this!

## Demo

[![screencast.png](https://user-images.githubusercontent.com/2653167/45005225-6d23cb00-afaf-11e8-9ce1-874dd8cb1980.jpg)](https://youtu.be/g0o2jEkyYKw)

## Standard


```
    enum SubscriptionStatus {
        ACTIVE,
        PAUSED,
        CANCELLED,
        EXPIRED
    }
    enum Operation {
        Call,
        DelegateCall,
        Create
    }
```


```
    function isSubscriptionPaid(
        bytes32 subscriptionHash,
        uint256 gracePeriodSeconds
    )
        external
        view
        returns (bool)
```



```
    function getSubscriptionStatus(
        bytes32 subscriptionHash
    )
        public
        view
        returns  (uint256)
```



```
    function getSubscriptionHash(
        address from, //the subscriber
        address to, //the target contract or account
        uint256 value, //amount in wei of ether sent from this contract to the to address
        bytes data, //the encoded transaction data (first four bytes of fn plus args, etc)
        Operation operation, //ENUM of operation
        uint256 periodSeconds, //the period in seconds between payments
        address gasToken, //the address of the token to pay relayer (0 for eth)
        uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
        address gasPayer //the address that will pay the tokens to the relayer
    )
        public
        view
        returns (bytes32)
```



```
    function getModifyStatusHash(
        bytes32 subscriptionHash,
        SubscriptionStatus status
    )
        public
        view
        returns (bytes32)
```



```
    function modifyStatus(
        bytes32 subscriptionHash,
        SubscriptionStatus status,
        bytes signature
    )
        public
        returns (bool)
```



```
    function executeSubscription(
        address from, //the subscriber
        address to, //the target contract or account
        uint256 value, //amount in wei of ether sent from this contract to the to address
        bytes data, //the encoded transaction data (first four bytes of fn plus args, etc)
        Operation operation, //ENUM of operation
        uint256 periodSeconds, //the period in seconds between payments
        address gasToken, //the address of the token to pay relayer (0 for eth)
        uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
        address gasPayer, //the address that will pay the tokens to the relayer
        bytes signature //proof the subscriber signed the meta trasaction
    )
        public
        returns (bool)
 ```










Read more here: https://github.com/austintgriffith/token-subscription
