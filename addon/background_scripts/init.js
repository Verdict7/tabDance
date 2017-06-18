//Called when tab changes
//Only handles url changes
function handleUpdated(tabId, changeInfo, tabInfo) {
  //Distinguish: URL change (clicked on link)
  //Placement change (moved tab around) TODO
  //Closed tab TODO
  if (changeInfo.url) {
		console.log(tabInfo);
    console.log("Tab: " + tabId +
                " URL changed to " + changeInfo.url);
  }
}

browser.tabs.onUpdated.addListener(handleUpdated);

//Called when new tab is created
function handleCreated(tab) {
  console.log(tab.id);
  console.log(tab.url);
}

browser.tabs.onCreated.addListener(handleCreated);

//Called when browser (window?) is closed TODO
var handleClosed = function(){
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
