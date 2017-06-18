//TODO: What happens when we have several windows?
//TODO: Move tab between windows (onDetached)


var backgroundFun = (function(){

  function onErr(err){
    console.log("Error!");
    console.log(err);
  }


  /** Update the sync info
  /* @type The Type of update (create, delete, ...)
   * @value The tab information
   */
  function setData(type, value){
    function onStorageReady(result){
      result.updateInformation = result.updateInformation || [];
        result.updateInformation.push({type : type, value : value});
          browser.storage.local.set({
            updateInformation : result.updateInformation
          });
      }
    var getting = browser.storage.local.get(["updateInformation"]);
    getting.then(onStorageReady, onErr);
  }

  function removeUpdateInformation(){
    browser.storage.local.set({
      updateInformation : []
    });
  }



  //Called when tab changes
  //Only handles url changes
  function handleUpdated(tabId, changeInfo, tabInfo) {
    //Distinguish: URL change (clicked on link)
    if (changeInfo.url) {
      console.log(tabInfo);
      console.log("Tab: " + tabId +
                  " URL changed to " + changeInfo.url);
    }
  }



  //Called when tabs are closed
  function handleRemoved(tabId, removeInfo){
    console.log("Tab: " + tabId + " closed!");
  }


  //Called when tabs are moved
  function handleMoved(tabId, moveInfo){
    console.log("Tab: " + tabId + "moved from " + moveInfo.fromIndex + " to " + moveInfo.toIndex + ".");
  }


  //Called when new tab is created
  function handleCreated(tab) {
    console.log("New Tab with id " + tab.id + " created.");
    console.log(tab.url);
  }



  var updateInterval = function(){
    mergeRemote(); //Calls pushBacklog asynchronously
  }

  /**
   * Get changes from remote that are newer than last update,
   * merge changes if necessary.
   */
  var mergeRemote = function(){
    //Get changes
    //Compare changes
    //Merge changes
  }

  /**
   * Use Rest api to push local changes to server
   */
  var pushBacklog = function(){
    //Read storage
    var getting = browser.storage.local.get(["activityLog"]);
    getting.then(onStorageReady, onErr);
    //Push to remote
  }

  return {
    handleCreated : handleCreated,
    handleUpdated : handleUpdated,
    handleMoved : handleMoved,
    handleRemoved : handleRemoved,
    updateInterval : updateInterval,
    setData : setData,
    removeUpdateInformation : removeUpdateInformation
  }
})();


console.log("init bg");
//Add the event listeners
browser.tabs.onCreated.addListener(backgroundFun.handleCreated); //new tab
browser.tabs.onUpdated.addListener(backgroundFun.handleUpdated); //new url
browser.tabs.onMoved.addListener(backgroundFun.handleMoved); //move tab
browser.tabs.onRemoved.addListener(backgroundFun.handleRemoved); //close tab

//TODO Also add the interval that sends changes to server
