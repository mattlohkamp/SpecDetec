# SpecDetec
*Collection of OS-specific tools to gather environment + capability specs on the machine running an Adobe AIR application.*

---

## Usage

### init and optional callback function

`SpecDetec` is a singleton static class. Begin with the `init()` method, optionally passing in a callback function, to run when stats have been collected:

```as3  
    SpecDetec.init(function():void{});
```

**Note:** Callbacks passed in on subsequent `init()` calls will overwrite the previous ones - so in the following example, only func2 will be called on complete:

```as3  
    SpecDetec.init(func1);
    SpecDetec.init(func2);
```

### event listeners

Alternately, attach a listener to the `Event.COMPLETE` event:

```as3  
    SpecDetec.addEventListener(Event.COMPLETE, function(e:Event):void{
        trace(e);
    }, false, 0, true);
    SpecDetec.init();
```

**Note:** make sure not to double-dip, e.g. attach a 'complete' event listener *and* pass in a callback function, unless that's really what you want to do.

### checking ready state

Once the data gathering process has completed, you can check the `ready` property:

```as3  
    if(SpecDetec.ready){
        //  ready to check stats
    }else{
        //  not ready
    }
```

**Note**: there is no 'onChange'-type functionality available - if you need to check the most recent stats, try a 'polling' approach where SpecDetec is periodically re-initialized:

```as3  
    var specDetecTimer = new Timer(10000);
    specDetecTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void   {
        if(SpecDetec.ready){
            specDetecTimer.reset();
            SpecDetec.init(function(e:Event):void   {
                trace(e);   //  new batch of specs are now available
                specDetecTimer.start(); //  start the countdown until the specs are refreshed again
            });
        }
    }, false, 0, true);
    specDetecTimer.start();
```

### accessing specs

Each of these properties will return `undefined` if they have *not yet* been defined (e.g. while `SpecDetec.ready == false`,) return `null` if they could not be accessed / set in the current environemnt (permissions, capabilities, bugs in my code, whatever the reason,) or a value, as shown in this example:

```as3  
    trace(SpecDetec.CPUIsIntel);    //  returns 'undefined' because init has not completed
    SpecDetec.init(function():void{
        trace(SpecDetec.CPUIsIntel);    //  returns true/false depending on system
        trace(SpecDetec.RAMtotal);    //  returns 'null' because (for the sake of this example) the data could not be accessed
    });
```