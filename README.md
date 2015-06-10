# SpecDetec
Collection of OS-specific tools to gather environment + capability specs.

## Usage

`SpecDetec` is a singleton static class. Begin with the `init()` method, optionally passing in a callback function, to run when stats have been collected:

```as3  
    SpecDetec.init(function():void{})
```

Alternately, attach a listener to the `Event.COMPLETE` event:

```as3  
    SpecDetec.addEventListener(Event.COMPLETE, function(e:Event):void{
        trace(e);
    }, false, 0, true);
    SpecDetec.init();
```

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