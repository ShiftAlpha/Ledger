# Constructors, Classes and Contracts

This is a note on the use of constructors, and especially how it pertains to smart contracts written in the [Solidity](http://solidity.readthedocs.io/en/develop/) language.

### Constructors and patterns

Constructors, or constructor functions, is used to control the way in which a class is instantiated. It is a special script that is run (only) when the object is being created. The constructor should ensure that the object has access to all the data it may need, and that it always ends up being in a valid starting state (according to the specification). Ensuring that can be hard though; for example, classes often delegate some of its work to other classes, or external libraries, or directly to the operating system. It is very common to pass references to instances of such classes through the constructor, or to create them there, which in turn means that the constructor also has to contain validation and error handling routines.

Putting (or simply invoking) advanced logic in the constructor is generally considered bad practice, though, and for good reasons. When a constructor is being run, the object is in a "partially initialized" state where some parts of the object has been created and initialized, but not all. This is such a sensitive state that even perfectly normal routines can behave in unexpected ways, and potentially open the object up for exploits. In Java, for example, you should [avoid throwing exceptions in the constructor](https://www.securecoding.cert.org/confluence/display/java/OBJ11-J.+Be+wary+of+letting+constructors+throw+exceptions), because the partially initialized object can be accessed from within error recovery code. In C++, you should [avoid calling certain virtual functions](https://www.securecoding.cert.org/confluence/display/cplusplus/OOP50-CPP.+Do+not+invoke+virtual+functions+from+constructors+or+destructors), because of how its inheritance works. Generally speaking, different languages have different problems, but partially initialized objects are always dangerous territory.

There are numerous different ways to work around these types of issues. One alternative is to use a design-by-contract approach: "If you hand me a proper file writer, then I guarantee that it will be used to write a configuration file that meets the standards X, Y and Z. I'm not gonna check if it works, that's on you. If it fails it fails". This approach can be improved further by utilizing the builder/factory pattern in combination with a non-public constructor.

```
/* Java example of a build function using a private constructor. */
class  PrivConst {

    SomeClass c;

    public static PrivConst build(SomeClass c) throws ... {
        checkAndThrowIfFail(c);
        return new PrivConst(c);
    }

    private PrivConst(SomeClass c) {
        this.c = c;
    }
    
    ...

}
```

In this example, the class needs a reference to an object of type `SomeClass`. The constructor does not have any error handling in it, because the only way to instantiate the class is through the static `build` method which does the checking for it. Basically - if the instance of `SomeClass` does not pass the validation, no new instance of `PrivConst` will be created.

Another alternative is to consider an un-initialized variable a valid (or rather, a possible) state, and handle it. This makes it possible to check input in setters, for example, rather then having to do it in the constructor.

```
/* Java example of a class where fields may be null. */
class NullField {

    private Something something;
    private boolean initialized;

    // This is only for show
    public NullField() {}
    
    // Here is when Something is added.
    public setSomething(Something s) throws ... {
        checkSomething(s);
        something = s;
    }
    
    public void doSomething() throws ... {
        if (something == null)
            throw SomeException("class is not initialized");
        something.do();
    }
    
    ...

}
```

The patterns used in these examples are potentially much safer then having a "smart" constructor (ie one with lots of code in it), but they can also cause their own security issues. In the first case, one could for example make the constructor visible by mistake. Also, in the second case, every created instance of the class will have to pass through a sequence of calls instead of just one.

### Ethereum contracts and Solidity

In order to find constructor anti-patterns in Solidity, we must first understand how Ethereum contract deployment works. The first thing that happens when an Ethereum contract is deployed (ie created and added to the system) is that a new account is created. The account is similar to a regular user (external) account but it has some important differences, some of which are:

- it has two additional fields - code and data storage. 
- It does not have its own keypair.
- It can not initiate transactions.

Contract accounts are created by sending a transaction to the address `0`, with the code of the new contract in the tx data field. What happens then - provided that everything goes well - is that a new account is created, assigned an address, and any ether that came with the transaction is added to its balance. The code that was included in the transaction is not simply stored in the new account though; what happens is that the client fires up a new VM and executes the code, starting from position 0 in the array. The code that starts from position 0 in contract bytecode is often referred to as the `init` section; usually it contains some simple logic to initialize certain storage adresses. A proper `init` section always ends by `RETURN`ing the `runtime` portion of the contract, which is the code that runs when the contract is later called. Unless part of the `init` code has been included in the runtime portion, for some reason, that code will never be executed in the context of that account ever again. It is run once, and that is when the contract is being deployed.

When coding in Solidity, you do not have to do these things manually; instead you create the init section by declaring (and initializing) fields, and by adding a constructor. Solidity code will automatically form an array consisting of proper `init` and `runtime` portions when compiled, although `runtime` code doesn't have to be included in the initial bytecode array, but could for example be copied from an existing contract through `EXTCODECOPY`, or be generated procedurally.

So, how can this help us detect constructor anti-patterns? Let's look at an example.

```
pragma solidity ^0.4.13;

contract A {
    address public caller;

    function f() { caller = msg.sender; }

}


contract B {
    function B(address addr) { A(addr).f(); }

}
```

This can be run in Remix, just copy the code, deploy `A`, copy its address, then deploy `B` and pass the address of `A` (inside double quotes) as the constructor parameter. When that is done, calling the `caller` function on `A` will return the address to `B`. This means that `B` must have had a reference to the contract account of `A` during the execution of `f`, which takes place while `B` is still being initialized - which means it did not have the runtime code in the account at that time, but the init code. This in turn means that certain security features provided by Solidity would not have been in effect.

Let's exploit this in a fairly benign way by sending some ether to a non `payable` contract:

```
pragma solidity ^0.4.13;

contract A {

    function A() payable {
        
    }

    function f() { 
        msg.sender.transfer(1);
    }
    
    function money() constant returns (uint balance) {
        balance = this.balance;
    }
    
    function() payable {}

}


contract B {
    function B(address addr) { 
        A(addr).f();
    }
    
    function money() constant returns (uint balance) {
        balance = this.balance;
    }

}
```

Running this in Remix works the exact same way, except after deploying `A`, call the fallback function with some value added to the "value" field near the top of the tab (where you choose your address and environment etc.), then copy the address and deploy `B` like it was done before. Note that when you run `money` on `B` after this, it will have 1 wei, even though it is not `payable`. `payable` works by reverting when the `CALLVALUE` (ie amount of ether transferred) is not zero, unless a payable fallback function is in place, and that code has not yet been added.

This exploit shows that partially initialized contracts do exist, and they can be addressed by other contracts if not careful, but it is not very harmful; the real problems happens when instructions like `CALLCODE` and `DELEGATECALL` are used during initialization, because the code they bring in operates on the contract account directly.

### Summation

Lots of hacking attempts are going on, and some of them has been successful, so it is important to be on guard and not make mistakes in the code. It should always be clear what the code does, and that contracts behaves like the creator intended. Knowing how to use constructors in a safe way is an important part of that.
