```
ConcaveNFT
   Deployment
     ✓ Owner of contract should be deployer
   Constants
     ✓ Name should be name
     ✓ Name should be name
     ✓ Symbol should be symbol
     ✓ Base URI should be ipfs://QmXytj58vtcvm9SwwBPvJykApcsr9aeChX4BcRha2wc31i/
     ✓ Unrevealed URI should be ipfs://QmYJJDthYUGV57FQ57VCeXcCBnpWoGjxtHsWcDLEY1Bp19
     ✓ Max Supply should be: 4317
     ✓ Price should be: 30000000000000000 wei
     ✓ Contract should be paused at launch
   Method Calls
     mint()
       ✓ Minting Should Fail with `Pausable: paused` when Paused
       ✓ Minting Should Not Fail with `Pausable: paused` when unpaused
       ✓ Minting Should Fail with 'minting too many' if minting more than 10
       ✓ If minting 0 - should revert with 'minting zero'
       ✓ If minting 10 - transaction should succeed and totalSupply should be 10
       ✓ If minting 10 - transaction should succeed and balanceOf owner should be 10
       ✓ Mint #201 and later should fail with 'insufficient funds' if amount sent is less price*value
       ✓ Mint #201 and later should pass if amount sent is = price*value
     reveal()
       ✓ Third Party must not be able to call reveal()
       ✓ Owner must be able to call reveal()
       ✓ token uri before reveal should be ipfs://QmYJJDthYUGV57FQ57VCeXcCBnpWoGjxtHsWcDLEY1Bp19
       ✓ token uri after reveal for token 0 should be ipfs://QmXytj58vtcvm9SwwBPvJykApcsr9aeChX4BcRha2wc31i/0.json
     unpause()
       ✓ Third Party must not be able to call unpause()
       ✓ Owner must be able to call unpause()
     pause()
       ✓ Third Party must not be able to call pause()
       ✓ Owner must be able to call pause()
       ✓ When paused, minting shouldnt be allowed, when unpaused minting should
     withdraw()
       ✓ Third Party must not be able to call unpause()
       ✓ Owner must be able to call withdraw()
       ✓ Calling withdraw should withdraw funds to contract owner
     setNotRevealedURI()
       ✓ Third Party must not be able to call setNotRevealedURI()
       ✓ Owner must be able to call setNotRevealedURI()
       ✓ setNotRevealedURI should succesfully change notRevealedUri
     setBaseURI()
       ✓ Third Party must not be able to call setBaseURI()
       ✓ Owner must be able to call setBaseURI()
       ✓ setBaseURI should succesfully change baseURI
     setMaxMintAmount()
       ✓ Third Party must not be able to call setMaxMintAmount()
       ✓ Owner must be able to call setMaxMintAmount()
       ✓ setMaxMintAmount should succesfully change maxMintAmount
     setPrice()
       ✓ Third Party must not be able to call setPrice()
       ✓ Owner must be able to call setPrice()
       ✓ setPrice should succesfully change price
     transferOwnership()
       ✓ Third Party must not be able to call transferOwnership()
       ✓ Owner must be able to call transferOwnership()
       ✓ transferOwnership should succesfully change owner

·------------------------------------|----------------------------|-------------|-----------------------------·
|        Solc version: 0.8.4         ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 30000000 gas  │
·····································|····························|·············|······························
|  Methods                           ·               100 gwei/gas               ·       4311.08 usd/eth       │
···············|·····················|·············|··············|·············|···············|··············
|  Contract    ·  Method             ·  Min        ·  Max         ·  Avg        ·  # calls      ·  usd (avg)  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  mint               ·     130330  ·     1168948  ·     173568  ·          408  ·      74.83  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  pause              ·          -  ·           -  ·      28099  ·            2  ·      12.11  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  reveal             ·          -  ·           -  ·      45754  ·            2  ·      19.72  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  setBaseURI         ·          -  ·           -  ·      32317  ·            2  ·      13.93  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  setMaxMintAmount   ·          -  ·           -  ·      28960  ·            2  ·      12.48  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  setNotRevealedURI  ·          -  ·           -  ·      32316  ·            2  ·      13.93  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  setPrice           ·          -  ·           -  ·      29003  ·            2  ·      12.50  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  transferOwnership  ·          -  ·           -  ·      29237  ·            2  ·      12.60  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  unpause            ·          -  ·           -  ·      28163  ·           14  ·      12.14  │
···············|·····················|·············|··············|·············|···············|··············
|  ConcaveNFT  ·  withdraw           ·      23769  ·       30469  ·      27119  ·            2  ·      11.69  │
···············|·····················|·············|··············|·············|···············|··············
|  Deployments                       ·                                          ·  % of limit   ·             │
·····································|·············|··············|·············|···············|··············
|  ConcaveNFT                        ·          -  ·           -  ·    4177519  ·       13.9 %  ·    1800.96  │
·------------------------------------|-------------|--------------|-------------|---------------|-------------·

 44 passing (12s)

✨  Done in 18.22s.
```
