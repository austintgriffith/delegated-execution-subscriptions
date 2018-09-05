# 🕰️⚙️ Delegated Execution Subscriptions [EIP1337/EIP948]

> Recurring Ethereum transactions executed through an identity proxy using a single, replayed meta transaction.

A subscriber deploys and funds a proxy (identity) contract. Then, any whitelisted etherless account signs a single off-chain meta transaction that will be periodically sent on-chain to trigger an Ethereum transaction. This transaction can be sending ETH, interacting with a contract, or even deploying a new contract.

This project is the culmination of months of research and two previous POCs:

[**Bouncer Proxy**](https://github.com/austintgriffith/bouncer-proxy)
    The bouncer-proxy POC demonstrated how an identity contract could be deployed as a proxy and then interacted with using meta transactions. Etherless accounts could be whitelisted and sign off-chain transactions which are then submitted on-chain by incentivized relayers, cryptographically proven, and used to execute typical Ethereum transactions.

[**Token Subscriptions**](https://github.com/austintgriffith/token-subscription)
    Token subscriptions are a bare minimum POC to demonstrate how meta transactions can be used with a timestamp nonce trick to replay a single transaction on a periodic basis. We used the ERC20 approve/allowance to control the flow of tokens without the need of other complicated mechanics.

> **Delegated Execution Subscriptions** bring these two concepts together.

An identity contract is controlled by whitelisted, etherless accounts to periodically interact with the blockchain signaled by a single meta transaction. **A set it and forget it subscription periodically executes standard Ethereum transactions** powered by an incentivized layer of meta transaction relayers.

## Demo

[![screencast.png](https://user-images.githubusercontent.com/2653167/45005225-6d23cb00-afaf-11e8-9ce1-874dd8cb1980.jpg)](https://youtu.be/g0o2jEkyYKw)

[https://byoc.metatx.io](https://byoc.metatx.io)

## Development

See full development history on [this byoc branch](https://github.com/austintgriffith/token-subscription/commits/byoc).

## Abstract

A _subscriber_ can deploy a _subscription contract_ to act as their identity and proxy their meta transactions. The _subscriber_ must only sign a single, off-chain meta transaction to start the flow of recurring Ethereum transactions. This meta transaction is periodically sent to the _subscription contract_ via an incentivized relayer network.

The single meta transaction becomes valid using a timestamp nonce (instead of a traditional replay attack nonce). The meta transaction can be submitted, proven valid through *ecrecover()*, and then a *call()*, *delegateCall()*, or *create()* is executed by the _subscription contract_.

The _subscriber_ is in full control of the _subscription contract_ but any account they whitelist can also create new subscriptions or pause existing ones without having to hold any ETH. Further, the terms of each subscription is explicitly signed in the meta transaction and can't be manipulated.

Meta transactions can be submitted by any relayer and the relayer can be incentivized with a _gasToken_. This token can be paid by the _publisher_, the _subscriber_, or the _subscription contract_. The _subscription contract_ can also reimburse the relayers directly with Ethereum.


```
 ██╗██████╗ ██████╗ ███████╗
███║╚════██╗╚════██╗╚════██║
╚██║ █████╔╝ █████╔╝    ██╔╝
 ██║ ╚═══██╗ ╚═══██╗   ██╔╝
 ██║██████╔╝██████╔╝   ██║  
 ╚═╝╚═════╝ ╚═════╝    ╚═╝  -EIP-
 ```

 [https://github.com/ethereum/EIPs/pull/1337](https://github.com/ethereum/EIPs/pull/1337)


## Standard


```SOLIDITY
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


```SOLIDITY
  event ExecuteSubscription(
      address from, //the subscriber
      address to, //the target contract or account
      uint256 value, //amount in wei of ether sent from this contract to the to address
      bytes data, //the encoded transaction data (first four bytes of fn plus args, etc)
      Operation operation, //ENUM of operation
      uint256 periodSeconds, //the period in seconds between payments
      address gasToken, //the address of the token to pay relayer (0 for eth)
      uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)
      address gasPayer //the address that will pay the tokens to the relayer
  );
```


```SOLIDITY
    function updateWhitelist(
        address _account,
        bool _value
    )
        public
        onlyOwner
        returns (bool)
```


```SOLIDITY
    function isSubscriptionPaid(
        bytes32 subscriptionHash,
        uint256 gracePeriodSeconds
    )
        external
        view
        returns (bool)
```



```SOLIDITY
    function getSubscriptionStatus(
        bytes32 subscriptionHash
    )
        public
        view
        returns  (uint256)
```



```SOLIDITY
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


```SOLIDITY
    function getSubscriptionSigner(
        bytes32 subscriptionHash, //hash of subscription
        bytes signature //proof the subscriber signed the meta trasaction
    )
        public
        pure
        returns (address)
```


```SOLIDITY
    function isSubscriptionReady(
        address from, //the subscriber
        address to, //the publisher
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
        view
        returns (bool)
```



```SOLIDITY
    function isValidSignerTimestampAndStatus(
        address from,
        address signer,
        bytes32 subscriptionHash
    )
        public
        view
        returns (bool)
```




```SOLIDITY
    function getModifyStatusHash(
        bytes32 subscriptionHash,
        SubscriptionStatus status
    )
        public
        view
        returns (bytes32)
```



```SOLIDITY
    function isValidModifyStatusSigner(
        bytes32 subscriptionHash,
        SubscriptionStatus status,
        bytes signature
    )
        public
        view
        returns (bool)
```



```SOLIDITY
    function modifyStatus(
        bytes32 subscriptionHash,
        SubscriptionStatus status,
        bytes signature
    )
        public
        returns (bool)
```



```SOLIDITY
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



## Acknowledgments

Original Proposal: [https://gist.github.com/androolloyd/0a62ef48887be00a5eff5c17f2be849a](https://gist.github.com/androolloyd/0a62ef48887be00a5eff5c17f2be849a)

Directly extended from: [https://github.com/austintgriffith/token-subscription](https://github.com/austintgriffith/token-subscription)

Huge thanks to [Owocki](https://twitter.com/owocki) & [Seagraves](https://twitter.com/captnseagraves) of [Gitcoin](https://gitcoin.co/) and [Andrew Redden](https://twitter.com/androolloyd) of [Groundhog](https://groundhog.network) for the guidance!!!
